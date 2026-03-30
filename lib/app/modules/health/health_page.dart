import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '健康趋势',
            subtitle: '按日 / 周 / 月理解状态，不用读复杂医疗术语',
          ),
          const SizedBox(height: 14),
          ...controller.metrics.map(
            (metric) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TrendCard(metric: metric),
            ),
          ),
          const SizedBox(height: 12),
          const SectionHeader(title: '家属友好解释', subtitle: '结论 + 原因 + 建议动作'),
          const SizedBox(height: 14),
          const _HealthExplanationCard(),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.metric});

  final VitalMetric metric;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
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
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metric.value,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  metric.unit,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(metric.subtitle),
          const SizedBox(height: 14),
          SparklineChart(points: metric.points),
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
      backgroundColor: const Color(0xFFF7F2EA),
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
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.aiTodaySummary),
            icon: const Icon(Icons.smart_toy_outlined),
            label: const Text('打开 AI 问答'),
          ),
        ],
      ),
    );
  }
}
