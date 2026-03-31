import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';
import 'package:nursing_family_app/app/widgets/hero_panel.dart';
import 'package:nursing_family_app/app/widgets/responsive_metric_group.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';
import 'package:nursing_family_app/app/widgets/status_badge.dart';

class MessagesController extends GetxController {
  MessagesController(this._service);

  final MockFamilyService _service;

  final RxString selectedCategory = '全部'.obs;

  List<NotificationItem> get items {
    final sortedItems = [..._service.notifications];
    sortedItems.sort(
      (left, right) => _sortScore(right.time) - _sortScore(left.time),
    );
    return sortedItems;
  }

  List<String> get categories => [
    '全部',
    ...items.map((item) => item.category).toSet(),
  ];

  List<NotificationItem> get visibleItems {
    if (selectedCategory.value == '全部') {
      return items;
    }

    return items
        .where((item) => item.category == selectedCategory.value)
        .toList();
  }

  String get latestUpdate => items.isEmpty ? '暂无' : items.first.time;

  int get highlightedCount =>
      items.where((item) => _isHighlightedCategory(item.category)).length;

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  bool isSelectedCategory(String category) =>
      selectedCategory.value == category;

  bool _isHighlightedCategory(String category) {
    return category.contains('健康') ||
        category.contains('异常') ||
        category.contains('预警') ||
        category.contains('账单');
  }

  int _sortScore(String time) {
    if (time == '刚刚') {
      return 100000;
    }

    final match = RegExp(r'^(\d{2}):(\d{2})$').firstMatch(time);
    if (match != null) {
      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      return hour * 60 + minute;
    }

    if (time.contains('昨天')) {
      return -1;
    }

    return -1000;
  }
}

class MessagesView extends GetView<MessagesController> {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = controller.categories;

    return FamilyPage(
      title: '消息中心',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF122B3C), Color(0xFF0E1826)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              accentColor: AppColors.info,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeroPanelHeader(
                    icon: Icons.notifications_active_rounded,
                    color: AppColors.info,
                    title: '消息驾驶舱',
                    subtitle: '护理动态、健康提醒和服务通知保持同屏更新',
                  ),
                  const SizedBox(height: 18),
                  ResponsiveMetricGroup(
                    children: [
                      _OverviewMetric(
                        label: '同步消息',
                        value: '${controller.items.length}',
                      ),
                      _OverviewMetric(
                        label: '信号类型',
                        value: '${categories.length - 1}',
                      ),
                      _OverviewMetric(
                        label: '重点提醒',
                        value: '${controller.highlightedCount}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '最近更新 ${controller.latestUpdate}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories
                          .map(
                            (category) => _SummaryPill(
                              key: ValueKey('messages-filter-$category'),
                              label: category,
                              selected: controller.isSelectedCategory(category),
                              onTap: () => controller.selectCategory(category),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: '最新动态',
              subtitle: '按分类筛选家庭最关心的提醒，并为无消息场景保留稳定兜底',
            ),
            const SizedBox(height: 14),
            Obx(() {
              final visibleItems = controller.visibleItems;

              if (visibleItems.isEmpty) {
                return _MessagesEmptyState(
                  selectedCategory: controller.selectedCategory.value,
                  onReset: () => controller.selectCategory('全部'),
                );
              }

              return Column(
                children: visibleItems
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MessageTile(item: item),
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return HeroMetricTile(label: label, value: value);
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.info.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.info.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? AppColors.info : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MessagesEmptyState extends StatelessWidget {
  const _MessagesEmptyState({
    required this.selectedCategory,
    required this.onReset,
  });

  final String selectedCategory;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      key: const ValueKey('messages-empty-state'),
      accentColor: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.inbox_rounded, color: AppColors.info),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前没有新消息',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selectedCategory == '全部'
                          ? '护理站、健康提醒和探视通知同步后会显示在这里。'
                          : '“$selectedCategory” 分类下暂时没有消息，可以切回全部查看其他动态。',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton.tonalIcon(
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('查看全部消息'),
          ),
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final tone = _toneForCategory(item.category);
    final accentColor = switch (tone) {
      BadgeTone.success => AppColors.primary,
      BadgeTone.warning => AppColors.warning,
      BadgeTone.danger => AppColors.danger,
      BadgeTone.info => AppColors.info,
      BadgeTone.neutral => AppColors.textSecondary,
    };

    return FamilyCard(
      key: ValueKey('messages-tile-${item.title}'),
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  _iconForCategory(item.category),
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(item.body),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(label: item.category, tone: tone),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule_rounded, size: 16, color: accentColor),
                const SizedBox(width: 8),
                Text(item.time, style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Text(
                  '已同步护理站',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForCategory(String category) {
    if (category.contains('健康')) {
      return Icons.monitor_heart_rounded;
    }
    if (category.contains('探视')) {
      return Icons.videocam_rounded;
    }
    if (category.contains('账单')) {
      return Icons.receipt_long_rounded;
    }
    return Icons.chat_bubble_rounded;
  }

  BadgeTone _toneForCategory(String category) {
    if (category.contains('异常') || category.contains('预警')) {
      return BadgeTone.warning;
    }
    if (category.contains('健康') || category.contains('探视')) {
      return BadgeTone.info;
    }
    return BadgeTone.neutral;
  }
}
