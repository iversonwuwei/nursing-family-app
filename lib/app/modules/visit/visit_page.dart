import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';
import 'package:nursing_family_app/app/widgets/status_badge.dart';

class VisitController extends GetxController {
  VisitController(this._service);

  final MockFamilyService _service;

  VisitAppointment get upcoming => _service.upcomingVisit;
  List<VisitAppointment> get history => _service.visitHistory;
  List<String> get suggestions => _service.visitSuggestions;
}

class VisitView extends GetView<VisitController> {
  const VisitView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: '探视中心', subtitle: '预约探视、远程视频与探视留痕统一入口'),
          const SizedBox(height: 14),
          _UpcomingVisitCard(appointment: controller.upcoming),
          const SizedBox(height: 14),
          const _VideoCallCard(),
          const SizedBox(height: 24),
          const SectionHeader(title: 'AI 探视建议', subtitle: '选择更适合老人状态的沟通时间'),
          const SizedBox(height: 14),
          _VisitSuggestionCard(suggestions: controller.suggestions),
          const SizedBox(height: 24),
          const SectionHeader(title: '探视记录', subtitle: '线下与视频探视统一留痕'),
          const SizedBox(height: 14),
          ...controller.history.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _VisitHistoryCard(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingVisitCard extends StatelessWidget {
  const _UpcomingVisitCard({required this.appointment});

  final VisitAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      backgroundColor: AppColors.beige,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('下一次探视', style: Theme.of(context).textTheme.titleMedium),
              StatusBadge(label: appointment.status, tone: BadgeTone.success),
            ],
          ),
          const SizedBox(height: 12),
          Text('${appointment.date} · ${appointment.period}'),
          const SizedBox(height: 6),
          Text('时长 ${appointment.duration} · 到访人数 ${appointment.visitors} 人'),
          const SizedBox(height: 6),
          Text(appointment.note),
        ],
      ),
    );
  }
}

class _VideoCallCard extends StatelessWidget {
  const _VideoCallCard();

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.videocam_rounded, color: AppColors.info),
              const SizedBox(width: 8),
              Text('远程视频', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text('支持探视、了解情况等场景，建议时长控制在 15 分钟以内。'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.videoCall),
            icon: const Icon(Icons.call_rounded),
            label: const Text('发起视频呼叫'),
          ),
        ],
      ),
    );
  }
}

class _VisitSuggestionCard extends StatelessWidget {
  const _VisitSuggestionCard({required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      backgroundColor: const Color(0xFFF3F8EE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...suggestions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.aiVisitAssistant),
            icon: const Icon(Icons.auto_awesome_outlined),
            label: const Text('打开 AI 探视助手'),
          ),
        ],
      ),
    );
  }
}

class _VisitHistoryCard extends StatelessWidget {
  const _VisitHistoryCard({required this.item});

  final VisitAppointment item;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.history_rounded, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.date} · ${item.period}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(item.note),
              ],
            ),
          ),
          StatusBadge(label: item.status, tone: BadgeTone.neutral),
        ],
      ),
    );
  }
}
