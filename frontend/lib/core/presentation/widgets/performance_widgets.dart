import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Image loading widget with caching and fallback
class CachedNetworkImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedNetworkImageWithFallback({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPlaceholder = Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image, color: Colors.grey),
      ),
    );

    final defaultError = Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey),
      ),
    );

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => placeholder ?? defaultPlaceholder,
      errorWidget: (context, url, error) => errorWidget ?? defaultError,
      useOldImageOnUrlChange: true,
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Lazy loading list view for better performance
class LazyLoadingListView extends StatefulWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext context, dynamic item, int index)
      itemBuilder;
  final EdgeInsets padding;
  final int itemsPerPage;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const LazyLoadingListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.padding = EdgeInsets.zero,
    this.itemsPerPage = 20,
    this.isLoading = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  State<LazyLoadingListView> createState() => _LazyLoadingListViewState();
}

class _LazyLoadingListViewState extends State<LazyLoadingListView> {
  late ScrollController _scrollController;
  int _displayedItems = 0;

  @override
  void initState() {
    super.initState();
    _displayedItems = widget.itemsPerPage;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!widget.isLoading && _displayedItems < widget.items.length) {
        widget.onLoadMore?.call();
        setState(() => _displayedItems += widget.itemsPerPage);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsToDisplay =
        widget.items.take(_displayedItems).toList(growable: false);

    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: itemsToDisplay.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < itemsToDisplay.length) {
          return widget.itemBuilder(
            context,
            itemsToDisplay[index],
            index,
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

/// Optimized grid view with lazy loading
class LazyLoadingGridView extends StatefulWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext context, dynamic item, int index)
      itemBuilder;
  final int crossAxisCount;
  final EdgeInsets padding;
  final int itemsPerPage;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const LazyLoadingGridView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.padding = EdgeInsets.zero,
    this.itemsPerPage = 20,
    this.isLoading = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  State<LazyLoadingGridView> createState() => _LazyLoadingGridViewState();
}

class _LazyLoadingGridViewState extends State<LazyLoadingGridView> {
  late ScrollController _scrollController;
  int _displayedItems = 0;

  @override
  void initState() {
    super.initState();
    _displayedItems = widget.itemsPerPage;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!widget.isLoading && _displayedItems < widget.items.length) {
        widget.onLoadMore?.call();
        setState(() => _displayedItems += widget.itemsPerPage);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsToDisplay =
        widget.items.take(_displayedItems).toList(growable: false);

    return GridView.builder(
      controller: _scrollController,
      padding: widget.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: itemsToDisplay.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < itemsToDisplay.length) {
          return widget.itemBuilder(
            context,
            itemsToDisplay[index],
            index,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

/// Lazy loading list view for better performance
abstract class ImmutableWidget extends StatelessWidget {
  const ImmutableWidget({Key? key}) : super(key: key);
}

/// Performance monitoring mixin for debugging
mixin PerformanceMonitoringMixin<T extends StatefulWidget> on State<T> {
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint('${T.toString()} build time: ${_stopwatch.elapsedMilliseconds}ms');
    super.dispose();
  }

  void logPerformance(String message) {
    debugPrint(
        '${T.toString()} - $message: ${_stopwatch.elapsedMilliseconds}ms');
  }
}

/// Const widget wrapper for better optimization
class ConstPlaceholder extends ImmutableWidget {
  final double width;
  final double height;
  final Color color;

  const ConstPlaceholder({
    Key? key,
    this.width = 100,
    this.height = 100,
    this.color = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color,
    );
  }
}

/// FPS counter widget for performance monitoring
class FPSCounter extends StatefulWidget {
  final Widget child;

  const FPSCounter({Key? key, required this.child}) : super(key: key);

  @override
  State<FPSCounter> createState() => _FPSCounterState();
}

class _FPSCounterState extends State<FPSCounter>
    with SingleTickerProviderStateMixin {
  late Stopwatch _stopwatch;
  int _frameCount = 0;
  int _fps = 0;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _measureFrame();
  }

  void _measureFrame() {
    _frameCount++;

    if (_stopwatch.elapsedMilliseconds >= 1000) {
      setState(() => _fps = _frameCount);
      _frameCount = 0;
      _stopwatch.reset();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureFrame();
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const showFPS = bool.fromEnvironment('SHOW_FPS', defaultValue: false);

    if (!showFPS) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'FPS: $_fps',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Memory-efficient list cache
class ListCache<T> {
  final Map<int, T> _cache = {};
  final int maxCacheSize;

  ListCache({this.maxCacheSize = 100});

  void put(int index, T value) {
    if (_cache.length >= maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[index] = value;
  }

  T? get(int index) => _cache[index];

  void clear() => _cache.clear();

  int get size => _cache.length;
}

/// Debounced callback for text input
class DebouncedCallback {
  final Duration delay;
  final void Function(String) callback;
  Future<void>? _debounce;

  DebouncedCallback({
    required this.callback,
    this.delay = const Duration(milliseconds: 500),
  });

  void call(String value) {
    _debounce?.ignore();
    _debounce = Future<void>.delayed(delay, () {
      callback(value);
    });
  }

  void cancel() {
    _debounce?.ignore();
  }
}

/// Viewport-aware widget builder for efficient rendering
class ViewportAwareBuilder extends StatelessWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext, dynamic, int) itemBuilder;
  final double itemHeight;
  final EdgeInsets padding;

  const ViewportAwareBuilder({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.itemHeight,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: items.length,
      itemExtent: itemHeight,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }
}
