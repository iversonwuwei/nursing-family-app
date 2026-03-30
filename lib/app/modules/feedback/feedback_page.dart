import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';

class FeedbackController extends GetxController {
  final rating = 4.obs;
  final selectedTags = <String>{}.obs;

  final tags = const ['沟通清晰', '响应及时', '护理细致', '视频流畅', '希望回访'];

  void updateRating(int value) {
    rating.value = value;
  }

  void toggleTag(String value) {
    if (selectedTags.contains(value)) {
      selectedTags.remove(value);
      return;
    }
    selectedTags.add(value);
  }
}

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return FamilyPage(
      title: '护理反馈',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '本次服务体验',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          onPressed: () => controller.updateRating(index + 1),
                          icon: Icon(
                            index < controller.rating.value
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: const Color(0xFFFFB300),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('请选择你最在意的反馈标签'),
                  const SizedBox(height: 12),
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.tags
                          .map(
                            (tag) => FilterChip(
                              label: Text(tag),
                              selected: controller.selectedTags.contains(tag),
                              onSelected: (_) => controller.toggleTag(tag),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Get.snackbar('反馈已记录', '感谢你的意见，护理主管会跟进查看。'),
                    child: const Text('提交反馈'),
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
