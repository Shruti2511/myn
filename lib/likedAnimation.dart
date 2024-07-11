import 'package:flutter/material.dart';

class HeartAnimation extends StatefulWidget {
  final bool show;
  final VoidCallback onComplete;

  HeartAnimation({required this.show, required this.onComplete});

  @override
  _HeartAnimationState createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300), // Faster transition
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
        _controller.reset();
      }
    });

    if (widget.show) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(HeartAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
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
    return widget.show
        ? Positioned(
            top: MediaQuery.of(context).size.height / 2 - 24,
            left: MediaQuery.of(context).size.width / 2 - 24,
            child: SlideTransition(
              position: _animation,
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 48.0,
              ),
            ),
          )
        : Container();
  }
}