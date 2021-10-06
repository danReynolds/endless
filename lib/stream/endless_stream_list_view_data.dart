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
    required Widget Function()? headerBuilder,
    required Widget Function()? emptyBuilder,
    required Widget Function()? loadingBuilder,
    required Widget Function()? loadMoreBuilder,
    required Widget Function()? footerBuilder,
    required EndlessStateProperty? headerBuilderState,
    required EndlessStateProperty? emptyBuilderState,
    required EndlessStateProperty? loadingBuilderState,
    required EndlessStateProperty? loadMoreBuilderState,
    required EndlessStateProperty? footerBuilderState,
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
