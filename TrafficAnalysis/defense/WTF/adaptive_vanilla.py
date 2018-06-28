from __future__ import print_function

import argparse
import logging
from bisect import insort_left
from copy import deepcopy
from sys import stdout

from os.path import basename

from base import *
from histogram import PaddingHistogram, single_bin_histogram, exponential_bins
from parse import get_trace, dump_tuple_list, mkrow

# AP states
GAP = 'gap'
BURST = 'burst'
WAIT = 'wait'


class Stream(Trace):
    """Provides `Trace` with a structure to keep flow-dependent variables."""

    def __init__(self, direction):
        self.direction = direction
        self.eiat = 0.0  # expected inter-arrival time
        self.expired = False  # means the eiat has expired
        self.state = BURST  # burst is the initial state

    def update_state(self, packet):
        """Switch state accordingly to AP machine state."""
        if self.state is WAIT:
            if packet.real:
                self.state = BURST
        elif self.state is BURST:
            if self.expired:
                self.state = GAP
            elif INF == self.eiat:
                self.state = WAIT
        elif self.state is GAP:
            if INF == self.eiat or packet.real:
                self.state = BURST


class APSimulator(object):
    """Simulates Adaptive Padding as specified by Shmatikov and Wang."""

    def __init__(self, histograms, flength=None):
        """Initialize APSimulator.

        :param histograms: histograms that govern the padding added by AP.
        :type histograms: APSet of PaddingHistograms.
        :param flength: function that provides lengths of packets.
        :type flength: function that returns int.
        """
        self.histograms = histograms
        self.flength = lambda: MTU if flength is None else flength

    def simulate(self, trace):
        """Adaptive Padding simulation of a trace.

        This simulator uses the histograms proposed in the adaptive padding
        primitives described in the following Tor proposal:
            https://bitbucket.org/mjuarezm/obfsproxy_wfpadtools
        """
        trace = deepcopy(trace)
        flows = {IN: Stream(IN), OUT: Stream(OUT)}
        for i, p in enumerate(trace):
            upstream, downstream = flows[p.direction], flows[-p.direction]
            upstream.update_state(p)
            self.pad(i, trace, upstream, SND)
            self.pad(i, trace, downstream, RCV)
            p.length = self.flength()
            upstream.append(p)
        trace.sort(key=lambda x: x.timestamp)
        trace.calculate_iats()
        return trace

    def pad(self, i, trace, stream, on):
        """Add dummy packets into the stream."""
        if stream.state is WAIT:  # do not pad
            return
        packet = trace[i]
        eiat = self.histograms.get(stream.direction, stream.state, on).sample()
        logging.debug("New expected iat sampled: %s", eiat)
        try:
            iat = trace.get_iat(i, stream.direction)
        except IndexError:  # raised if current packet is last of stream
            return
        stream.expired, stream.timeout = False, eiat
        if eiat < iat:  # timeout has expired
            stream.expired = True
            dummy = self.generate_dummy(packet, stream, eiat)
            logging.debug("Adding padding message into stream.")
            insort_left(trace, dummy)  # add dummy
        elif eiat >= iat:
            eiat = iat  # correct iat
        self.histograms.get(packet.direction, stream.state, on).remove_token(eiat)

    def generate_dummy(self, packet, stream, eiat):
        """Return a dummy packet."""
        return Packet(packet.timestamp + eiat, self.flength(), stream.direction, dummy=True)


def load_and_simulate(path, new_path=False, hists=False):
    simulator = APSimulator(hists)
    before_trace = get_trace(path)
    after_trace = Trace()
    try:
        after_trace = simulator.simulate(before_trace)
    except TraceError as e:
        print("Exception: %s", e)
        return None
    dump_tuple_list(join(new_path, basename(path)), after_trace.as_tuple_list())
    return bw_overhead(before_trace, after_trace)


def split_histograms(long_list, nbins):
    """Return a dictionary of histograms as expected by the AP Simulator."""
    histograms = APSet(list, {})
    chunks = [long_list[x:x + nbins] for x in xrange(0, len(long_list), nbins)]
    for i, key in enumerate(INDIVIDUAL_ORDER):
        if i < len(chunks):
#            labels = exponential_bins(nbins, a=0, b=MAX_IAT)    ## vanilla
            labels = exponential_bins(nbins-1, a=0, b=MAX_IAT)    ## corrected 
            h = PaddingHistogram(chunks[i], labels)
        else:
            h = single_bin_histogram()
        histograms.set(*(key + (h,)))
    return histograms


def AdaptiveDefense(data_path, histogram, output):
    logging.info("Starting AP simulation...")
    logging.info("Reading histograms from %s", histogram)
    tokens = list()
    with open(histogram, "r") as fi:
        for each_line in fi:
            to = map(int, each_line.strip().split())
            tokens.extend(to)
    logging.debug("Histogram tokens are: %s", tokens)
    simulator = APSimulator(split_histograms(tokens, nbins=NUM_BINS))
    trace_before = get_trace(data_path)
    trace_after = simulator.simulate(trace_before)
    if output:
        dump_tuple_list(trace_after.as_tuple_list(), output)
#    for p in trace_after:
#        print(mkrow(p.timestamp, p.direction * p.length), file=stdout)
    bw_ovhd = bw_overhead(trace_before, trace_after)
#    logging.info("Length before: {0} | Length after: {1}".format(len(trace_before), len(trace_after)))
#   logging.info("Bandwidth overhead: %s", bw_ovhd)


if __name__ == '__main__':
    logging.basicConfig(filename="debug.log", level=logging.INFO)
#    argparser = argparse.ArgumentParser(description='Adaptive Padding simulator.')
#    argparser.add_argument('--data-path', '-p',
#                           required=True,
#                           type=str,
#                           help='''path to the trace file.''')
#    argparser.add_argument('--histogram', '-t',
#                           required=True,
#                           type=str,
#                           help='''path to histogram file.''')
#    argparser.add_argument('--log-file', '-l',
#                           required=False,
#                           default=join(LOG_DIR, 'adaptive.log'),
#                           type=str,
#                           help='''path to the log file.''')
#    argparser.add_argument('--output', '-o',
#                           required=False,
#                           type=str,
#                           help='''path to output file.''')
#    argparser.add_argument('--debug', '-d',
#                           required=False,
#                           action='store_true',
#                           default=False,
#                           help='''enable debug logging level.''')
#    args = argparser.parse_args()
#    loglevel = logging.INFO
#    if args.debug:
#        loglevel = logging.DEBUG
#    logging.basicConfig(filename=args.log_file, level=loglevel,
#                        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
#    del args.debug
#    del args.log_file
#    main(**vars(args))
