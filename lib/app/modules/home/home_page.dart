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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 188),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HomeTopBar(),
          const SizedBox(height: 14),
          const _HomeSignalRail(),
          const SizedBox(height: 18),
          _HeroCard(elder: controller.elder),
          const SizedBox(height: 24),
          const SectionHeader(
            title: '今日状态',
            subtitle: '把生理波动、护理执行和风险提示压缩进一块更像座舱仪表的总览屏',
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 232,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.highlights.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  _StatusMetricCard(metric: controller.highlights[index]),
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: '今日护理',
            subtitle: '像查看车辆行程轨迹一样查看护理进度和下一步动作',
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
          const SectionHeader(
            title: '快捷入口',
            subtitle: '把最常用操作排成控制面板，而不是普通宫格菜单',
          ),
          const SizedBox(height: 14),
          const _QuickActionsGrid(),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'AI 今日摘要',
            subtitle: '用更直接的结论、原因和建议动作替代冗长说明',
          ),
          const SizedBox(height: 14),
          _AiSummaryCard(summary: controller.aiSummary),
        ],
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'FAMILY CONTROL',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text('家属智护舱', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                '护理站、健康监测与 AI 分析保持同屏联动',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const _TopActionButton(
          icon: Icons.notifications_none_rounded,
          highlighted: true,
        ),
        const SizedBox(width: 10),
        const _TopActionButton(icon: Icons.tune_rounded),
      ],
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({required this.icon, this.highlighted = false});

  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.cardElevated.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Center(child: Icon(icon, color: AppColors.textPrimary)),
          if (highlighted)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeSignalRail extends StatelessWidget {
  const _HomeSignalRail();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 390;

        if (!isCompact) {
          return Row(
            children: const [
              Expanded(
                child: _HomeRailMetric(
                  label: '监测链路',
                  value: '稳定',
                  icon: Icons.sensors_rounded,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _HomeRailMetric(
                  label: '护理站',
                  value: '在线',
                  icon: Icons.hub_rounded,
                  color: AppColors.info,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _HomeRailMetric(
                  label: 'AI 解释',
                  value: '已开启',
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.accent,
                ),
              ),
            ],
          );
        }

        return Column(
          children: const [
            Row(
              children: [
                Expanded(
                  child: _HomeRailMetric(
                    label: '监测链路',
                    value: '稳定',
                    icon: Icons.sensors_rounded,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _HomeRailMetric(
                    label: '护理站',
                    value: '在线',
                    icon: Icons.hub_rounded,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _HomeRailBanner(
              label: 'AI 解释',
              value: '已开启',
              description: '当前家属解释链路在线，可直接进入 AI 今日摘要。',
              icon: Icons.auto_awesome_rounded,
              color: AppColors.accent,
            ),
          ],
        );
      },
    );
  }
}

class _HomeRailMetric extends StatelessWidget {
  const _HomeRailMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeRailBanner extends StatelessWidget {
  const _HomeRailBanner({
    required this.label,
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String description;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 390;

        return Container(
          padding: EdgeInsets.all(isCompact ? 20 : 24),
          decoration: BoxDecoration(
            gradient: AppGradients.hero,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.glow.withValues(alpha: 0.28),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -10,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.accent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '实时在线',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              elder.name,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${elder.age} 岁 · 房间 ${elder.room}',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.76),
                                  ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              elder.todayStatus,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      _ConfidenceDial(score: 96, size: isCompact ? 84 : 96),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _HeroMetaPanel(elder: elder, compact: isCompact),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: isCompact
                        ? const Column(
                            children: [
                              _SignalChip(
                                icon: Icons.health_and_safety_rounded,
                                label: '健康稳定',
                                accentColor: AppColors.primary,
                              ),
                              SizedBox(height: 10),
                              _SignalChip(
                                icon: Icons.psychology_alt_rounded,
                                label: 'AI 跟踪中',
                                accentColor: AppColors.info,
                              ),
                            ],
                          )
                        : const Row(
                            children: [
                              Expanded(
                                child: _SignalChip(
                                  icon: Icons.health_and_safety_rounded,
                                  label: '健康稳定',
                                  accentColor: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: _SignalChip(
                                  icon: Icons.psychology_alt_rounded,
                                  label: 'AI 跟踪中',
                                  accentColor: AppColors.info,
                                ),
                              ),
                            ],
                          ),
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

class _ConfidenceDial extends StatelessWidget {
  const _ConfidenceDial({required this.score, this.size = 108});

  final int score;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontSize: size < 90 ? 24 : 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '安心指数',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({
    required this.icon,
    required this.label,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetaPanel extends StatelessWidget {
  const _HeroMetaPanel({required this.elder, required this.compact});

  final ElderSummary elder;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (!compact) {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _HeroMeta(label: '护理等级', value: elder.careLevel),
          _HeroMeta(label: '入住时间', value: elder.admittedAt),
          _HeroMeta(label: '家属身份', value: elder.familyRelation),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _HeroMeta(label: '护理等级', value: elder.careLevel),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _HeroMeta(label: '入住时间', value: elder.admittedAt),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _HeroMeta(label: '家属身份', value: elder.familyRelation, fullWidth: true),
      ],
    );
  }
}

class _HeroMeta extends StatelessWidget {
  const _HeroMeta({
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

  final String label;
  final String value;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
    final accentColor = metric.status == '正常'
        ? AppColors.primary
        : AppColors.warning;

    return SizedBox(
      width: 188,
      child: FamilyCard(
        accentColor: accentColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(_metricIcon(metric.label), color: accentColor),
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
            Text(metric.label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
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
            const SizedBox(height: 6),
            Text(
              metric.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  IconData _metricIcon(String label) {
    if (label.contains('心率')) {
      return Icons.favorite_rounded;
    }
    if (label.contains('血压')) {
      return Icons.monitor_heart_rounded;
    }
    if (label.contains('睡眠')) {
      return Icons.bedtime_rounded;
    }
    return Icons.insights_rounded;
  }
}

class _CareTimelineTile extends StatelessWidget {
  const _CareTimelineTile({required this.record});

  final CareRecord record;

  @override
  Widget build(BuildContext context) {
    final tone = record.status == '已完成'
        ? BadgeTone.success
        : record.status == '即将开始'
        ? BadgeTone.info
        : BadgeTone.warning;

    return FamilyCard(
      accentColor: tone == BadgeTone.success
          ? AppColors.primary
          : tone == BadgeTone.info
          ? AppColors.info
          : AppColors.warning,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
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
                    StatusBadge(label: record.status, tone: tone),
                  ],
                ),
                const SizedBox(height: 6),
                Text(record.description),
                const SizedBox(height: 10),
                Text(
                  record.time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
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

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    final actions =
        <
          ({IconData icon, String label, String route, String tag, Color color})
        >[
          (
            icon: Icons.videocam_rounded,
            label: '视频呼叫',
            route: AppRoutes.videoCall,
            tag: '连接',
            color: AppColors.info,
          ),
      (
        icon: Icons.calendar_today_rounded,
        label: '预约探视',
        route: AppRoutes.aiVisitAssistant,
            tag: '规划',
            color: AppColors.primary,
      ),
          (
            icon: Icons.receipt_long_rounded,
            label: '账单中心',
            route: AppRoutes.bills,
            tag: '费用',
            color: AppColors.warning,
          ),
      (
        icon: Icons.chat_bubble_rounded,
        label: '消息中心',
        route: AppRoutes.messages,
            tag: '提醒',
            color: AppColors.coral,
      ),
      (
        icon: Icons.smart_toy_rounded,
        label: 'AI 今日摘要',
        route: AppRoutes.aiTodaySummary,
            tag: '智能',
            color: AppColors.primary,
      ),
      (
        icon: Icons.rate_review_rounded,
        label: '护理反馈',
        route: AppRoutes.feedback,
            tag: '评价',
            color: AppColors.info,
      ),
    ];

    return GridView.builder(
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.28,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          key: ValueKey('home-quick-action-${action.label}'),
          onTap: () => Get.toNamed(action.route),
          child: FamilyCard(
            backgroundColor: index.isEven
                ? AppColors.beige
                : AppColors.lightBlue,
            accentColor: action.color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: action.color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(action.icon, color: action.color),
                    ),
                    Text(
                      action.tag,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: action.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  action.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('打开', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: action.color,
                    ),
                  ],
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
      gradient: const LinearGradient(
        colors: [Color(0xFF11253A), Color(0xFF16282D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
              Text('AI 家属助手', style: Theme.of(context).textTheme.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '今晚建议',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(summary),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _AdvicePill(label: '继续观察睡眠'),
              _AdvicePill(label: '晚间视频沟通'),
              _AdvicePill(label: '暂不需要紧急就医'),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            key: const ValueKey('home-open-ai-summary'),
            onPressed: () => Get.toNamed(AppRoutes.aiTodaySummary),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('查看问答与解释'),
          ),
        ],
      ),
    );
  }
}

class _AdvicePill extends StatelessWidget {
  const _AdvicePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
