import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endless/endless_state_property.dart';
import 'package:endless/firestore/endless_firestore_stream_batch_delegate.dart';
import 'package:endless/firestore/endless_firestore_stream_builder.dart';
import 'package:endless/firestore/endless_firestore_stream_controller.dart';
import 'package:endless/stream/endless_stream_grid_view.dart';
import 'package:endless/stream/endless_stream_grid_view_data.dart';
import 'package:flutter/material.dart';

class EndlessFirestoreStreamGridView<T> extends StatelessWidget {
  final Widget Function(
    BuildContext context, {
    QueryDocumentSnapshot<T> item,
    int index,
    int totalItems,
  }) itemBuilder;
  final EndlessFirestoreStreamController? controller;
  final EdgeInsets? padding;
  final EndlessFirestoreStreamBatchDelegate batchDelegate;
  final Query<T> query;
  final SliverGridDelegate gridDelegate;
  final Future<void> Function(List<QueryDocumentSnapshot<T>> items)? onLoad;

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

  const EndlessFirestoreStreamGridView({
    required this.itemBuilder,
    required this.query,
    required this.batchDelegate,
    required this.gridDelegate,
    this.controller,
    this.padding,
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
    this.onLoad,
    key,
  }) : super(key: key);

  @override
  Widget build(context) {
    return EndlessFirestoreStreamBuilder.fromData<T>(
      EndlessFirestoreStreamData<T>(
        controller: controller,
        batchDelegate: batchDelegate,
        query: query,
        onLoad: onLoad,
        builder: ({
          required loadMore,
          required controller,
          required loadOnSubscribe,
          required stream,
        }) {
          return EndlessStreamGridView.fromData<QueryDocumentSnapshot<T>>(
            EndlessStreamGridViewData<QueryDocumentSnapshot<T>>(
              batchDelegate: batchDelegate.convertToStreamBatchDelegate(),
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
              loadOnSubscribe: loadOnSubscribe,
              gridDelegate: gridDelegate,
            ),
          );
        },
      ),
    );
  }
}
