/// The delegate that specifies the Firestore query requirements such as the [batchSize]
/// and maximum number of batches to load.
class EndlessFirestoreStreamBatchDelegate {
  /// The maximum number of batches to load. If unspecified, will support loading an infinite
  /// number of batches until a batch loads fewer than [batchSize] documents.
  final int? maxBatches;

  /// The expected number of new documents to be returned per batch. Used to determine if the scroll view
  /// should stop loading data when fewer than [batchSize] new documents are returned from the latest query execution.
  final int batchSize;

  EndlessFirestoreStreamBatchDelegate({
    required this.batchSize,
    this.maxBatches,
  });
}
