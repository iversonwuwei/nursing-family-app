import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: '护理记录', subtitle: '查看今日护理、用药和康复训练进度'),
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
            subtitle: '帮助家属理解为什么需要关注当前护理动作',
          ),
          const SizedBox(height: 14),
          const _AiCareNoteCard(),
        ],
      ),
    );
  }
}

class _CareRecordCard extends StatelessWidget {
  const _CareRecordCard({required this.record});

  final CareRecord record;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(record.time, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 10),
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
          const SizedBox(height: 10),
          Text(record.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(record.description),
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
      backgroundColor: const Color(0xFFEFF6FF),
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
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.feedback),
            icon: const Icon(Icons.rate_review_outlined),
            label: const Text('提交护理反馈'),
          ),
        ],
      ),
    );
  }
}
