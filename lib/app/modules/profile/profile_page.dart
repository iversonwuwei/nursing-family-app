import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/responsive_metric_group.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';

class ProfileController extends GetxController {
  ProfileController(this._service);

  final MockFamilyService _service;

  ElderSummary get elder => _service.currentElder;
}

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final actions =
        <({IconData icon, String title, String subtitle, String route})>[
          (
            icon: Icons.chat_bubble_rounded,
            title: '消息中心',
            subtitle: '护理完成、健康异常、账单、探视提醒',
            route: AppRoutes.messages,
          ),
          (
            icon: Icons.receipt_long_rounded,
            title: '账单中心',
            subtitle: '护理费用、支付记录、欠费提醒',
            route: AppRoutes.bills,
          ),
          (
            icon: Icons.warning_amber_rounded,
            title: '报警历史',
            subtitle: '离床、异常波动等历史提醒',
            route: AppRoutes.alertHistory,
          ),
          (
            icon: Icons.rate_review_rounded,
            title: '护理反馈',
            subtitle: '提交服务评价与改进建议',
            route: AppRoutes.feedback,
          ),
        ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 188),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHero(elder: controller.elder),
          const SizedBox(height: 24),
          const SectionHeader(
            title: '联动状态',
            subtitle: '把家属端最常关心的接入状态压缩成一排服务信号',
          ),
          const SizedBox(height: 14),
          const _ProfileStatusRail(),
          const SizedBox(height: 24),
          const SectionHeader(
            title: '我的服务',
            subtitle: '将消息、账单、预警和服务反馈整合成统一服务矩阵',
          ),
          const SizedBox(height: 14),
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProfileActionTile(
                key: ValueKey('profile-action-${action.title}'),
                icon: action.icon,
                title: action.title,
                subtitle: action.subtitle,
                onTap: () => Get.toNamed(action.route),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.elder});

  final ElderSummary elder;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF14283B), Color(0xFF101A26)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primarySoft, AppColors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 34,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      elder.familyRelation,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text('已绑定老人：${elder.name}'),
                    const SizedBox(height: 4),
                    Text('房间 ${elder.room} · 护理等级 ${elder.careLevel}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _ProfileTag(label: '24h 状态同步'),
              _ProfileTag(label: 'AI 解释已开启'),
              _ProfileTag(label: '探视服务正常'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  const _ProfileTag({required this.label});

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
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FamilyCard(
        accentColor: AppColors.info,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.cardElevated,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatusRail extends StatelessWidget {
  const _ProfileStatusRail();

  @override
  Widget build(BuildContext context) {
    return const ResponsiveMetricGroup(
      children: [
        _ProfileMetricTile(
          label: '消息链路',
          value: '正常',
          detail: '护理动态、账单提醒与系统通知保持同步回流',
          icon: Icons.chat_bubble_rounded,
          color: AppColors.info,
        ),
        _ProfileMetricTile(
          label: '探视服务',
          value: '可用',
          detail: '视频探视与预约入口状态稳定，可直接发起连接',
          icon: Icons.videocam_rounded,
          color: AppColors.primary,
        ),
        _ProfileMetricTile(
          label: 'AI 助理',
          value: '在线',
          detail: '今日摘要、用药解释与问答服务持续响应中',
          icon: Icons.auto_awesome_rounded,
          color: AppColors.accent,
        ),
      ],
    );
  }
}

class _ProfileMetricTile extends StatelessWidget {
  const _ProfileMetricTile({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  Widget _buildStatusPill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      padding: const EdgeInsets.all(16),
      accentColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: _buildStatusPill(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
