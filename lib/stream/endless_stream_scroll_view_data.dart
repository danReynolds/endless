import 'package:endless/stream/endless_stream_batch_delegate.dart';
import 'package:endless/stream/endless_stream_controller.dart';
import 'package:flutter/material.dart';
import 'package:endless/endless_state_property.dart';

class EndlessStreamScrollViewData<T> {
  final void Function(int batchSize) loadMore;
  final Stream<List<T>> stream;
  final EndlessStreamController<T>? controller;
  final EndlessStreamBatchDelegate batchDelegate;

  final EndlessStateProperty<Widget>? headerBuilderState;
  final EndlessStateProperty<Widget>? emptyBuilderState;
  final EndlessStateProperty<Widget>? loadingBuilderState;
  final EndlessStateProperty<Widget>? loadMoreBuilderState;
  final EndlessStateProperty<Widget>? footerBuilderState;
  final Widget Function(BuildContext context)? headerBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? loadMoreBuilder;
  final Widget Function(BuildContext context)? footerBuilder;

  bool? loadOnSubscribe;
  EdgeInsets? padding;

  EndlessStreamScrollViewData({
    required this.batchDelegate,
    required this.loadMore,
    required this.stream,
    required this.headerBuilderState,
    required this.emptyBuilderState,
    required this.loadingBuilderState,
    required this.loadMoreBuilderState,
    required this.footerBuilderState,
    required this.headerBuilder,
    required this.emptyBuilder,
    required this.loadingBuilder,
    required this.loadMoreBuilder,
    required this.footerBuilder,
    required this.controller,
    required this.padding,
    required this.loadOnSubscribe,
  }) {
    padding ??= EdgeInsets.zero;
    loadOnSubscribe ??= false;
  }
}
