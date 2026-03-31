import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';
import 'package:nursing_family_app/app/widgets/hero_panel.dart';
import 'package:nursing_family_app/app/widgets/responsive_metric_group.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';

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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FamilyCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF16253B), Color(0xFF121A29)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                accentColor: AppColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeroPanelHeader(
                      icon: Icons.mode_comment_rounded,
                      color: AppColors.primary,
                      title: '服务体验脉冲',
                      subtitle: '把评分、反馈标签和回访诉求压缩成一条护理体验回路',
                    ),
                    const SizedBox(height: 18),
                    ResponsiveMetricGroup(
                      children: [
                        _FeedbackMetric(
                          label: '满意度',
                          value: '${controller.rating.value}.0',
                          highlight: AppColors.warning,
                        ),
                        _FeedbackMetric(
                          label: '已选标签',
                          value: '${controller.selectedTags.length}',
                          highlight: AppColors.info,
                        ),
                        _FeedbackMetric(
                          label: '处理路径',
                          value: '主管复核',
                          highlight: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(
                title: '本次服务体验',
                subtitle: '先给出主观评分，再选择最关键的护理感受标签',
              ),
              const SizedBox(height: 14),
              FamilyCard(
                accentColor: AppColors.warning,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '星级评分',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            key: ValueKey('feedback-rating-${index + 1}'),
                            onTap: () => controller.updateRating(index + 1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: index < controller.rating.value
                                    ? AppColors.warning.withValues(alpha: 0.18)
                                    : AppColors.cardElevated,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: index < controller.rating.value
                                      ? AppColors.warning.withValues(
                                          alpha: 0.42,
                                        )
                                      : AppColors.border,
                                ),
                              ),
                              child: Icon(
                                index < controller.rating.value
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _ratingLabel(controller.rating.value),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FamilyCard(
                accentColor: AppColors.info,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '反馈标签',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text('请选择你最在意的反馈点，护理主管会按标签聚类跟进。'),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.tags
                          .map(
                            (tag) => _FeedbackTag(
                              key: ValueKey('feedback-tag-$tag'),
                              label: tag,
                              selected: controller.selectedTags.contains(tag),
                              onTap: () => controller.toggleTag(tag),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      key: const ValueKey('feedback-submit'),
                      onPressed: () => Get.snackbar('反馈已记录', '感谢你的意见，护理主管会跟进查看。'),
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('提交反馈'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _ratingLabel(int value) {
    return switch (value) {
      5 => '体验非常稳定，建议保持当前服务节奏',
      4 => '整体满意，可补充一些细节改进建议',
      3 => '体验一般，建议重点标注问题场景',
      2 => '存在明显问题，建议护理主管回访',
      _ => '服务体验较差，需要尽快介入处理',
    };
  }
}

class _FeedbackMetric extends StatelessWidget {
  const _FeedbackMetric({
    required this.label,
    required this.value,
    required this.highlight,
  });

  final String label;
  final String value;
  final Color highlight;

  @override
  Widget build(BuildContext context) {
    return HeroMetricTile(label: label, value: value, valueColor: highlight);
  }
}

class _FeedbackTag extends StatelessWidget {
  const _FeedbackTag({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.info.withValues(alpha: 0.16)
              : AppColors.cardElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.info.withValues(alpha: 0.42)
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? AppColors.info : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
