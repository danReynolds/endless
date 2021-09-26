import 'package:endless/firestore/endless_firestore_stream_batch_delegate.dart';
import 'package:endless/firestore/endless_firestore_stream_controller.dart';
import 'package:endless/stream/endless_stream_controller.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class EndlessFirestoreStreamData<T> {
  final Query<T> query;
  final Widget Function({
    required Stream<List<QueryDocumentSnapshot<T>>> stream,
    required void Function() loadMore,
    required EndlessStreamController<QueryDocumentSnapshot<T>>? controller,
    required bool loadOnSubscribe,
  }) builder;
  final EndlessFirestoreStreamController? controller;
  final EndlessFirestoreStreamBatchDelegate batchDelegate;
  final Future<void> Function(List<QueryDocumentSnapshot<T>> items)? onLoad;

  EndlessFirestoreStreamData({
    required this.query,
    required this.batchDelegate,
    required this.builder,
    required this.controller,
    required this.onLoad,
  });
}

// Adapter for an EndlessFirestoreStream to an EndlessStream so that it
// can then reuse the scroll view builder logic of the EndlessStream
class EndlessFirestoreStreamBuilder<T> extends StatefulWidget {
  final Query<T> query;
  final Future<void> Function(List<QueryDocumentSnapshot<T>> docs)? onLoad;
  final Widget Function({
    required Stream<List<QueryDocumentSnapshot<T>>> stream,
    required void Function() loadMore,
    required EndlessStreamController<QueryDocumentSnapshot<T>> controller,
    required bool loadOnSubscribe,
  }) builder;
  final EndlessFirestoreStreamController? controller;
  final EndlessFirestoreStreamBatchDelegate batchDelegate;

  const EndlessFirestoreStreamBuilder({
    required this.query,
    required this.builder,
    required this.batchDelegate,
    this.controller,
    this.onLoad,
    key,
  }) : super(key: key);

  static EndlessFirestoreStreamBuilder fromData<Y>(
    EndlessFirestoreStreamData<Y> data,
  ) {
    return EndlessFirestoreStreamBuilder<Y>(
      builder: data.builder,
      query: data.query,
      controller: data.controller,
      batchDelegate: data.batchDelegate,
      onLoad: data.onLoad,
    );
  }

  @override
  _EndlessFirestoreStreamBuilderState<T> createState() =>
      _EndlessFirestoreStreamBuilderState<T>();
}

class _EndlessFirestoreStreamBuilderState<T>
    extends State<EndlessFirestoreStreamBuilder<T>> {
  int _currentBatch = 0;
  StreamSubscription? _inputStream;
  final EndlessStreamController<QueryDocumentSnapshot<T>>
      _endlessStreamController = EndlessStreamController();
  final _outputStreamController =
      StreamController<List<QueryDocumentSnapshot<T>>>();

  @override
  initState() {
    super.initState();

    final controller = widget.controller;

    if (controller != null) {
      controller.loadMore = _loadMore;

      controller.clear = ({bool lazy = false}) async {
        if (_inputStream != null) {
          await _inputStream!.cancel();
          _inputStream = null;
        }

        setState(() {
          _currentBatch = 0;
        });
        _endlessStreamController.clear(lazy: lazy);
      };
    }
  }

  @override
  dispose() {
    super.dispose();
    if (_inputStream != null) {
      _inputStream!.cancel();
    }
  }

  _loadMore() async {
    if (_inputStream != null) {
      await _inputStream!.cancel();
    }

    setState(() {
      _currentBatch += 1;
    });

    // Reset the result count diff per load. If later the stream updates due to a remote change,
    // the result count can be incremented/decremented for added or removed docs.
    int resultCount = 0;

    final batchSize = widget.batchDelegate.batchSize;
    final currentLimit = batchSize * _currentBatch;
    final maxBatches = widget.batchDelegate.maxBatches;
    final hasMaxLimit = maxBatches != null;
    final maxLimit = hasMaxLimit ? batchSize * maxBatches! : null;

    _inputStream = widget.query
        .limit(currentLimit)
        // We first receive cached data if present from the snapshot followed
        // by a second event that is server data. The difference is denoted by
        // the isFromCache field:
        // https://firebase.google.com/docs/reference/android/com/google/firebase/firestore/SnapshotMetadata#public-boolean-isfromcache
        // Receiving this second server event with isFromCache=false is critical because we use it to determine if we should stop fetching
        // when a server response returns fewer than the current limit documents
        .snapshots(includeMetadataChanges: true)
        .listen(
      (snapshot) async {
        final docs = snapshot.docs;

        if (widget.onLoad != null) {
          await widget.onLoad!(snapshot.docs);
        }

        int resultCountDiff = 0;
        snapshot.docChanges.forEach((docChange) {
          if (docChange.type == DocumentChangeType.added) {
            resultCountDiff += 1;
          } else if (docChange.type == DocumentChangeType.removed) {
            resultCountDiff -= 1;
          }
        });

        setState(
          () {
            resultCount = resultCount + resultCountDiff;

            if (!_endlessStreamController.isPaused()) {
              final hasReachedMaxLimit =
                  hasMaxLimit && currentLimit == maxLimit;

              // If the number of docs returned from the network is less than the current limit, we
              // know that there are no more docs to load.
              final hasFetchedTooFewDocsFromNetwork =
                  !snapshot.metadata.isFromCache && docs.length < currentLimit;

              // In addition to the above conditions, we only want to stop attempting to load if the docs came from the network, not the cache, as the cache
              // does not represent the full list of potential documents.
              if (hasReachedMaxLimit || hasFetchedTooFewDocsFromNetwork) {
                _endlessStreamController.pause();
              }
            } else {
              // If the result count has increased such as when a new document is created,
              // increasing the total from a limit threshold of ex. 20 to 21, then it would be possible
              // to continue loading the next limit of 30 and we should re-enable the ability to load more.
              final isResultCountAboveCurrentLimit =
                  resultCount >= currentLimit;

              if (isResultCountAboveCurrentLimit && !hasMaxLimit ||
                  currentLimit < maxLimit!) {
                _endlessStreamController.resume();
              }
            }
          },
        );

        // Since a Firestore load more stream will always return the full set of items, not just the new ones,
        // we lazy clear the stream load more controller to perform the full replace.
        _endlessStreamController.clear(lazy: true);
        _outputStreamController.add(docs);
      },
    );
  }

  @override
  Widget build(context) {
    return widget.builder(
      stream: _outputStreamController.stream,
      loadMore: _loadMore,
      controller: _endlessStreamController,
      loadOnSubscribe: true,
    );
  }
}
