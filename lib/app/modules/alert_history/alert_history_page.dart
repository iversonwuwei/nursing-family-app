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

class AlertHistoryController extends GetxController {
  AlertHistoryController(this._service);

  final MockFamilyService _service;

  final RxString selectedLevel = '全部'.obs;

  List<AlertEvent> get alerts {
    final sortedAlerts = [..._service.alerts];
    sortedAlerts.sort(_compareAlerts);
    return sortedAlerts;
  }

  List<String> get levels => [
    '全部',
    ...alerts.map((alert) => alert.level).toSet(),
  ];

  List<AlertEvent> get visibleAlerts {
    if (selectedLevel.value == '全部') {
      return alerts;
    }

    return alerts.where((alert) => alert.level == selectedLevel.value).toList();
  }

  int get p2Count => alerts.where((alert) => alert.level == 'P2').length;

  String get latestUpdate => alerts.isEmpty ? '暂无' : alerts.first.time;

  void selectLevel(String level) {
    selectedLevel.value = level;
  }

  bool isSelectedLevel(String level) => selectedLevel.value == level;

  int _compareAlerts(AlertEvent left, AlertEvent right) {
    final leftTime = DateTime.tryParse(left.time.replaceFirst(' ', 'T'));
    final rightTime = DateTime.tryParse(right.time.replaceFirst(' ', 'T'));
    if (leftTime == null || rightTime == null) {
      return 0;
    }

    return rightTime.compareTo(leftTime);
  }
}

class AlertHistoryView extends GetView<AlertHistoryController> {
  const AlertHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = controller.levels;

    return FamilyPage(
      title: '报警历史',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF301A22), Color(0xFF0E1725)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              accentColor: AppColors.danger,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeroPanelHeader(
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.danger,
                    title: '预警轨迹',
                    subtitle: '将异常事件按等级和时间回放，方便快速判断风险是否持续',
                  ),
                  const SizedBox(height: 18),
                  ResponsiveMetricGroup(
                    children: [
                      _AlertMetric(
                        label: '总事件',
                        value: '${controller.alerts.length}',
                      ),
                      _AlertMetric(
                        label: 'P2 预警',
                        value: '${controller.p2Count}',
                      ),
                      _AlertMetric(
                        label: '最近更新',
                        value: controller.latestUpdate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: levels
                          .map(
                            (level) => _AlertFilterChip(
                              key: ValueKey('alerts-filter-$level'),
                              label: level,
                              selected: controller.isSelectedLevel(level),
                              onTap: () => controller.selectLevel(level),
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
              title: '事件回放',
              subtitle: '按等级筛选异常事件，并为空结果保留稳定兜底',
            ),
            const SizedBox(height: 14),
            Obx(() {
              final visibleAlerts = controller.visibleAlerts;
              if (visibleAlerts.isEmpty) {
                return _AlertsEmptyState(
                  selectedLevel: controller.selectedLevel.value,
                  onReset: () => controller.selectLevel('全部'),
                );
              }

              return Column(
                children: visibleAlerts
                    .map(
                      (alert) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AlertTile(alert: alert),
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

class _AlertMetric extends StatelessWidget {
  const _AlertMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return HeroMetricTile(label: label, value: value);
  }
}

class _AlertFilterChip extends StatelessWidget {
  const _AlertFilterChip({
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
              ? AppColors.danger.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.danger.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? AppColors.danger : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AlertsEmptyState extends StatelessWidget {
  const _AlertsEmptyState({required this.selectedLevel, required this.onReset});

  final String selectedLevel;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      key: const ValueKey('alerts-empty-state'),
      accentColor: AppColors.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.history_toggle_off_rounded,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前没有报警记录',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selectedLevel == '全部'
                          ? '新的异常事件同步后会显示在这里，当前保持只读历史视图。'
                          : '“$selectedLevel” 等级下暂时没有报警记录，可以切回全部查看。',
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
            label: const Text('查看全部事件'),
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});

  final AlertEvent alert;

  @override
  Widget build(BuildContext context) {
    final tone = alert.level == 'P2' ? BadgeTone.warning : BadgeTone.info;
    final accentColor = tone == BadgeTone.warning
        ? AppColors.warning
        : AppColors.info;

    return FamilyCard(
      key: ValueKey('alerts-tile-${alert.title}'),
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.sensors_rounded, color: accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alert.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusBadge(label: alert.level, tone: tone),
            ],
          ),
          const SizedBox(height: 12),
          Text(alert.description),
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
                Text(alert.time),
                const Spacer(),
                Text(
                  '等待复核',
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
}
