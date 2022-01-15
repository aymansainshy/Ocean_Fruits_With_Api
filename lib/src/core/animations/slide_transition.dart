import 'package:flutter/material.dart';

enum AnimationDir { RTL, LTR, TTB, BTT }

class SlidTransition extends StatefulWidget {
  final Widget child;
  final AnimationDir animationDir;

  const SlidTransition({
    Key key,
    this.child,
    this.animationDir = AnimationDir.LTR,
  }) : super(key: key);
  @override
  _SlidTransitionState createState() => _SlidTransitionState();
}

class _SlidTransitionState extends State<SlidTransition>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation<Offset> _slidAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    switch (widget.animationDir) {
      case AnimationDir.LTR:
        _slidAnimation = Tween<Offset>(
          begin: const Offset(-5, 0),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.ease,
          ),
        );
        break;
      case AnimationDir.RTL:
        _slidAnimation = Tween<Offset>(
          begin: const Offset(5, 0),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.ease,
          ),
        );
        break;
      case AnimationDir.TTB:
        _slidAnimation = Tween<Offset>(
          begin: const Offset(0, -5),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.ease,
          ),
        );
        break;
      case AnimationDir.BTT:
        _slidAnimation = Tween<Offset>(
          begin: const Offset(0, 5),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.ease,
          ),
        );
        break;
      default:
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slidAnimation,
      child: widget.child,
    );
  }
}
