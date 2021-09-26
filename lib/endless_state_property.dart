import 'package:flutter/material.dart';

enum EndlessState { empty, loading, done }

typedef Builder<T> = T Function(BuildContext context);

typedef StateBuilder<T> = T? Function(
  BuildContext context,
  Set<EndlessState> states,
);

abstract class EndlessStateProperty<T> {
  T? resolve(BuildContext context, Set<EndlessState> states);

  /// A LoadStateProperty resolver that provides the builder with the set of current states
  /// so that it can dynamically choose what to build based on those states.
  static EndlessStateProperty<T> resolveWith<T>(StateBuilder<T> builder) =>
      _EndlessStatePropertyWhen<T>(builder);

  /// Convenience method for creating a [EndlessStateProperty] that resolves
  /// to a single value for all states.
  static EndlessStateProperty<T> all<T>(Builder<T> builder) =>
      _EndlessStatePropertyValue<T>(builder);

  /// Convenience method for creating a [EndlessStateProperty] that resolves
  /// to a single value for the loading state.
  static EndlessStateProperty<T> loading<T>(Builder<T> builder) =>
      _EndlessStatePropertyValueWhenInState<T>(builder, EndlessState.loading);

  /// Convenience method for creating a [EndlessStateProperty] that resolves
  /// to a single value for the empty state.
  static EndlessStateProperty<T> empty<T>(Builder<T> builder) =>
      _EndlessStatePropertyValueWhenInState<T>(builder, EndlessState.empty);

  /// Convenience method for creating a [EndlessStateProperty] that resolves
  /// to a single value for the done state.
  static EndlessStateProperty<T> done<T>(Builder<T> builder) =>
      _EndlessStatePropertyValueWhenInState<T>(builder, EndlessState.done);

  /// Convenience method for creating a [EndlessStateProperty] that resolves
  /// to null for all states.
  static EndlessStateProperty<T> never<T>() =>
      _EndlessStatePropertyValue<T>((context) => null);
}

/// State property that resolves the current [EndlessState] states to the resolver
/// function so that it can determine its behavior based on the current states.
class _EndlessStatePropertyWhen<T> implements EndlessStateProperty<T> {
  final StateBuilder<T> _resolve;

  _EndlessStatePropertyWhen(this._resolve);

  @override
  T? resolve(context, states) => _resolve(context, states);
}

/// State property that resolves the state-agnostic resolver function.
class _EndlessStatePropertyValue<T> implements EndlessStateProperty<T> {
  final Builder<T?> _resolve;

  _EndlessStatePropertyValue(this._resolve);

  @override
  T? resolve(context, _states) => _resolve(context);
}

/// State property that resolves the state-agnostic resolver function if the current
/// [EndlessState] states includes the provided state.
class _EndlessStatePropertyValueWhenInState<T>
    implements EndlessStateProperty<T> {
  final Builder<T> _resolve;
  final EndlessState _state;

  _EndlessStatePropertyValueWhenInState(this._resolve, this._state);

  @override
  T? resolve(context, _states) {
    if (_states.contains(_state)) {
      return _resolve(context);
    }

    return null;
  }
}

/// If a builder exists, then use the default state property for that builder.
/// Otherwise if no builder was provided, provide a never state property since
/// the client has no builder for that state.
EndlessStateProperty<T?> _resolveBuilderToStateProperty<T>(
  Builder<T>? builder,
  EndlessStateProperty<T> Function(Builder<T> builder) resolver,
) {
  if (builder != null) {
    return resolver(builder);
  }

  return EndlessStateProperty.never<T>();
}

EndlessStateProperty<Widget?> resolveHeaderBuilderToStateProperty(
  Builder<Widget>? builder,
) {
  return _resolveBuilderToStateProperty<Widget>(
    builder,
    EndlessStateProperty.all,
  );
}

EndlessStateProperty<Widget?> resolveEmptyBuilderToStateProperty(
  Builder<Widget>? builder,
) {
  return _resolveBuilderToStateProperty<Widget>(
    builder,
    (Builder<Widget> builder) =>
        EndlessStateProperty.resolveWith<Widget>((context, states) {
      if (states.contains(EndlessState.empty) &&
          !states.contains(EndlessState.loading)) {
        return builder(context);
      }
      return null;
    }),
  );
}

EndlessStateProperty<Widget?> resolveLoadingBuilderToStateProperty(
  Builder<Widget>? builder,
) {
  return _resolveBuilderToStateProperty<Widget>(
    builder,
    EndlessStateProperty.loading,
  );
}

EndlessStateProperty<Widget?> resolveLoadMoreBuilderToStateProperty(
  Builder<Widget>? builder,
) {
  return _resolveBuilderToStateProperty<Widget>(
    builder,
    (Builder<Widget> builder) =>
        EndlessStateProperty.resolveWith((context, states) {
      if (states.intersection({
        EndlessState.done,
        EndlessState.loading,
        EndlessState.empty,
      }).isEmpty) {
        return builder(context);
      }
      return null;
    }),
  );
}

EndlessStateProperty<Widget?> resolveFooterBuilderToStateProperty(
    Builder<Widget>? builder) {
  return _resolveBuilderToStateProperty<Widget>(
    builder,
    EndlessStateProperty.all,
  );
}
