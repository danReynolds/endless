/// The delegate that specifies the Firestore query requirements such as the [batchSize]
/// and maximum number of batches to load.
class EndlessFirestoreStreamController<T> {
  late void Function({bool lazy}) clear;
  late void Function() loadMore;
}
