import 'package:flutter/material.dart';

class CurvedGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double width;

  const CurvedGradientButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.gradientColors,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding:  EdgeInsets.symmetric(vertical: 12.0, horizontal: width),
        child: Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 22, 21, 21),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
