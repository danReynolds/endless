import 'dart:async';
import 'package:endless/stream/endless_stream_controller.dart';
import 'package:endless/stream/endless_stream_list_view_data.dart';
import 'package:endless/stream/endless_stream_scroll_view.dart';
import 'package:endless/stream/endless_stream_scroll_view_data.dart';
import 'package:endless/endless_state_property.dart';
import 'package:flutter/material.dart';

/// An infinite loading list view that builds items added to the stream into a scrollable list.
class EndlessStreamListView<T> extends StatelessWidget {
  /// A function which adds more items to the stream when the list view is scrolled
  /// to its threshold for loading more items determined by the [extentAfterFactor].
  final void Function() loadMore;

  /// The stream of items that will be added to the list view.
  final Stream<List<T>> stream;

  /// The builder function for the list view items.
  final Function(
    BuildContext context, {
    T item,
    int index,
    int totalItems,
  }) itemBuilder;

  /// The builder function for the list view header.
  final Widget Function(BuildContext context)? headerBuilder;

  /// The state property for the list view header.
  final EndlessStateProperty<Widget>? headerBuilderState;

  /// The builder function for the list view empty state.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// The state property for the list view empty state.
  final EndlessStateProperty<Widget>? emptyBuilderState;

  /// The builder function for the list view load more action widget.
  final Widget Function(BuildContext context)? loadMoreBuilder;

  /// The state property for the list view load more action widget.
  final EndlessStateProperty<Widget>? loadMoreBuilderState;

  /// The builder function for the list view footer.
  final Widget Function(BuildContext context)? footerBuilder;

  /// The state property for the list view footer.
  final EndlessStateProperty<Widget>? footerBuilderState;

  /// The builder function for the list view loading state.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// The state property for the list view loading state.
  final EndlessStateProperty<Widget>? loadingBuilderState;

  /// The stream controller used to perform actions on the list view such as loading more data
  /// or clearing the list.
  final EndlessStreamController<T>? controller;

  /// Whether to immediately request data from the stream when it is first subscribed to by calling
  /// the [loadMore] API.
  final bool? loadOnSubscribe;

  /// The padding around the scroll view.
  final EdgeInsets? padding;

  /// The padding in between each item in the list view.
  final EdgeInsets itemPadding;

  /// The fraction of the remaining quantity of content conceptually "below" the viewport in the scrollable
  /// relative to the maximum height of the scrollable region at which point [loadMore] should be called to
  /// load more data.
  final double? extentAfterFactor;

  const EndlessStreamListView({
    required this.loadMore,
    required this.itemBuilder,
    required this.stream,
    this.headerBuilder,
    this.headerBuilderState,
    this.emptyBuilder,
    this.emptyBuilderState,
    this.loadingBuilder,
    this.loadingBuilderState,
    this.loadMoreBuilder,
    this.loadMoreBuilderState,
    this.footerBuilder,
    this.footerBuilderState,
    this.controller,
    this.padding,
    this.extentAfterFactor = 0.4,
    this.loadOnSubscribe = true,
    this.itemPadding = EdgeInsets.zero,
    key,
  }) : super(key: key);

  static EndlessStreamListView fromData<Y>(EndlessStreamListViewData<Y> data) {
    return EndlessStreamListView<Y>(
      extentAfterFactor: data.extentAfterFactor,
      loadMore: data.loadMore,
      itemBuilder: data.itemBuilder,
      stream: data.stream,
      headerBuilder: data.headerBuilder,
      headerBuilderState: data.headerBuilderState,
      emptyBuilder: data.emptyBuilder,
      emptyBuilderState: data.emptyBuilderState,
      loadingBuilder: data.loadingBuilder,
      loadingBuilderState: data.loadingBuilderState,
      loadMoreBuilder: data.loadMoreBuilder,
      loadMoreBuilderState: data.loadMoreBuilderState,
      footerBuilder: data.footerBuilder,
      footerBuilderState: data.footerBuilderState,
      controller: data.controller,
      padding: data.padding,
      loadOnSubscribe: data.loadOnSubscribe,
      itemPadding: data.itemPadding ?? EdgeInsets.zero,
    );
  }

  @override
  Widget build(context) {
    return EndlessStreamScrollView<T>(
      scrollViewBuilder: (context, items) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final itemWidget = itemBuilder(
                context,
                item: items[index],
                index: index,
                totalItems: items.length,
              );

              if (index > 0) {
                return Padding(
                  padding: itemPadding,
                  child: itemWidget,
                );
              }

              return itemWidget;
            },
            childCount: items.length,
          ),
        );
      },
      loadMoreScrollViewData: EndlessStreamScrollViewData<T>(
        extentAfterFactor: extentAfterFactor,
        loadMore: loadMore,
        headerBuilder: headerBuilder,
        emptyBuilder: emptyBuilder,
        loadingBuilder: loadingBuilder,
        loadMoreBuilder: loadMoreBuilder,
        footerBuilder: footerBuilder,
        headerBuilderState: headerBuilderState,
        emptyBuilderState: emptyBuilderState,
        loadingBuilderState: loadingBuilderState,
        loadMoreBuilderState: loadMoreBuilderState,
        footerBuilderState: footerBuilderState,
        controller: controller,
        stream: stream,
        loadOnSubscribe: loadOnSubscribe,
        padding: padding,
      ),
    );
  }
}
