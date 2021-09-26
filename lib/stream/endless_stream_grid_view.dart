import 'dart:async';
import 'package:endless/stream/endless_stream_controller.dart';
import 'package:endless/stream/endless_stream_grid_view_data.dart';
import 'package:endless/stream/endless_stream_scroll_view.dart';
import 'package:endless/stream/endless_stream_scroll_view_data.dart';
import 'package:endless/endless_state_property.dart';
import 'package:flutter/material.dart';

class EndlessStreamGridView<T> extends StatelessWidget {
  final void Function() loadMore;
  final Stream<List<T>> stream;
  final Function(BuildContext context, {T item, int index, int totalItems})
      itemBuilder;
  final EndlessStreamController<T>? controller;
  final bool? loadOnSubscribe;
  final SliverGridDelegate gridDelegate;
  final EdgeInsets? padding;

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

  final double? extentAfterFactor;

  const EndlessStreamGridView({
    required this.loadMore,
    required this.itemBuilder,
    required this.gridDelegate,
    required this.stream,
    this.extentAfterFactor,
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
    this.loadOnSubscribe = true,
    this.padding = const EdgeInsets.all(0),
    key,
  }) : super(key: key);

  static EndlessStreamGridView fromData<Y>(EndlessStreamGridViewData<Y> data) {
    return EndlessStreamGridView<Y>(
      gridDelegate: data.gridDelegate,
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
    );
  }

  @override
  Widget build(context) {
    return EndlessStreamScrollView<T>(
      scrollViewBuilder: (context, items) {
        return SliverGrid(
          gridDelegate: gridDelegate,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return itemBuilder(
                context,
                item: items[index],
                index: index,
                totalItems: items.length,
              );
            },
            childCount: items.length,
          ),
        );
      },
      loadMoreScrollViewData: EndlessStreamScrollViewData<T>(
        extentAfterFactor: extentAfterFactor,
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
        loadMore: loadMore,
        controller: controller,
        stream: stream,
        loadOnSubscribe: loadOnSubscribe,
        padding: padding,
      ),
    );
  }
}
