class EndlessStreamBatchDelegate {
  final double extentAfterFactor;
  final int batchSize;

  EndlessStreamBatchDelegate({
    required this.batchSize,
    // Default to fetching the next batch once the scroll view has less than 40%
    // of the available space left to scroll
    this.extentAfterFactor = 0.4,
  });
}
