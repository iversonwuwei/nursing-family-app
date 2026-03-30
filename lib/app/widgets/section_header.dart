import 'package:flutter/material.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtitleWidgets = subtitle == null
        ? null
        : <Widget>[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ];
    final trailingWidgets = trailing == null ? null : <Widget>[trailing!];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleLarge),
              ...?subtitleWidgets,
            ],
          ),
        ),
        ...?trailingWidgets,
      ],
    );
  }
}
