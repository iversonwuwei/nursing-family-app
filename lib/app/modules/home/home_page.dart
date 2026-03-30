import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';
import 'package:nursing_family_app/app/widgets/status_badge.dart';

class HomeController extends GetxController {
  HomeController(this._service);

  final MockFamilyService _service;

  ElderSummary get elder => _service.currentElder;
  List<VitalMetric> get highlights => _service.vitalMetrics.take(3).toList();
  List<CareRecord> get todayCare => _service.todayCareRecords.take(3).toList();
  String get aiSummary => _service.todayAiSummary;
}

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroCard(elder: controller.elder),
          const SizedBox(height: 24),
          const SectionHeader(title: '今日状态', subtitle: '围绕信任、透明、沟通构建家属视角状态页'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.highlights
                .map((metric) => _StatusMetricCard(metric: metric))
                .toList(),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: '今日护理',
            subtitle: '已完成与即将开始的护理服务摘要',
            trailing: TextButton(onPressed: () {}, child: const Text('查看全部')),
          ),
          const SizedBox(height: 14),
          ...controller.todayCare.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CareTimelineTile(record: record),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: '快捷入口', subtitle: '探视、账单、反馈、通知与 AI 辅助能力'),
          const SizedBox(height: 14),
          const _QuickActionsGrid(),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'AI 今日摘要',
            subtitle: '家属友好的结论 + 解释 + 建议动作',
          ),
          const SizedBox(height: 14),
          _AiSummaryCard(summary: controller.aiSummary),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.elder});

  final ElderSummary elder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF7BC47F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      elder.name,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${elder.age} 岁  ·  房间 ${elder.room}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroMeta(label: '护理等级', value: elder.careLevel),
              _HeroMeta(label: '入住时间', value: elder.admittedAt),
              _HeroMeta(label: '家属身份', value: elder.familyRelation),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            elder.todayStatus,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _HeroMeta extends StatelessWidget {
  const _HeroMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x24FFFFFF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label\n',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusMetricCard extends StatelessWidget {
  const _StatusMetricCard({required this.metric});

  final VitalMetric metric;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 52) / 2,
      child: FamilyCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  metric.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                StatusBadge(
                  label: metric.status,
                  tone: metric.status == '正常'
                      ? BadgeTone.success
                      : BadgeTone.warning,
                ),
              ],
            ),
            const SizedBox(height: 14),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: metric.value,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextSpan(
                    text: ' ${metric.unit}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              metric.subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CareTimelineTile extends StatelessWidget {
  const _CareTimelineTile({required this.record});

  final CareRecord record;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      record.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(
                      label: record.status,
                      tone: record.status == '已完成'
                          ? BadgeTone.success
                          : record.status == '即将开始'
                          ? BadgeTone.info
                          : BadgeTone.warning,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(record.description),
                const SizedBox(height: 6),
                Text(
                  record.time,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    final actions = <({IconData icon, String label, String route})>[
      (icon: Icons.videocam_rounded, label: '视频呼叫', route: AppRoutes.videoCall),
      (
        icon: Icons.calendar_today_rounded,
        label: '预约探视',
        route: AppRoutes.aiVisitAssistant,
      ),
      (icon: Icons.receipt_long_rounded, label: '账单中心', route: AppRoutes.bills),
      (
        icon: Icons.chat_bubble_rounded,
        label: '消息中心',
        route: AppRoutes.messages,
      ),
      (
        icon: Icons.smart_toy_rounded,
        label: 'AI 今日摘要',
        route: AppRoutes.aiTodaySummary,
      ),
      (
        icon: Icons.rate_review_rounded,
        label: '护理反馈',
        route: AppRoutes.feedback,
      ),
    ];

    return GridView.builder(
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.98,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: () => Get.toNamed(action.route),
          child: FamilyCard(
            backgroundColor: index.isEven
                ? AppColors.beige
                : AppColors.lightBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action.icon, size: 28, color: AppColors.textPrimary),
                const SizedBox(height: 10),
                Text(
                  action.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AiSummaryCard extends StatelessWidget {
  const _AiSummaryCard({required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      backgroundColor: const Color(0xFFF3F8EE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('AI 家属助手', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text(summary),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => Get.toNamed(AppRoutes.aiTodaySummary),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('查看问答与解释'),
          ),
        ],
      ),
    );
  }
}
