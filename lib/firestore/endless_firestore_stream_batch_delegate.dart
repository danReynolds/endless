class EndlessFirestoreStreamBatchDelegate {
  final int? maxBatches;
  final int batchSize;

  EndlessFirestoreStreamBatchDelegate({
    required this.batchSize,
    this.maxBatches,
  });
}
