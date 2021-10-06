import 'package:endless/endless_state_property.dart';
import 'package:endless/stream/endless_stream_controller.dart';
import 'package:endless/stream/endless_stream_scroll_view_data.dart';
import 'package:flutter/material.dart';

class EndlessStreamGridViewData<T> extends EndlessStreamScrollViewData<T> {
  final Widget Function(
    BuildContext context, {
    required T item,
    required int index,
    required int totalItems,
  }) itemBuilder;
  final SliverGridDelegate gridDelegate;

  EndlessStreamGridViewData({
    required this.itemBuilder,
    required this.gridDelegate,
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
