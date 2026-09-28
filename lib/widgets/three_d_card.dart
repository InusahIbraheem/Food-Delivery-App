import 'dart:math' as math;
import 'package:flutter/material.dart';

class ThreeDCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Gradient? gradient;
  final double borderRadius;
  final double elevation;
  final double tiltX;
  final double tiltY;
  final Border? border;

  const ThreeDCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.gradient,
    this.borderRadius = 24,
    this.elevation = 16,
    this.tiltX = 0.0,
    this.tiltY = 0.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? (isDark ? const Color(0xFF1E1E24) : Colors.white)) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ??
            Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.06),
              width: 1.2,
            ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.8),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );

    if (tiltX != 0.0 || tiltY != 0.0) {
      card = Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(tiltX * math.pi / 180)
          ..rotateY(tiltY * math.pi / 180),
        child: card,
      );
    }

    return card;
  }
}
