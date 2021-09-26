import 'package:endless/stream/endless_stream_builder.dart';
import 'package:endless/stream/endless_stream_scroll_view_data.dart';
import 'package:endless/endless_state_property.dart';
import 'package:endless/widgets/default_endless_loading_indicator.dart';
import 'package:flutter/material.dart';

class EndlessPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  EndlessPersistentHeaderDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class EndlessStreamScrollView<T> extends StatefulWidget {
  final EndlessStreamScrollViewData<T> loadMoreScrollViewData;
  final Widget Function(BuildContext context, List<T> items) scrollViewBuilder;

  const EndlessStreamScrollView({
    required this.scrollViewBuilder,
    required this.loadMoreScrollViewData,
    key,
  }) : super(key: key);

  @override
  _EndlessStreamScrollViewState<T> createState() =>
      _EndlessStreamScrollViewState();
}

class _EndlessStreamScrollViewState<T>
    extends State<EndlessStreamScrollView<T>> {
  final ScrollController _scrollController = ScrollController();

  Widget _buildDefaultLoader(BuildContext context) {
    return const DefaultEndlessLoadingIndicator();
  }

  Widget? _buildSliverBoxAdapter(Widget? child) {
    if (child != null) {
      // Hack: As a convenience for clients, we automatically wrap Box layout builders in a SliverToBoxAdapter
      // for the CustomScrollView. The easiest way to do that currently is to check if the runtime type starts with Sliver.
      // This isn't foolproof so if you're reading this and know of a better way please let us know :)
      if (child.runtimeType.toString().startsWith("Sliver")) {
        return child;
      }
      return SliverToBoxAdapter(
        child: child,
      );
    }

    return null;
  }

  /// Builds the sliver sections for the custom scroll view using either their
  /// specified builder functions, or state properties.
  List<Widget> _buildSlivers(Set<EndlessState> states, List<T> items) {
    final loadMoreScrollViewData = widget.loadMoreScrollViewData;

    final headerBuilderState = loadMoreScrollViewData.headerBuilderState ??
        resolveHeaderBuilderToStateProperty(
          loadMoreScrollViewData.headerBuilder,
        );
    final emptyBuilderState = loadMoreScrollViewData.emptyBuilderState ??
        resolveEmptyBuilderToStateProperty(loadMoreScrollViewData.emptyBuilder);
    final loadingBuilderState = loadMoreScrollViewData.loadingBuilderState ??
        resolveLoadingBuilderToStateProperty(
          // A default loader is bundled with the scroll view
          loadMoreScrollViewData.loadingBuilder ?? _buildDefaultLoader,
        );
    final loadMoreBuilderState = loadMoreScrollViewData.loadMoreBuilderState ??
        resolveLoadMoreBuilderToStateProperty(
          loadMoreScrollViewData.loadMoreBuilder,
        );
    final footerBuilderState = loadMoreScrollViewData.footerBuilderState ??
        resolveFooterBuilderToStateProperty(
          loadMoreScrollViewData.footerBuilder,
        );

    return [
      _buildSliverBoxAdapter(headerBuilderState.resolve(context, states)),
      states.contains(EndlessState.empty)
          ? _buildSliverBoxAdapter(
              emptyBuilderState.resolve(context, states),
            )
          : SliverPadding(
              padding: loadMoreScrollViewData.padding!,
              sliver: widget.scrollViewBuilder(context, items),
            ),
      _buildSliverBoxAdapter(
        loadingBuilderState.resolve(context, states),
      ),
      _buildSliverBoxAdapter(
        loadMoreBuilderState.resolve(
          context,
          states,
        ),
      ),
      _buildSliverBoxAdapter(
        footerBuilderState.resolve(context, states),
      ),
    ].where((sliver) => sliver != null).toList() as List<Widget>;
  }

  @override
  Widget build(context) {
    final loadMoreScrollViewData = widget.loadMoreScrollViewData;

    return LayoutBuilder(
      builder: (context, constraints) {
        return EndlessStreamBuilder<T>(
          loadMore: loadMoreScrollViewData.loadMore,
          stream: loadMoreScrollViewData.stream,
          controller: loadMoreScrollViewData.controller,
          loadOnSubscribe: loadMoreScrollViewData.loadOnSubscribe!,
          batchLimit: loadMoreScrollViewData.batchDelegate.batchSize,
          builder: ({
            required states,
            required items,
            required loadMore,
          }) {
            final isLoading = states.contains(EndlessState.loading);
            final isEmpty = states.contains(EndlessState.empty);
            final canLoadMore = !states.contains(EndlessState.done);

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (!isLoading &&
                    canLoadMore &&
                    !isEmpty &&
                    _scrollController.position.extentAfter <
                        constraints.maxHeight *
                            loadMoreScrollViewData
                                .batchDelegate.extentAfterFactor) {
                  loadMore();
                }
                return false;
              },
              child: CustomScrollView(
                controller: _scrollController,
                shrinkWrap: true,
                slivers: _buildSlivers(states, items),
              ),
            );
          },
        );
      },
    );
  }
}
