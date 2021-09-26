import 'dart:async';
import 'package:endless/endless_state_property.dart';
import 'package:endless/pagination/endless_pagination_controller.dart';
import 'package:endless/pagination/endless_pagination_delegate.dart';
import 'package:endless/pagination/endless_pagination_stream_builder.dart';
import 'package:endless/stream/endless_stream_list_view.dart';
import 'package:endless/stream/endless_stream_list_view_data.dart';
import 'package:flutter/material.dart';

class EndlessPaginationListView<T> extends StatelessWidget {
  final Future<List<T>> Function(int pageIndex) loadMore;
  final Widget Function(
    BuildContext context, {
    T item,
    int index,
    int totalItems,
  }) itemBuilder;
  final EndlessPaginationController<T>? controller;
  final bool? initialLoad;
  final EdgeInsets? padding;
  final EdgeInsets? itemPadding;
  final EndlessPaginationDelegate paginationDelegate;
  final double? extentAfterFactor;

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

  const EndlessPaginationListView({
    required this.loadMore,
    required this.itemBuilder,
    required this.paginationDelegate,
    this.extentAfterFactor,
    this.controller,
    this.padding,
    this.itemPadding,
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
    this.initialLoad,
    key,
  }) : super(key: key);

  @override
  Widget build(context) {
    return EndlessPaginationStreamBuilder.fromData<T>(
      EndlessPaginationData(
        loadMore: loadMore,
        paginationDelegate: paginationDelegate,
        initialLoad: initialLoad,
        controller: controller,
        builder: ({
          required loadMore,
          required controller,
          required loadOnSubscribe,
          required stream,
        }) {
          // We use this pattern to ensure that all fields from the list view public API
          // are passed through from the paginated list view to the stream list view. Otherwise,
          // a non-required public API could be omitted here and we wouldn't realize it.
          return EndlessStreamListView.fromData<T>(
            EndlessStreamListViewData<T>(
              extentAfterFactor: extentAfterFactor,
              itemBuilder: itemBuilder,
              loadMore: loadMore,
              controller: controller,
              stream: stream,
              headerBuilder: headerBuilder,
              headerBuilderState: headerBuilderState,
              emptyBuilder: emptyBuilder,
              emptyBuilderState: emptyBuilderState,
              loadingBuilder: loadingBuilder,
              loadingBuilderState: loadingBuilderState,
              loadMoreBuilder: loadMoreBuilder,
              loadMoreBuilderState: loadMoreBuilderState,
              footerBuilder: footerBuilder,
              footerBuilderState: footerBuilderState,
              padding: padding,
              itemPadding: itemPadding,
              loadOnSubscribe: loadOnSubscribe,
            ),
          );
        },
      ),
    );
  }
}
