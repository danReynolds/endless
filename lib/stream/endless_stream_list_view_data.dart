import 'package:endless/endless_state_property.dart';
import 'package:endless/stream/endless_stream_controller.dart';
import 'package:endless/stream/endless_stream_scroll_view_data.dart';
import 'package:flutter/material.dart';

class EndlessStreamListViewData<T> extends EndlessStreamScrollViewData<T> {
  final Widget Function(
    BuildContext context, {
    required T item,
    required int index,
    required int totalItems,
  }) itemBuilder;
  final EdgeInsets? itemPadding;

  EndlessStreamListViewData({
    required this.itemBuilder,
    required this.itemPadding,
    required double? extentAfterFactor,
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
    required void Function() loadMore,
    required Stream<List<T>> stream,
    required EndlessStreamController<T>? controller,
    required EdgeInsets? padding,
    required bool? loadOnSubscribe,
  }) : super(
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
          stream: stream,
          controller: controller,
          padding: padding,
          loadOnSubscribe: loadOnSubscribe,
        );
}
