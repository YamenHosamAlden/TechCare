import 'dart:ui';
import 'package:flutter/material.dart';

class BlureCard extends StatelessWidget {
  final Color? color;
  final double? borderRadius;
  final double? sigmaX;
  final double? blur;
  final double? sigmaY;
  final Widget? child;

  const BlureCard({
    super.key,
    this.color,
    this.borderRadius = 0.0,
    this.sigmaX = 0.0,
    this.sigmaY = 0.0,
    this.child,
    this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: blur ?? sigmaX!, sigmaY: blur ?? sigmaY!),
        child: Container(
          width: 500,
          decoration: BoxDecoration(color: color),
          child: child,
        ),
      ),
    );
  }
}
