
class TraceGenerator:
  def __init__(self, method, superseq, spoints):
    self.method = method
    self.supersequence = superseq
    self.stopPoints = spoints

  def create(self, transmit):
    assert transmit != 0
    idx = 0
    target = -1
    for idx in range(len(self.stopPoints)):
      point = self.stopPoints[idx]
      if transmit < point:
        target = point
        break

    if target == -1:
      return self.supersequence
    else:
      # stop points take stage
      pseq = self.supersequence[0][0:target]
      tseq = self.supersequence[1][0:target]
      return [pseq, tseq]

