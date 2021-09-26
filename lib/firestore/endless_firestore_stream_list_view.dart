import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:endless/endless_state_property.dart';
import 'package:endless/firestore/endless_firestore_stream_batch_delegate.dart';
import 'package:endless/firestore/endless_firestore_stream_builder.dart';
import 'package:endless/firestore/endless_firestore_stream_controller.dart';
import 'package:endless/stream/endless_stream_list_view.dart';
import 'package:endless/stream/endless_stream_list_view_data.dart';
import 'package:flutter/material.dart';

class EndlessFirestoreStreamListView<T> extends StatelessWidget {
  final Widget Function(
    BuildContext context, {
    QueryDocumentSnapshot<T> item,
    int index,
    int totalItems,
  }) itemBuilder;
  final EndlessFirestoreStreamController? controller;
  final EdgeInsets? padding;
  final EdgeInsets? itemPadding;
  final Query<T> query;
  final Future<void> Function(List<QueryDocumentSnapshot<T>> items)? onLoad;
  final EndlessFirestoreStreamBatchDelegate batchDelegate;

  final SliverPersistentHeader Function(BuildContext context)? headerBuilder;
  final EndlessStateProperty<SliverPersistentHeader>? headerBuilderState;

  final Widget Function(BuildContext context)? emptyBuilder;
  final EndlessStateProperty<Widget>? emptyBuilderState;

  final Widget Function(BuildContext context)? loadMoreBuilder;
  final EndlessStateProperty<Widget>? loadMoreBuilderState;

  final Widget Function(BuildContext context)? footerBuilder;
  final EndlessStateProperty<Widget>? footerBuilderState;

  final Widget Function(BuildContext context)? loadingBuilder;
  final EndlessStateProperty<Widget>? loadingBuilderState;

  const EndlessFirestoreStreamListView({
    required this.itemBuilder,
    required this.query,
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
    this.itemPadding,
    this.onLoad,
    key,
  }) : super(key: key);

  @override
  Widget build(context) {
    return EndlessFirestoreStreamBuilder.fromData<T>(
      EndlessFirestoreStreamData<T>(
        controller: controller,
        query: query,
        batchDelegate: batchDelegate,
        onLoad: onLoad,
        builder: ({
          required loadMore,
          required controller,
          required loadOnSubscribe,
          required stream,
        }) {
          return EndlessStreamListView.fromData<QueryDocumentSnapshot<T>>(
            EndlessStreamListViewData<QueryDocumentSnapshot<T>>(
              batchDelegate: batchDelegate.convertToStreamBatchDelegate(),
              itemBuilder: itemBuilder,
              loadMore: loadMore,
              controller: controller,
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
              stream: stream,
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
