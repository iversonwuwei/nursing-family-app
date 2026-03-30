import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';

class AiTodaySummaryController extends GetxController {
  AiTodaySummaryController(this._service);

  final MockFamilyService _service;
  final selectedIndex = 0.obs;

  List<AiPromptItem> get prompts => _service.todayAiPrompts;

  AiPromptItem get selectedPrompt => prompts[selectedIndex.value];

  void selectPrompt(int index) {
    selectedIndex.value = index;
  }
}

class AiTodaySummaryView extends GetView<AiTodaySummaryController> {
  const AiTodaySummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return FamilyPage(
      title: 'AI 今日摘要',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyCard(
              backgroundColor: const Color(0xFFF3F8EE),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('建议问法', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        controller.prompts.length,
                        (index) => ChoiceChip(
                          label: Text(controller.prompts[index].question),
                          selected: controller.selectedIndex.value == index,
                          onSelected: (_) => controller.selectPrompt(index),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => FamilyCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedPrompt.question,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(controller.selectedPrompt.answer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
