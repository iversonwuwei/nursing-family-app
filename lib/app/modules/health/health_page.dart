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
import 'package:nursing_family_app/app/widgets/sparkline_chart.dart';
import 'package:nursing_family_app/app/widgets/status_badge.dart';

class HealthController extends GetxController {
  HealthController(this._service);

  final MockFamilyService _service;

  List<VitalMetric> get metrics => _service.vitalMetrics;
}

class HealthView extends GetView<HealthController> {
  const HealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 188),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HealthHeroCard(metrics: controller.metrics),
          const SizedBox(height: 24),
          const SectionHeader(
            title: '健康趋势',
            subtitle: '用更接近车辆遥测的方式理解健康变化，不必读复杂医疗术语',
          ),
          const SizedBox(height: 14),
          ...controller.metrics.map(
            (metric) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TrendCard(metric: metric),
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeader(
            title: '家属友好解释',
            subtitle: '给出结论、原因和动作建议，而不是纯体征数值',
          ),
          const SizedBox(height: 14),
          const _HealthExplanationCard(),
        ],
      ),
    );
  }
}

class _HealthHeroCard extends StatelessWidget {
  const _HealthHeroCard({required this.metrics});

  final List<VitalMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 390;

        return FamilyCard(
          gradient: const LinearGradient(
            colors: [Color(0xFF10283F), Color(0xFF0B1724)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          accentColor: AppColors.info,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCompact) ...[
                HeroPanelHeader(
                  icon: Icons.monitor_heart_rounded,
                  color: AppColors.info,
                  title: '健康雷达',
                  subtitle: '连续同步 ${metrics.length} 项体征，AI 已完成今晚家属解释。',
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  key: const ValueKey('health-open-ai-summary-compact'),
                  onPressed: () => Get.toNamed(AppRoutes.aiTodaySummary),
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('AI 说明'),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HeroPanelHeader(
                        icon: Icons.monitor_heart_rounded,
                        color: AppColors.info,
                        title: '健康雷达',
                        subtitle: '连续同步 ${metrics.length} 项体征，AI 已完成今晚家属解释。',
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      key: const ValueKey('health-open-ai-summary'),
                      onPressed: () => Get.toNamed(AppRoutes.aiTodaySummary),
                      icon: const Icon(Icons.auto_awesome_outlined),
                      label: const Text('AI 说明'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              ResponsiveMetricGroup(
                spacing: 12,
                children: [
                  _HealthHeroMetric(
                    label: '稳定项',
                    value:
                        '${metrics.where((item) => item.status == '正常').length}',
                    color: AppColors.primary,
                  ),
                  _HealthHeroMetric(
                    label: '关注项',
                    value:
                        '${metrics.where((item) => item.status != '正常').length}',
                    color: AppColors.warning,
                  ),
                  const _HealthHeroMetric(
                    label: '状态',
                    value: '平稳',
                    color: AppColors.info,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HealthHeroMetric extends StatelessWidget {
  const _HealthHeroMetric({
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

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.metric});

  final VitalMetric metric;

  @override
  Widget build(BuildContext context) {
    final delta = metric.points.last - metric.points.first;
    final deltaLabel = delta.abs() < 0.2
        ? '平稳'
        : '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}';

    return FamilyCard(
      accentColor: metric.status == '正常'
          ? AppColors.primary
          : AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardElevated,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  deltaLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: metric.status == '正常'
                        ? AppColors.primary
                        : AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
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
              StatusBadge(
                label: metric.status,
                tone: metric.status == '正常'
                    ? BadgeTone.success
                    : BadgeTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(metric.subtitle),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '连续 7 日趋势',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                SparklineChart(points: metric.points),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthExplanationCard extends StatelessWidget {
  const _HealthExplanationCard();

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF1E2434), Color(0xFF101A28)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: AppColors.coral,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_rounded,
                color: AppColors.coral,
              ),
              const SizedBox(width: 8),
              Text('AI 健康说明', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '睡眠时长连续两天略短，但血压和心率保持稳定，当前更像是休息质量问题，而不是急性健康风险。建议今晚视频时提醒早点休息，若连续三天睡眠继续下降，再联系护理站复核。',
          ),
          const SizedBox(height: 12),
          const _ExplanationBullet(label: '当前风险等级：低'),
          const SizedBox(height: 8),
          const _ExplanationBullet(label: '建议动作：今晚视频沟通时提醒早点休息'),
          const SizedBox(height: 8),
          const _ExplanationBullet(label: '升级条件：连续三天睡眠继续下降'),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            key: const ValueKey('health-open-ai-summary-footer'),
            onPressed: () => Get.toNamed(AppRoutes.aiTodaySummary),
            icon: const Icon(Icons.smart_toy_outlined),
            label: const Text('打开 AI 问答'),
          ),
        ],
      ),
    );
  }
}

class _ExplanationBullet extends StatelessWidget {
  const _ExplanationBullet({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(
            Icons.fiber_manual_record_rounded,
            size: 10,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
      ],
    );
  }
}
