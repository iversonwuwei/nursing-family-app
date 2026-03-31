import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/hero_panel.dart';
import 'package:nursing_family_app/app/widgets/responsive_metric_group.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';
import 'package:nursing_family_app/app/widgets/status_badge.dart';

class NursingController extends GetxController {
  NursingController(this._service);

  final MockFamilyService _service;

  List<CareRecord> get records => _service.todayCareRecords;
}

class NursingView extends GetView<NursingController> {
  const NursingView({super.key});

  @override
  Widget build(BuildContext context) {
    final completed = controller.records
        .where((item) => item.status == '已完成')
        .length;
    final upcoming = controller.records
        .where((item) => item.status == '即将开始')
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 188),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NursingOverviewCard(completed: completed, upcoming: upcoming),
          const SizedBox(height: 24),
          const SectionHeader(
            title: '护理记录',
            subtitle: '把护理动作做成可追踪的任务流，而不是传统流水列表',
          ),
          const SizedBox(height: 14),
          ...controller.records.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CareRecordCard(record: record),
            ),
          ),
          const SizedBox(height: 12),
          const SectionHeader(
            title: 'AI 护理建议',
            subtitle: '帮助家属理解当前护理动作背后的原因和关注重点',
          ),
          const SizedBox(height: 14),
          const _AiCareNoteCard(),
        ],
      ),
    );
  }
}

class _NursingOverviewCard extends StatelessWidget {
  const _NursingOverviewCard({required this.completed, required this.upcoming});

  final int completed;
  final int upcoming;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF102333), Color(0xFF0A1621)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroPanelHeader(
            icon: Icons.hub_rounded,
            color: AppColors.primary,
            title: '护理执行面板',
            subtitle: '今日护理完成度持续同步，家属可以快速判断已完成、待跟进和 AI 建议。',
          ),
          const SizedBox(height: 18),
          ResponsiveMetricGroup(
            spacing: 12,
            children: [
              _NursingMetricTile(
                label: '已完成',
                value: '$completed',
                color: AppColors.primary,
              ),
              _NursingMetricTile(
                label: '即将开始',
                value: '$upcoming',
                color: AppColors.info,
              ),
              const _NursingMetricTile(
                label: '关注度',
                value: '中',
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NursingMetricTile extends StatelessWidget {
  const _NursingMetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HeroMetricTile(label: label, value: value, valueColor: color);
  }
}

class _CareRecordCard extends StatelessWidget {
  const _CareRecordCard({required this.record});

  final CareRecord record;

  @override
  Widget build(BuildContext context) {
    final tone = record.status == '已完成'
        ? BadgeTone.success
        : record.status == '即将开始'
        ? BadgeTone.info
        : BadgeTone.warning;
    final accentColor = tone == BadgeTone.success
        ? AppColors.primary
        : tone == BadgeTone.info
        ? AppColors.info
        : AppColors.warning;

    return FamilyCard(
      accentColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.cardElevated,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.timeline_rounded, color: accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.time,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      record.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              StatusBadge(label: record.status, tone: tone),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.75),
              ),
            ),
            child: Text(record.description),
          ),
        ],
      ),
    );
  }
}

class _AiCareNoteCard extends StatelessWidget {
  const _AiCareNoteCard();

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF0F2237), Color(0xFF141D29)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.info),
              const SizedBox(width: 8),
              Text('护理说明', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text('下午康复训练前安排补水提醒，是为了减少训练时疲劳和头晕风险。今晚如果状态稳定，护理员会在睡前巡视后继续观察睡眠质量。'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _NursingTag(label: '训练前补水'),
              _NursingTag(label: '晚间睡眠复核'),
              _NursingTag(label: '风险偏低'),
            ],
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            key: const ValueKey('nursing-open-feedback'),
            onPressed: () => Get.toNamed(AppRoutes.feedback),
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('提交护理反馈'),
          ),
        ],
      ),
    );
  }
}

class _NursingTag extends StatelessWidget {
  const _NursingTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
