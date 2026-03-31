import 'package:flutter/material.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(title), actions: actions),
      body: Stack(
        children: [
          const _AmbientBackdrop(),
          SafeArea(top: false, child: child),
        ],
      ),
    );
  }
}

class _AmbientBackdrop extends StatelessWidget {
  const _AmbientBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.shell),
            ),
          ),
          Positioned(
            top: -90,
            right: -40,
            child: _GlowOrb(
              size: 240,
              colors: [AppColors.info.withValues(alpha: 0.18), Colors.transparent],
            ),
          ),
          Positioned(
            top: 140,
            left: -60,
            child: _GlowOrb(
              size: 220,
              colors: [AppColors.primary.withValues(alpha: 0.16), Colors.transparent],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
