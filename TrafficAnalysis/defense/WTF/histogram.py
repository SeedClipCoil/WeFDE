from bisect import bisect
from random import randint, uniform, sample
import numpy as np

from base import *
import logging

class PaddingHistogram(object):
    """Provides extra methods and properties to be used by AP.

    A la numpy:  all but the last (right-most) bin is half-open.
    """

    def __init__(self, tokens, labels):
        """Initialize tokens and labels from `values`."""
        self.tokens = list(tokens)
        self.labels = list(labels)
        self.template = list(self.tokens)

        logging.debug("tokens:%s\nlabels:%s/n", self.tokens, self.labels)

    def __len__(self):
        return len(self.labels)

    @property
    def area(self):
        """Return the total number of tokens in the histogram."""
        return sum(self.tokens)

    @property
    def expected(self):
        """Return the total number of tokens without counting infinity."""
        return self.area - self.tokens[-1]

    def update(self, tokens):
        self.tokens = tokens
        self.template = list(self.tokens)

    def is_infinity(self, i):
        """Return True if `i` is the index of the infinity bin.

        :param i: index of bin.
        :rtype: bool
        """
        return i == len(self) - 1

    def get_index(self, x):
        """Return index of label of `x`'s interval.

        :param x: value that must be within the range of labels.
        :type x: float
        :rtype: int
        """
        return bisect(self.labels, x) - 1

    def get_label(self, x):
        """Return the label for the interval to which `x` belongs.

        :param x: value that must be within the range of labels.
        :type x: float
        :rtype: float
        """
        index = self.get_index(x)
        if self.is_infinity(index):
            return INF
        return self.labels[index]

    def remove_token(self, x):
        """Remove a token from the histogram.

        :param x: value that must be within the range of labels.
        :type x: float
        """

        i = self.get_index(x)
        while i < len(self):
            if self.tokens[i] > 0:
                self.tokens[i] -= 1
                break
            i += 1
        if 0 == self.area:  # histogram is empty
            self.refill()

    def refill(self):
        """Reset the tokens from initialization."""
        self.tokens = list(self.template)

    def sample(self):
        """Draw a sample from the histogram.

        :returns: sample from the distribution defines by the histogram.
        :rtype: float
        """
        if 0 == self.area:
            raise ValueError("Histogram is empty and shouldn't be.")
        prob = randint(1, self.area)
        for i, label in enumerate(self.labels):
            prob -= self.tokens[i]
            if prob > 0:
                continue
            if self.is_infinity(i):
                return INF
            return uniform(label, self.labels[i + 1])


def single_bin_histogram():
    """Return an histogram with only one bin."""
    return PaddingHistogram(tokens=[100], labels=[0])


def exponential_bins(n, sample=None, a=None, b=None):
    """Return a exponentially distributed partition of the interval
     `[a, b]` with `n` number of bins.

    Alternatively, it can take a `sample` of data and extract the interval
    endpoints by taking the minimum and the maximum values in the sample.

    :param n: number of bins of the partition.
    :param sample: data sample to extract endpoints.
    :param a: minimum value of partition.
    :param b: maximum value of partition.
    """
    assert (sample is not None or (a is not None and b is not None))
    if sample:
        a, b = min(sample), max(sample)
    return ([b] + [a + (b - a) / 2.0 ** k for k in xrange(1, n)] + [a])[::-1]


def tokens_infinity_gap(gap_histo, burst_length):
    # GAPS
    # we take the expectation of the geometric distribution of consecutive
    # samples from histogram to be the average number of packets in a burst.

    # Therefore, the probability of falling into the inf bin should be:
    # p = 1/N, (note the variance is going to be high)
    # where N is the length of the burst in packets.

    # Then, the tokens in infinity value should be:
    #  p = #tokens in inf bin / #total tokens <=>
    #  #tokens in inf bin = #tokens in other bins / (N - 1)
    return int(gap_histo.expected / (burst_length - 1))


def tokens_infinity_burst(burst_histo, burst_prob):
    # BURSTS
    # burst_prob is the probability of adding a fake burst
    # after a real burst.

    # Tokens in infinity define the probability of the complementary
    # (not adding a burst). Then, we need to put as many tokens in
    # the infinity bin as:
    #  #tokens_inf = (1 - burst_prob) * (other_tokens + tokens_inf)
    #  <=> tokens_inf * burst_prob = (1 - burst_prob) * other_tokens
    #  <=> tokens_inf = (1 - burst_prob) / burst_prob * other_tokens
    p = (1 - burst_prob) / burst_prob
    return int(p * burst_histo.expected)


def histogram_from_list(l, num_samples=1000):
    counts, bins = np.histogram(sample(l, num_samples),
                                bins=exponential_bins(a=0, b=10, n=20))
    return PaddingHistogram(tokens=[0] + list(counts), labels=bins)


def histogram_from_distr(name, params, scale=1.0, num_samples=10000, bin_size=NUM_BINS):
    bins = exponential_bins(a=0, b=10, n=bin_size)
    if name == "weibull":
        shape = params
        counts, bins = np.histogram(np.random.weibull(shape, num_samples) * scale, bins)
    elif name == "beta":
        a, b = params
        counts, bins = np.histogram(np.random.beta(a, b, num_samples) * scale, bins)
    elif name == "logis":
        location, scale = params
        counts, bins = np.histogram(np.random.logistic(location, scale, num_samples), bins)
    elif name == "lnorm":
        mu, sigma = params
        counts, bins = np.histogram(np.random.lognormal(mu, sigma, num_samples), bins)
    elif name == "norm":
        mu, sigma = params
        counts, bins = np.histogram([s for s in np.random.normal(mu, sigma, num_samples) if s > 0], bins)
    elif name == "gamma":
        shape, scale = params
        counts, bins = np.histogram(np.random.gamma(shape, scale, num_samples), bins)
    elif name == "empty":
        return single_bin_histogram()
    else:
        raise ValueError("Unknown probability distribution.")
    return PaddingHistogram(tokens=[0] + list(counts), labels=bins)
