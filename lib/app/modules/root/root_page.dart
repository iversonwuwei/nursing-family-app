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
    _NavItem(icon: Icons.home_rounded, label: '首页'),
    _NavItem(icon: Icons.favorite_rounded, label: '健康'),
    _NavItem(icon: Icons.hub_rounded, label: '护理'),
    _NavItem(icon: Icons.explore_rounded, label: '探视'),
    _NavItem(icon: Icons.person_rounded, label: '我的'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              const _AmbientBackground(),
              SafeArea(
                bottom: false,
                child: SizedBox.expand(
                  child: IndexedStack(
                    index: controller.currentIndex.value,
                    children: _tabs,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: _FloatingNavigationBar(
            currentIndex: controller.currentIndex.value,
            onSelected: controller.changeIndex,
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _FloatingNavigationBar extends StatelessWidget {
  const _FloatingNavigationBar({
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardElevated.withValues(alpha: 0.98),
            AppColors.card.withValues(alpha: 0.94),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.glow.withValues(alpha: 0.24),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_RootNavConfig.items.length, (index) {
          final item = _RootNavConfig.items[index];
          final selected = currentIndex == index;
          return Expanded(
            child: GestureDetector(
              key: ValueKey('root-nav-${item.label}'),
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          colors: [AppColors.primarySoft, AppColors.lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.34)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _RootNavConfig {
  static const items = RootView._items;
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.shell),
            ),
          ),
          Positioned(
            top: -120,
            right: -40,
            child: _AmbientOrb(
              size: 280,
              colors: [
                AppColors.info.withValues(alpha: 0.18),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            top: 220,
            left: -90,
            child: _AmbientOrb(
              size: 260,
              colors: [
                AppColors.primary.withValues(alpha: 0.14),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            right: -100,
            child: _AmbientOrb(
              size: 320,
              colors: [
                AppColors.coral.withValues(alpha: 0.08),
                Colors.transparent,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({required this.size, required this.colors});

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
