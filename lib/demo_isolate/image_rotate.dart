import 'package:flutter/material.dart';

class ImageRotate extends StatefulWidget {
  const ImageRotate({super.key});

  @override
  State<ImageRotate> createState() => _ImageRotateState();
}

class _ImageRotateState extends State<ImageRotate>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  bool isRotating = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isRotating) {
          _controller.stop();
        } else {
          _controller.repeat();
        }
        isRotating = !isRotating;
      },
      child: RotationTransition(
        turns: _animation,
        child: Image.asset('assets/images/pinwheel.png'),
      ),
    );
  }
}
