import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [
            Color(0xFF181A20), // dark background
            Color(0xFF23243A), // dark surface
          ]
        : [
            Color(0xFF3ad5d8),
            Color(0xFF513ce8),
          ];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/loading.png',
                fit: BoxFit.contain,
                width: 200,
                height: 200,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
