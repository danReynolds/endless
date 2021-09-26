import 'package:endless/endless_state_property.dart';
import 'package:endless/stream/endless_stream_batch_delegate.dart';
import 'package:endless/stream/endless_stream_controller.dart';
import 'package:endless/stream/endless_stream_scroll_view_data.dart';
import 'package:flutter/material.dart';

class EndlessStreamGridViewData<T> extends EndlessStreamScrollViewData<T> {
  final Widget Function(
    BuildContext context, {
    T item,
    int index,
    int totalItems,
  }) itemBuilder;
  final SliverGridDelegate gridDelegate;

  EndlessStreamGridViewData({
    required this.itemBuilder,
    required this.gridDelegate,
    required EndlessStreamBatchDelegate batchDelegate,
    required Widget Function(BuildContext context)? headerBuilder,
    required Widget Function(BuildContext context)? emptyBuilder,
    required Widget Function(BuildContext context)? loadingBuilder,
    required Widget Function(BuildContext context)? loadMoreBuilder,
    required Widget Function(BuildContext context)? footerBuilder,
    required EndlessStateProperty<Widget>? headerBuilderState,
    required EndlessStateProperty<Widget>? emptyBuilderState,
    required EndlessStateProperty<Widget>? loadingBuilderState,
    required EndlessStateProperty<Widget>? loadMoreBuilderState,
    required EndlessStateProperty<Widget>? footerBuilderState,
    required void Function(int batchSize) loadMore,
    required Stream<List<T>> stream,
    required EndlessStreamController<T>? controller,
    required EdgeInsets? padding,
    required bool? loadOnSubscribe,
  }) : super(
          batchDelegate: batchDelegate,
          headerBuilder: headerBuilder,
          emptyBuilder: emptyBuilder,
          loadingBuilder: loadingBuilder,
          loadMoreBuilder: loadMoreBuilder,
          footerBuilder: footerBuilder,
          loadMore: loadMore,
          stream: stream,
          headerBuilderState: headerBuilderState,
          emptyBuilderState: emptyBuilderState,
          loadingBuilderState: loadingBuilderState,
          loadMoreBuilderState: loadMoreBuilderState,
          footerBuilderState: footerBuilderState,
          controller: controller,
          padding: padding,
          loadOnSubscribe: loadOnSubscribe,
        );
}
