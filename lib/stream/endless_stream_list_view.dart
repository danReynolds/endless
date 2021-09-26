import 'dart:async';
import 'package:endless/stream/endless_stream_batch_delegate.dart';
import 'package:endless/stream/endless_stream_controller.dart';
import 'package:endless/stream/endless_stream_list_view_data.dart';
import 'package:endless/stream/endless_stream_scroll_view.dart';
import 'package:endless/stream/endless_stream_scroll_view_data.dart';
import 'package:endless/endless_state_property.dart';
import 'package:flutter/material.dart';

class EndlessStreamListView<T> extends StatelessWidget {
  final void Function(int batchSize) loadMore;
  final Stream<List<T>> stream;
  final Function(BuildContext context, {T item, int index, int totalItems})
      itemBuilder;

  final Widget Function(BuildContext context)? headerBuilder;
  final EndlessStateProperty<Widget>? headerBuilderState;

  final Widget Function(BuildContext context)? emptyBuilder;
  final EndlessStateProperty<Widget>? emptyBuilderState;

  final Widget Function(BuildContext context)? loadMoreBuilder;
  final EndlessStateProperty<Widget>? loadMoreBuilderState;

  final Widget Function(BuildContext context)? footerBuilder;
  final EndlessStateProperty<Widget>? footerBuilderState;

  final Widget Function(BuildContext context)? loadingBuilder;
  final EndlessStateProperty<Widget>? loadingBuilderState;

  final EndlessStreamController<T>? controller;
  final bool? loadOnSubscribe;
  final EdgeInsets? padding;
  final EdgeInsets itemPadding;
  final EndlessStreamBatchDelegate batchDelegate;

  const EndlessStreamListView({
    required this.loadMore,
    required this.itemBuilder,
    required this.stream,
    required this.batchDelegate,
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
    this.loadOnSubscribe = true,
    this.itemPadding = EdgeInsets.zero,
    key,
  }) : super(key: key);

  static EndlessStreamListView fromData<Y>(EndlessStreamListViewData<Y> data) {
    return EndlessStreamListView<Y>(
      batchDelegate: data.batchDelegate,
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
        batchDelegate: batchDelegate,
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
