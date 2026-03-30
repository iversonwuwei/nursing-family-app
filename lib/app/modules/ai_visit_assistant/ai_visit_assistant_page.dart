import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';

class AiVisitAssistantController extends GetxController {
  AiVisitAssistantController(this._service);

  final MockFamilyService _service;

  List<String> get suggestions => _service.visitSuggestions;
  final preferredSlots = const ['明天下午 14:00', '后天上午 10:00', '周六下午 15:00'];
}

class AiVisitAssistantView extends GetView<AiVisitAssistantController> {
  const AiVisitAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return FamilyPage(
      title: 'AI 探视助手',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyCard(
              backgroundColor: const Color(0xFFF5F0E8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '推荐沟通时间',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: controller.preferredSlots
                        .map((slot) => Chip(label: Text(slot)))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FamilyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('探视建议', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...controller.suggestions.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.check_circle_rounded, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.videoCall),
                    icon: const Icon(Icons.videocam_rounded),
                    label: const Text('先发起视频沟通'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
