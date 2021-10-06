// ignore_for_file: prefer_void_to_null

import 'package:flutter/material.dart';
import 'package:state_property/state_property.dart';

enum EndlessState { empty, loading, done }

typedef StatelessBuilder = Widget Function();
typedef StatefulBuilder = Widget? Function(
  Set<EndlessState> states,
);

abstract class EndlessStateProperty
    implements StateProperty<EndlessState, Widget> {
  /// The most flexible [StateProperty] that allows for dynamically resolving the builder
  /// function based on the state of the endless scroll view.
  static StateProperty<EndlessState, Widget> resolveWith(
          StatefulBuilder builder) =>
      StateProperty.resolveWith<EndlessState, Widget>(builder);

  /// Resolves the given builder in all cases regardless of the state of the scroll view.
  static StateProperty<EndlessState, Widget> all(StatelessBuilder builder) =>
      StateProperty.all<EndlessState, Widget>(builder);

  /// Resolves the given builder if the scroll view is currently in the loading state.
  static StateProperty<EndlessState, Widget> loading(
          StatelessBuilder builder) =>
      StateProperty.resolveState(builder, EndlessState.loading);

  /// Resolves the given builder if the scroll view is currently in the empty state.
  static StateProperty<EndlessState, Widget> empty(StatelessBuilder builder) =>
      StateProperty.resolveState(builder, EndlessState.empty);

  /// Resolves the given builder if the scroll view is currently in the done state.
  static StateProperty<EndlessState, Widget> done<T>(
          StatelessBuilder builder) =>
      StateProperty.resolveState(builder, EndlessState.done);

  /// Resolves `null` as the value regardless of the state of the scroll view.
  static StateProperty<EndlessState, Null> never() => StateProperty.never();
}

/// If a builder exists, then use the default state property for that builder.
/// Otherwise if no builder was provided, provide a never state property since
/// the client has no builder for that state.
StateProperty<EndlessState, Widget?> _resolveBuilderToStateProperty(
  StatelessBuilder? builder,
  StateProperty<EndlessState, Widget?> Function(StatelessBuilder builder)
      resolver,
) {
  if (builder != null) {
    return resolver(builder);
  }

  return EndlessStateProperty.never();
}

StateProperty<EndlessState, Widget?> resolveHeaderBuilderToStateProperty(
  StatelessBuilder? builder,
) {
  return _resolveBuilderToStateProperty(
    builder,
    EndlessStateProperty.all,
  );
}

StateProperty<EndlessState, Widget?> resolveEmptyBuilderToStateProperty(
  StatelessBuilder? builder,
) {
  return _resolveBuilderToStateProperty(
    builder,
    (StatelessBuilder builder) => EndlessStateProperty.resolveWith((states) {
      if (states.contains(EndlessState.empty) &&
          !states.contains(EndlessState.loading)) {
        return builder();
      }
      return null;
    }),
  );
}

StateProperty<EndlessState, Widget?> resolveLoadingBuilderToStateProperty(
  StatelessBuilder? builder,
) {
  return _resolveBuilderToStateProperty(
    builder,
    EndlessStateProperty.loading,
  );
}

StateProperty<EndlessState, Widget?> resolveLoadMoreBuilderToStateProperty(
  StatelessBuilder? builder,
) {
  return _resolveBuilderToStateProperty(
    builder,
    (StatelessBuilder builder) => EndlessStateProperty.resolveWith((states) {
      if (states.intersection({
        EndlessState.done,
        EndlessState.loading,
        EndlessState.empty,
      }).isEmpty) {
        return builder();
      }
      return null;
    }),
  );
}

StateProperty<EndlessState, Widget?> resolveFooterBuilderToStateProperty(
    StatelessBuilder? builder) {
  return _resolveBuilderToStateProperty(
    builder,
    EndlessStateProperty.all,
  );
}
