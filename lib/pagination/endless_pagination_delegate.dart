import 'package:endless/stream/endless_stream_batch_delegate.dart';

class EndlessPaginationDelegate {
  final double extentAfterFactor;
  final int? maxPages;
  final int pageSize;

  EndlessPaginationDelegate({
    required this.pageSize,
    this.maxPages,
    this.extentAfterFactor = 0.4,
  });

  EndlessStreamBatchDelegate convertToStreamBatchDelegate() {
    return EndlessStreamBatchDelegate(
      batchSize: pageSize,
      extentAfterFactor: extentAfterFactor,
    );
  }
}
