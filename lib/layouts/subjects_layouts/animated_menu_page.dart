import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/animation_state.dart';

class AnimatedMenuPage extends StatefulWidget {
  final List items;
  final int stackCard;
  final double maxCrossAxisExtent;
  final String title;
  final Widget Function(int) childBuilder;
  final Function(int) onTap;

  const AnimatedMenuPage({
    super.key,
    required this.items,
    required this.stackCard,
    required this.maxCrossAxisExtent,
    required this.title,
    required this.childBuilder,
    required this.onTap
  });

  @override
  State<AnimatedMenuPage> createState() => _AnimatedMenuPageState();
}

class _AnimatedMenuPageState extends State<AnimatedMenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _itemCount = 0;

  bool _isInitialized = false;

  final int _itemAnimationDuration = 500;
  final int _itemDelay = 100;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int count = widget.items.length;

      int totalDuration = count > 0
          ? _itemDelay * (count - 1) + _itemAnimationDuration
          : _itemAnimationDuration;

      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: totalDuration));

      _controller.forward();

      setState(() {
        _itemCount = count;
        _isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _reAnimate() {
    _controller.reset();
    _controller.forward();
  }

  void _updateController(List items) {
    int newCount = items.length;

    int totalDuration = newCount > 0
        ? _itemDelay * (newCount - 1) + _itemAnimationDuration
        : _itemAnimationDuration;

    _controller.duration = Duration(milliseconds: totalDuration);

    setState(() => _itemCount = newCount);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.items.length != _itemCount) {
      if (mounted) _updateController(widget.items);
    }

    return Consumer<AnimationState>(
      builder: (_, animationState, __) {
        if (animationState.reAnimate) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _reAnimate();
              animationState.reAnimate = false;
            }
          });
        }

        if (animationState.selectedIndex != widget.stackCard &&
            _controller.isAnimating) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _controller.reset();
          });
        }

        return _body(context, widget.maxCrossAxisExtent, widget.items,
            widget.childBuilder, widget.title);
      },
    );
  }

  Widget _body(BuildContext context, double maxCrossAxisExtent, List items,
      Widget Function(int) childBuilder, String title) {
    final mainTheme = Theme.of(context);
    return Container(
      color: mainTheme.scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxCrossAxisExtent,
                  crossAxisSpacing: 40.0,
                  mainAxisSpacing: 20.0,
                  
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  int delay = _itemDelay * index;

                  double start = delay / _controller.duration!.inMilliseconds;
                  double end = (delay + _itemAnimationDuration) /
                      _controller.duration!.inMilliseconds;

                  Animation<double> gridAnimation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(start, end, curve: Curves.easeOutBack),
                    ),
                  );

                  return CustomAnimatedGrid(
                      animation: gridAnimation,
                      onTap: () => widget.onTap(index), 
                      child: childBuilder(index),
                      );
                },
                childCount: items.length
                ),
                
              ))
        ],
      ),
    );
  }
}

class CustomAnimatedGrid extends StatefulWidget {
  final Animation<double> animation;
  final VoidCallback onTap;
  final Widget child;

  const CustomAnimatedGrid({
    super.key,
    required this.animation,
    required this.onTap,
      required this.child,
  });

  @override
  State<CustomAnimatedGrid> createState() => _CustomAnimatedGridState();
}

class _CustomAnimatedGridState extends State<CustomAnimatedGrid> 
with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150)
    );

    _pressAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInBack)
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.animation, _pressAnimation]),
      builder: (context, child) {
        final double combinedScale = widget.animation.value * _pressAnimation.value;
        return Transform.scale(
          scale: combinedScale,
          child: child,
        );
      },
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: widget.child,
      ),
    );
  }
}