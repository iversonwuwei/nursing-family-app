import 'package:flutter/material.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

class FamilyCard extends StatelessWidget {
  const FamilyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor,
    this.gradient,
    this.borderColor,
    this.accentColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final baseColor = backgroundColor ?? AppColors.card;
    final resolvedGradient =
        gradient ??
        LinearGradient(
          colors: [_elevate(baseColor, 0.05), baseColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return Container(
      decoration: BoxDecoration(
        gradient: resolvedGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: [
          BoxShadow(
            color: (accentColor ?? AppColors.glow).withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 18,
              right: 18,
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }

  Color _elevate(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0).toDouble();
    return hsl.withLightness(lightness).toColor();
  }
}
