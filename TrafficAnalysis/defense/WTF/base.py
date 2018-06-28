from contextlib import contextmanager
from itertools import chain
from os.path import dirname, realpath, join, abspath, pardir, expanduser
from shutil import rmtree
from tempfile import mkdtemp


# global variables
# network
IN = -1
OUT = 1
RCV = 'rcv'
SND = 'snd'
CLIENT = 'client'
SERVER = 'server'
BURST = 'burst'
GAP = 'gap'
DIRECTIONS = [IN, OUT]
ENDPOINTS = [CLIENT, SERVER]
MODES = [BURST, GAP]
ON = [RCV, SND]
CELL_SIZE = 512
#MTU = 1500  # maximum transmission unit in bytes
MTU = 1  # Shuai: we do in cell
INF = 1000000  # infinity label in the histogram

# AP
# bin number (including the INF bin)
NUM_BINS = 16
MAX_IAT = 3  # seconds
#DEFAULT_BURST_PROB = 0.95 ### too costy
DEFAULT_BURST_PROB = 0.2
PERCENTILE = 0.5
NDSS_BURST_LENGTH = {CLIENT: 21, SERVER: 34}
NDSS_PROB_BURST = {CLIENT: 0.1, SERVER: 0.05}

# GA

# individual parameters
NUM_HISTOS = 6
SIZE_INDIVIDUAL = NUM_HISTOS * NUM_BINS

# population
POPULATION_SIZE = 100  # 30, 100, 500

# token range
MIN_NUM_TOKS, MAX_NUM_TOKS = 0, 100

# weights for fitness function
ACC_WEIGHT = 10.0
OVHD_WEIGHT = 1.0

# population
POPULATION_SIZE = 100  # 30, 100, 500

# distribution of instances in training/testing
SITE_NUM = 10  # number of classes considered in kNN and WTF-PAD
INST_NUM = 1  # number of instances for distance training.
TEST_NUM = 5  # number of instances for training/testing in cross-validation.


# CSV
CSV_SEP = '\t'
NL = '\n'
TS_COL = 0  # the column of timestamps
SZ_COL = -1  # the column of packet sizes

# other
NUM_ATTEMPTS = 3

# paths
TRACES_FNAME = 'dataset'
ACC_FNAME = 'accuracy'
CURRENT_PATH = dirname(realpath(__file__))
BASE_DIR = abspath(join(CURRENT_PATH, pardir))
RESULTS_DIR = join(BASE_DIR, 'results')
ETC_DIR = join(BASE_DIR, 'etc')
PLOTS_DIR = join(BASE_DIR, 'plots')
LOG_DIR = join(BASE_DIR, 'logs')
TRACES_DIR = join('/volume1', 'scratch', 'mjuarezm', TRACES_FNAME)
FLEARNER_PATH = join('/volume1', 'scratch', 'mjuarezm', 'flearner.o')
GA_PATH = join(expanduser('~'), "rep", "git", "mine", "webfp", "defenses", "ga")
FILE_DIR = dirname(realpath(__file__))

# GA constants
INDIVIDUAL_ORDER = [(CLIENT, BURST, SND), (SERVER, BURST, SND),
                    (CLIENT, GAP, SND), (SERVER, GAP, SND),
                    (CLIENT, BURST, RCV), (CLIENT, GAP, RCV),
                    (SERVER, BURST, RCV), (SERVER, GAP, RCV)]


# global classes

class Packet(object):
    """Defines an abstraction of a network packet."""

    __slots__ = ('timestamp', 'direction', 'length', 'dummy', 'real',
                 'iat', 'iat_alt', 'iat_dir')

    def __init__(self, timestamp, length, direction=None, dummy=False):
        if length == 0:
            # we should have removed all SYNs and ACKs
            raise TraceError("Packet with no payload.")
        self.length = abs(int(length))
        self.timestamp = float(timestamp)
        self.direction = direction if direction else int(length) / self.length
        self.dummy = dummy
        self.real = not dummy

    def __lt__(self, packet):
        return self.timestamp < packet.timestamp


class Trace(list):
    """Define a network traffic trace as a list of Packets."""

    def __init__(self, fpath=None, packet_list=None):
        """Initialize list of packets."""
        self.fpath = fpath  # path to file representing a trace
        if packet_list:
            for p in packet_list:
                self.append(p)

    def __getslice__(self, i, j):
        """Override list slice."""
        return Trace(packet_list=list.__getslice__(self, i, j))

    def __add__(self, trace):
        """Override list's add method to concatenate traces."""
        return Trace(fpath=self.fpath, packet_list=list.__add__(self, trace))

    def __mul__(self, trace):
        """Override list's mul method to replicate traces."""
        return Trace(list.__mul__(self, trace))

    def get_iat(self, i, direction):
        """Find next packet and substract their timestamps."""
        next_packet = self[self.get_next_by_direction(i, direction)]
        return piat(self[i], next_packet)

    def get_next_by_direction(self, i, direction):
        """Return index of next packet in the given `direction`."""
        for j, p in enumerate(self[i + 1:]):
            if p.direction == direction:
                return i + j + 1
        raise IndexError("No more packets in this direction.")

    def yield_packet_flow_index(self, direction):
        """Generator that yields packets in a single `direction`."""
        for i, p in enumerate(self):
            if p.direction == direction:
                yield i

    def yield_packet_flow(self, direction):
        """Generator than yields packets in a single `direction`."""
        for p in self:
            if p.direction == direction:
                yield p

    def get_iats_alt(self, direction):
        """Compute iats received."""
        iats = []
        j = 0
        for i in self.yield_packet_flow_index(direction):
            p0 = self[i]
            if j == 0:
                p0.iat_alt = 0
            j += 1
            try:
                p1 = self[self.get_next_by_direction(i, -direction)]
                iat = piat(p0, p1, quiet=True)
                p1.iat_alt = iat
                iats.append(iat)
            except IndexError:
                break
        return iats

    def get_iats_direction(self, direction):
        """Recompute the iats in one single direction."""
        i = 0
        iats = []
        flow = [p for p in self.yield_packet_flow(direction)]
        for p0, p1 in zip(flow[:-1], flow[1:]):
            p1.iat_dir = piat(p0, p1, quiet=True)
            if i == 0:
                p0.iat_dir = 0.0
                iats.append(p0.iat_dir)
            iats.append(p1.iat_dir)
            i += 1
        return iats

    def get_iats(self):
        """Recompute the iats for the whole trace."""
        iats = []
        self[0].iat = 0.0
        for p0, p1 in zip(self[:-1], self[1:]):
            p1.iat = piat(p0, p1, quiet=True)
            iats.append(p1.iat)
        return iats

    def calculate_iats(self):
        """Recalculate all iats."""
        if len(self) < 2:
            return
        iats = self.get_iats()
        iats_dir = {IN: [], OUT: []}
        iats_alt = {IN: [], OUT: []}
        for direction in DIRECTIONS:
            iats_dir[direction] = self.get_iats_direction(direction)
            iats_alt[direction] = self.get_iats_alt(direction)
        return iats, iats_dir, iats_alt

    def total_time(self, dummies=True):
        """Return total time of the trace."""
        iats = [pkt.iat for pkt in self if dummies or not pkt.dummy]
        if len(iats) < 2:
            return 0
        return self[-1].timestamp - self[0].timestamp
        # return sum(iats)

    def total_bytes(self, dummies=True):
        """Return the total number of bytes of the trace."""
        return sum([pkt.length for pkt in self if dummies or not pkt.dummy])

    def total_bandwidth(self, dummies=True):
        """Return the total bandwidth."""
        total_time = self.total_time(dummies=dummies)
        if total_time == 0:
            return -1
        return self.total_bytes(dummies=dummies) / total_time

    def as_tuple_list(self):
        """Return trace as a list of tuples."""
        return [(p.timestamp, p.direction * p.length, p.dummy) for p in self]

    def bandwidth_overhead(self):
        after_bw = self.total_bandwidth(dummies=True)
        before_bw = self.total_bandwidth(dummies=False)
        if after_bw in [-1, 0] or before_bw == -1:
            return 1  # return maximum bw overhead
        return before_bw / after_bw


class UpdateInterface(object):
    def update(self, N, args):
        for attr in vars(self).itervalues():
            attr.update(N, args)


class Directions(object):
    def __init__(self, T, args):
        self.snd = T(**args)
        self.rcv = T(**args)

    def update(self, N, args):
            self.snd = N(self.snd, **args)
            self.rcv = N(self.rcv, **args)


class EndPoint(UpdateInterface):
    def __init__(self, T, args):
        self.burst = Directions(T, args)
        self.gap = Directions(T, args)


class APSet(UpdateInterface):
    """Data structure for AP instances in endpoints."""

    def __init__(self, T, args):
        self.client = EndPoint(T, args)
        self.server = EndPoint(T, args)

    def get(self, endpoint, direction, on):
        if endpoint in DIRECTIONS:
            endpoint = 'client' if endpoint == OUT else 'server'
        ep = getattr(self, endpoint)
        d = getattr(ep, direction)
        return getattr(d, on)

    def set(self, endpoint, direction, on, value):
        if endpoint in DIRECTIONS:
            endpoint = 'client' if endpoint == OUT else 'server'
        ep = getattr(self, endpoint)
        d = getattr(ep, direction)
        setattr(d, on, value)

    def to_individual(self):
        return list(chain.from_iterable([self.get(*k).tokens for k in INDIVIDUAL_ORDER]))


class BWElement(object):
    def __init__(self, start, end, trace):
        self.start = start
        self.end = end
        self.trace = trace
        self.direction = None
        if trace:
            self.direction = self.trace[self.start].direction

    def __len__(self):
        return self.end - self.start

    def iats(self):
        return [tiat(self.trace, i) for i in xrange(self.start, self.end)]


class Burst(BWElement):
    pass


class Gap(BWElement):
    pass


class TraceError(Exception):
    pass


# global methods

def total_time(l):
    if len(l) < 2:
        return 0
    return l[-1].timestamp - l[0].timestamp


def bw(l):
    try:
        return sum([p.length for p in l]) / total_time(l)
    except (TraceError, ZeroDivisionError):
        return None


def flow(l, direction):
    return [p for p in l if isdir(p, direction)]


def piat(p0, p1, quiet=True):
    iat = p1.timestamp - p0.timestamp
    if iat < 0:
        if quiet:
            return 0  # it's a negligible artifact. we can safely assume it's zero.
        raise TraceError("Negative iat.")
    return iat


def tiat(trace, i):
    if len(trace) < 2:
        raise TraceError("Trace only has two packets.")
    return piat(trace[i], trace[i + 1])


def low(l, th):
    if th <= 0:
        raise ValueError("Negative threshold.")
    tbw = bw(l)
    if not tbw:
        raise TraceError("Bandwidth cannot be computed.")
    return bw(l) < th


def isdir(p, direction):
    return p.direction == direction


def incoming(l):
    return flow(l, IN)


def outgoing(l):
    return flow(l, OUT)


def bwin(t):
    return bw(incoming(t))


def bwout(t):
    return bw(outgoing(t))


def bw_overhead(before_trace, after_trace):
    """Calculate bandwidth overhead of two traces."""
    bw_before, bw_after = map(bw, [before_trace, after_trace])
    if bw_before <= 0 or bw_after == -1:
        return None
    return bw_after / bw_before


def mymedian(l):
    from numpy import median
    return median([i for i in l if i is not None])


def memodict(f):
    """Memoization decorator for a function taking a single argument."""
    class memodict(dict):
        def __missing__(self, key):
            ret = self[key] = f(key)
            return ret
    return memodict().__getitem__


@contextmanager
def in_temp_dir():
    dir_fpath = mkdtemp()
    try:
        yield dir_fpath
    finally:
        rmtree(dir_fpath)


def readlines(file_path, t=str):
    with open(file_path, "r") as f:
        lines = f.readlines()
    return [t(l.strip()) for l in lines]
