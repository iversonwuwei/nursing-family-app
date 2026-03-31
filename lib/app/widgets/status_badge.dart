import 'package:flutter/material.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

enum BadgeTone { success, warning, danger, info, neutral }

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.tone});

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      BadgeTone.success => (AppColors.primarySoft, AppColors.primary),
      BadgeTone.warning => (const Color(0xFF3A2C13), AppColors.warning),
      BadgeTone.danger => (const Color(0xFF371824), AppColors.danger),
      BadgeTone.info => (const Color(0xFF142B44), AppColors.info),
      BadgeTone.neutral => (AppColors.beige, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.$1.withValues(alpha: 0.92),
            colors.$1.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.$2.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: colors.$2, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.$2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
