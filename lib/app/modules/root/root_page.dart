import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/modules/health/health_page.dart';
import 'package:nursing_family_app/app/modules/home/home_page.dart';
import 'package:nursing_family_app/app/modules/nursing/nursing_page.dart';
import 'package:nursing_family_app/app/modules/profile/profile_page.dart';
import 'package:nursing_family_app/app/modules/visit/visit_page.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class RootView extends GetView<RootController> {
  const RootView({super.key});

  static const _tabs = [
    HomeView(),
    HealthView(),
    NursingView(),
    VisitView(),
    ProfileView(),
  ];

  static const _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '首页'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: '健康'),
    BottomNavigationBarItem(
      icon: Icon(Icons.volunteer_activism_rounded),
      label: '护理',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month_rounded),
      label: '探视',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: '我的'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: controller.currentIndex.value,
            children: _tabs,
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeIndex,
          backgroundColor: AppColors.card,
          indicatorColor: AppColors.primarySoft,
          destinations: _items
              .map(
                (item) =>
                    NavigationDestination(icon: item.icon, label: item.label!),
              )
              .toList(),
        ),
      ),
    );
  }
}
