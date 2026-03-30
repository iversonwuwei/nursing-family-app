import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/family_binding.dart';
import 'package:nursing_family_app/app/routes/app_pages.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

class FamilyApp extends StatelessWidget {
  const FamilyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '家属端 AI 助手',
      debugShowCheckedModeBanner: false,
      initialBinding: FamilyBinding(),
      initialRoute: AppRoutes.root,
      getPages: AppPages.pages,
      theme: AppTheme.lightTheme,
    );
  }
}
