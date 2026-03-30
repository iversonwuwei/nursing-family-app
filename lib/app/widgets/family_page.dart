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
      body: SafeArea(top: false, child: child),
    );
  }
}
