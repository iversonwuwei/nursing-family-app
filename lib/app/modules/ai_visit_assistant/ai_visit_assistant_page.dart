import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/routes/app_routes.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';

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
              gradient: const LinearGradient(
                colors: [Color(0xFF142E3C), Color(0xFF0F1724)],
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.route_rounded,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI 探视编排',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text('根据护理节奏与视频可用时段，优先给出更容易接通的时间窗口'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: controller.preferredSlots
                        .map((slot) => _SlotChip(label: slot))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: '探视建议',
              subtitle: '把建议拆成可执行动作，而不是一段普通说明',
            ),
            const SizedBox(height: 14),
            if (controller.suggestions.isEmpty)
              const _AiVisitEmptyState(
                key: ValueKey('ai-visit-empty-state'),
                title: '当前没有 AI 探视建议',
                description: '建议尚未生成时，仍可直接发起视频沟通或稍后提醒。',
              )
            else
              FamilyCard(
                key: const ValueKey('ai-visit-suggestions-card'),
                accentColor: AppColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...controller.suggestions.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SuggestionTile(
                          index: entry.key + 1,
                          suggestion: entry.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        FilledButton.icon(
                          key: const ValueKey('ai-visit-open-video-call'),
                          onPressed: () => Get.toNamed(AppRoutes.videoCall),
                          icon: const Icon(Icons.videocam_rounded),
                          label: const Text('先发起视频沟通'),
                        ),
                        OutlinedButton.icon(
                          key: const ValueKey('ai-visit-remind-later'),
                          onPressed: () =>
                              Get.snackbar('已提醒', '系统会在建议时段前提醒你发起探视。'),
                          icon: const Icon(Icons.notifications_active_rounded),
                          label: const Text('稍后提醒我'),
                        ),
                      ],
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

class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule_rounded, size: 16, color: AppColors.info),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.index, required this.suggestion});

  final int index;
  final String suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('ai-visit-suggestion-$index'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(suggestion)),
        ],
      ),
    );
  }
}

class _AiVisitEmptyState extends StatelessWidget {
  const _AiVisitEmptyState({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      accentColor: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.route_rounded, color: AppColors.info),
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
