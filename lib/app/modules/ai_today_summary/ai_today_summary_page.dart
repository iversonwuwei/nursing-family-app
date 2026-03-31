import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';
import 'package:nursing_family_app/app/widgets/hero_panel.dart';
import 'package:nursing_family_app/app/widgets/responsive_metric_group.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';

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
              gradient: const LinearGradient(
                colors: [Color(0xFF102B33), Color(0xFF111A26)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              accentColor: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeroPanelHeader(
                    icon: Icons.auto_awesome_rounded,
                    color: AppColors.primary,
                    title: 'AI 今日摘要引擎',
                    subtitle: '快速切换问法，让 AI 用同一份实时数据给出不同视角解释',
                  ),
                  const SizedBox(height: 18),
                  ResponsiveMetricGroup(
                    children: [
                      _AiMetric(
                        label: '可问问题',
                        value: '${controller.prompts.length}',
                        color: AppColors.primary,
                      ),
                      _AiMetric(
                        label: '当前模式',
                        value: '解释',
                        color: AppColors.info,
                      ),
                      _AiMetric(
                        label: '数据源',
                        value: '今日护理',
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: '建议问法',
              subtitle: '保留 AI 推荐问题，但改成更像控制面板的切换区',
            ),
            const SizedBox(height: 14),
            if (controller.prompts.isEmpty)
              const _AiSummaryEmptyState(
                key: ValueKey('ai-summary-empty-state'),
                title: '当前没有 AI 问法',
                description: '今日护理摘要尚未生成时，AI 问答区会保留稳定空态。',
              )
            else ...[
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    controller.prompts.length,
                    (index) => _PromptChip(
                      key: ValueKey('ai-summary-prompt-$index'),
                      label: controller.prompts[index].question,
                      selected: controller.selectedIndex.value == index,
                      onTap: () => controller.selectPrompt(index),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => FamilyCard(
                  key: const ValueKey('ai-summary-answer-card'),
                  accentColor: AppColors.info,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '当前问题',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.selectedPrompt.question,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.7),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI 结论',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(controller.selectedPrompt.answer),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          _AdvicePill(label: '继续观察晚间状态'),
                          _AdvicePill(label: '必要时发起视频沟通'),
                          _AdvicePill(label: '可转护理站复核'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AiMetric extends StatelessWidget {
  const _AiMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HeroMetricTile(label: label, value: value, valueColor: color);
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip({
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
          color: selected ? AppColors.primarySoft : AppColors.cardElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.42)
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AiSummaryEmptyState extends StatelessWidget {
  const _AiSummaryEmptyState({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      accentColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.auto_awesome_motion_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(description),
                  ],
                ),
              ),
            ],
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
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
