import 'package:endless/stream/endless_stream_controller.dart';
import 'package:flutter/material.dart';
import 'package:endless/endless_state_property.dart';

/// Data class for an EndlessStreamScrollView to ensure that all fields are passed
/// when instantiated
class EndlessStreamScrollViewData<T> {
  final void Function() loadMore;
  final Stream<List<T>> stream;
  final EndlessStreamController<T>? controller;

  final EndlessStateProperty? headerBuilderState;
  final EndlessStateProperty? emptyBuilderState;
  final EndlessStateProperty? loadingBuilderState;
  final EndlessStateProperty? loadMoreBuilderState;
  final EndlessStateProperty? footerBuilderState;
  final Widget Function(BuildContext context)? headerBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? loadMoreBuilder;
  final Widget Function(BuildContext context)? footerBuilder;

  // Default to fetching the next batch once the scroll view has less than 40%
  // of the available space left to scroll
  double? extentAfterFactor;

  bool? loadOnSubscribe;
  EdgeInsets? padding;

  EndlessStreamScrollViewData({
    required this.extentAfterFactor,
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
    extentAfterFactor ??= 0.4;
  }
}
