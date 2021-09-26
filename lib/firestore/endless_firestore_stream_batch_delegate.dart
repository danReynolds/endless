import 'package:endless/stream/endless_stream_batch_delegate.dart';

class EndlessFirestoreStreamBatchDelegate {
  final int? maxBatches;
  final double extentAfterFactor;
  final int batchSize;

  EndlessFirestoreStreamBatchDelegate({
    required this.batchSize,
    this.maxBatches,
    this.extentAfterFactor = 0.4,
  });

  EndlessStreamBatchDelegate convertToStreamBatchDelegate() {
    return EndlessStreamBatchDelegate(
      batchSize: batchSize,
      extentAfterFactor: extentAfterFactor,
    );
  }
}
