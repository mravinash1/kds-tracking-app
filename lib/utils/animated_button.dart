import 'package:flutter/material.dart';

class TapAnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;

  const TapAnimatedButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<TapAnimatedButton> createState() => _TapAnimatedButtonState();
}

class _TapAnimatedButtonState extends State<TapAnimatedButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95; // Slightly shrink the button
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
    widget.onPressed(); // Trigger the login
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // Reset if tap is cancelled
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
          ),
          onPressed: () {}, // Already handled in GestureDetector
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
