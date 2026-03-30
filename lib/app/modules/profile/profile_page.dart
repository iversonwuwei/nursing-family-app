import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FamilyCard(
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person_rounded, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.elder.familyRelation,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text('已绑定老人：${controller.elder.name}'),
                      const SizedBox(height: 4),
                      Text(
                        '房间 ${controller.elder.room} · 护理等级 ${controller.elder.careLevel}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: '我的服务', subtitle: '账号管理、消息、账单与服务反馈入口'),
          const SizedBox(height: 14),
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProfileActionTile(
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

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
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
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFF5F0E8),
              child: Icon(icon),
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
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
