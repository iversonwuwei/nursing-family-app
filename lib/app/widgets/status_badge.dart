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
      BadgeTone.warning => (const Color(0xFFFFF1DD), AppColors.warning),
      BadgeTone.danger => (const Color(0xFFFFE5E5), AppColors.danger),
      BadgeTone.info => (const Color(0xFFEAF0FF), AppColors.info),
      BadgeTone.neutral => (AppColors.beige, AppColors.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colors.$2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
