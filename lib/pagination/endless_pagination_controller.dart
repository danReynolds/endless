class EndlessPaginationController<T> {
  /// Reloads the content of the scroll view, replacing the current items with the next result of calling
  /// loadMore()
  late void Function() reload;

  /// Clears the items from the paginated scroll view and reset the page index to 0.
  late void Function() clear;

  // Loads an additional page of items.
  late void Function() loadMore;

  /// Removes the given item from the scroll view
  late void Function(T item) remove;

  EndlessPaginationController();
}
