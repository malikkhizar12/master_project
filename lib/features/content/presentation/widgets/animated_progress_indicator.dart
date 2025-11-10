import 'package:flutter/material.dart';

class AnimatedProgressIndicator extends StatefulWidget {
  const AnimatedProgressIndicator({
    super.key,
    required this.value,
    this.backgroundColor,
    this.valueColor,
    this.minHeight = 4.0,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 800),
  });

  final double value;
  final Color? backgroundColor;
  final Color? valueColor;
  final double minHeight;
  final BorderRadius? borderRadius;
  final Duration duration;

  @override
  State<AnimatedProgressIndicator> createState() =>
      _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState
    extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _animation.value,
          backgroundColor: widget.backgroundColor ?? theme.colorScheme.surface,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.valueColor ?? theme.colorScheme.primary,
          ),
          minHeight: widget.minHeight,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(3),
        );
      },
    );
  }
}

