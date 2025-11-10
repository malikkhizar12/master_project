import 'package:flutter/material.dart';

class AnimatedCircularProgress extends StatefulWidget {
  const AnimatedCircularProgress({
    super.key,
    required this.value,
    this.size = 120.0,
    this.strokeWidth = 12.0,
    this.backgroundColor,
    this.valueColor,
    this.child,
    this.duration = const Duration(milliseconds: 1200),
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? valueColor;
  final Widget? child;
  final Duration duration;

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
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
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: widget.backgroundColor ??
                      theme.colorScheme.surface.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.valueColor ?? Colors.white,
                  ),
                ),
              );
            },
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

