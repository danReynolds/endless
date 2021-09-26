class EndlessFirestoreStreamController<T> {
  late void Function({bool lazy}) clear;
  late void Function() loadMore;
}
