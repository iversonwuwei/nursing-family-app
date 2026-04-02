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
  final selectedDate = ''.obs;
  final selectedPeriod = ''.obs;
  final selectedDuration = ''.obs;
  final visitorsController = TextEditingController(text: '2');
  final companionsController = TextEditingController(text: '陈涛');
  final noteController = TextEditingController();
  final bookingDecision = Rxn<VisitBookingDecision>();
  final _formVersion = 0.obs;

  @override
  void onInit() {
    selectedDate.value = availableDates.first;
    selectedPeriod.value = availablePeriods.first;
    selectedDuration.value = durationOptions[1];
    visitorsController.addListener(_touchForm);
    companionsController.addListener(_touchForm);
    noteController.addListener(_touchForm);
    super.onInit();
  }

  @override
  void onClose() {
    visitorsController.dispose();
    companionsController.dispose();
    noteController.dispose();
    super.onClose();
  }

  VisitAppointment get upcoming => _service.upcomingVisit;
  List<VisitAppointment> get history => _service.visitHistory;
  List<String> get suggestions => _service.visitSuggestions;
  List<String> get policies => _service.visitPolicies;
  VisitAiRiskAnalysis get aiRisk => _service.visitAiRiskAnalysis;
  List<String> get availableDates => _service.availableVisitDates;
  List<String> get availablePeriods => _service.availableVisitPeriods;
  List<String> get durationOptions => _service.availableVisitDurations;
  int get formVersion => _formVersion.value;

  VisitBookingDraft get currentDraft => VisitBookingDraft(
    date: selectedDate.value,
    period: selectedPeriod.value,
    duration: selectedDuration.value,
    visitors: int.tryParse(visitorsController.text.trim()) ?? 0,
    companions: companionsController.text
        .split('、')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(),
    note: noteController.text,
  );

  List<VisitRuleCheck> get currentChecks =>
      _service.evaluateVisitRequest(currentDraft);

  bool get hasBlockingChecks => currentChecks.any((item) => item.isBlocking);

  void selectDate(String value) {
    selectedDate.value = value;
    _touchForm();
  }

  void selectPeriod(String value) {
    selectedPeriod.value = value;
    _touchForm();
  }

  void selectDuration(String value) {
    selectedDuration.value = value;
    _touchForm();
  }

  void submitBooking() {
    bookingDecision.value = _service.submitVisitRequest(currentDraft);
    _touchForm();
  }

  void _touchForm() {
    _formVersion.value++;
  }
}

class VisitView extends GetView<VisitController> {
  const VisitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.formVersion;
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 188),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: '探视中心',
              subtitle: '把预约、视频和探视记录做成一条完整的陪伴链路',
            ),
            const SizedBox(height: 14),
            _VisitBookingCard(controller: controller),
            const SizedBox(height: 14),
            _UpcomingVisitCard(appointment: controller.upcoming),
            const SizedBox(height: 14),
            const _VideoCallCard(),
            const SizedBox(height: 24),
            const SectionHeader(title: 'AI 探视建议', subtitle: '选择更适合老人状态的沟通时间'),
            const SizedBox(height: 14),
            controller.suggestions.isEmpty
                ? const _VisitSectionEmptyState(
                    key: ValueKey('visit-suggestions-empty-state'),
                    title: '当前没有探视建议',
                    description: 'AI 建议暂未生成时，仍可直接发起视频沟通或稍后再查看。',
                  )
                : _VisitSuggestionCard(suggestions: controller.suggestions),
            const SizedBox(height: 24),
            const SectionHeader(title: '探视记录', subtitle: '线下与视频探视统一留痕'),
            const SizedBox(height: 14),
            if (controller.history.isEmpty)
              const _VisitSectionEmptyState(
                key: ValueKey('visit-history-empty-state'),
                title: '当前没有探视记录',
                description: '新的线下或视频探视完成后，会在这里保留历史记录。',
              )
            else
              ...controller.history.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _VisitHistoryCard(item: item),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _VisitBookingCard extends StatelessWidget {
  const _VisitBookingCard({required this.controller});

  final VisitController controller;

  @override
  Widget build(BuildContext context) {
    final decision = controller.bookingDecision.value;

    return FamilyCard(
      key: const ValueKey('visit-booking-card'),
      accentColor: AppColors.primary,
      backgroundColor: AppColors.beige,
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
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '发起预约探视',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text('系统会先检查重复预约、人数限制和 AI 给出的老人状态拦截，再决定是否自动通过。'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _BookingTagGroup(
            title: '预约规则',
            items: controller.policies,
            keyPrefix: 'visit-booking-policy',
            color: AppColors.info,
          ),
          const SizedBox(height: 16),
          _VisitAiRiskCard(controller: controller),
          const SizedBox(height: 16),
          _BookingChoiceSection(
            title: '选择日期',
            options: controller.availableDates,
            selectedValue: controller.selectedDate.value,
            keyPrefix: 'visit-booking-date',
            onSelected: controller.selectDate,
          ),
          const SizedBox(height: 14),
          _BookingChoiceSection(
            title: '选择时段',
            options: controller.availablePeriods,
            selectedValue: controller.selectedPeriod.value,
            keyPrefix: 'visit-booking-period',
            onSelected: controller.selectPeriod,
          ),
          const SizedBox(height: 14),
          _BookingChoiceSection(
            title: '探视时长',
            options: controller.durationOptions,
            selectedValue: controller.selectedDuration.value,
            keyPrefix: 'visit-booking-duration',
            onSelected: controller.selectDuration,
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const ValueKey('visit-booking-visitors-input'),
            controller: controller.visitorsController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('到访人数', '最多 3 人'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const ValueKey('visit-booking-companions-input'),
            controller: controller.companionsController,
            decoration: _inputDecoration('随行人员', '使用“、”分隔，例如：陈涛、陈一航'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const ValueKey('visit-booking-note-input'),
            controller: controller.noteController,
            maxLines: 3,
            decoration: _inputDecoration('预约说明', '可补充希望沟通的重点或特殊需求'),
          ),
          const SizedBox(height: 16),
          _VisitChecksCard(controller: controller),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const ValueKey('visit-booking-submit'),
            onPressed: controller.submitBooking,
            icon: const Icon(Icons.event_available_rounded),
            label: Text(controller.hasBlockingChecks ? '先查看限制原因' : '提交并自动审核'),
          ),
          if (decision != null) ...[
            const SizedBox(height: 16),
            _VisitBookingResultCard(decision: decision),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hintText) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: AppColors.cardElevated,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }
}

class _VisitAiRiskCard extends StatelessWidget {
  const _VisitAiRiskCard({required this.controller});

  final VisitController controller;

  @override
  Widget build(BuildContext context) {
    final aiRisk = controller.aiRisk;
    final selectedBlockedSlot = aiRisk.blockedSlots.where(
      (item) =>
          item.date == controller.selectedDate.value &&
          item.period == controller.selectedPeriod.value,
    );

    return Container(
      key: const ValueKey('visit-booking-ai-card'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology_alt_rounded,
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI 身体状态判断',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusBadge(
                label: aiRisk.level,
                tone: selectedBlockedSlot.isNotEmpty
                    ? BadgeTone.danger
                    : BadgeTone.info,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(aiRisk.summary),
          const SizedBox(height: 8),
          Text(
            aiRisk.recommendation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (aiRisk.blockedSlots.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...aiRisk.blockedSlots.map(
              (slot) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• ${slot.date} ${slot.period}：${slot.reason}'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VisitChecksCard extends StatelessWidget {
  const _VisitChecksCard({required this.controller});

  final VisitController controller;

  @override
  Widget build(BuildContext context) {
    final checks = controller.currentChecks;

    return Container(
      key: const ValueKey('visit-booking-checks-card'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('自动审核检查项', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          ...checks.map(
            (check) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    check.isBlocking
                        ? Icons.block_rounded
                        : Icons.check_circle_rounded,
                    size: 18,
                    color: check.isBlocking
                        ? AppColors.danger
                        : AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          check.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          check.detail,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitBookingResultCard extends StatelessWidget {
  const _VisitBookingResultCard({required this.decision});

  final VisitBookingDecision decision;

  @override
  Widget build(BuildContext context) {
    final color = decision.approved ? AppColors.primary : AppColors.danger;

    return Container(
      key: const ValueKey('visit-booking-result-card'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                decision.approved
                    ? Icons.verified_rounded
                    : Icons.error_outline_rounded,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                decision.status,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(decision.summary),
          if (decision.alternativeSuggestion?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              decision.alternativeSuggestion!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class _BookingChoiceSection extends StatelessWidget {
  const _BookingChoiceSection({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.keyPrefix,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final String selectedValue;
  final String keyPrefix;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options
              .map(
                (option) => GestureDetector(
                  key: ValueKey('$keyPrefix-$option'),
                  onTap: () => onSelected(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selectedValue == option
                          ? AppColors.primarySoft
                          : AppColors.cardElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selectedValue == option
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selectedValue == option
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: selectedValue == option
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _BookingTagGroup extends StatelessWidget {
  const _BookingTagGroup({
    required this.title,
    required this.items,
    required this.keyPrefix,
    required this.color,
  });

  final String title;
  final List<String> items;
  final String keyPrefix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ...items.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              key: ValueKey('$keyPrefix-${entry.key}'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.rule_rounded, size: 16, color: color),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(entry.value)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UpcomingVisitCard extends StatelessWidget {
  const _UpcomingVisitCard({required this.appointment});

  final VisitAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      key: const ValueKey('visit-upcoming-card'),
      gradient: const LinearGradient(
        colors: [Color(0xFF162636), Color(0xFF0E1722)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('下一次探视', style: Theme.of(context).textTheme.titleLarge),
              StatusBadge(label: appointment.status, tone: BadgeTone.success),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '${appointment.date} · ${appointment.period}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '时长 ${appointment.duration} · 到访人数 ${appointment.visitors} 人 · ${appointment.approvalMode}',
          ),
          if (appointment.companions.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('随行人员：${appointment.companions.join('、')}'),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Text(appointment.note),
          ),
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
      key: const ValueKey('visit-video-card'),
      accentColor: AppColors.info,
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
          Text('支持探视、了解情况等场景，建议时长控制在 15 分钟以内，优先安排在老人情绪稳定时段。'),
          const SizedBox(height: 12),
          FilledButton.icon(
            key: const ValueKey('visit-open-video-call'),
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
      key: const ValueKey('visit-suggestions-card'),
      backgroundColor: AppColors.primarySoft,
      accentColor: AppColors.primary,
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
            key: const ValueKey('visit-open-ai-assistant'),
            onPressed: () => Get.toNamed(AppRoutes.aiVisitAssistant),
            icon: const Icon(Icons.auto_awesome_outlined),
            label: const Text('打开 AI 探视助手'),
          ),
        ],
      ),
    );
  }
}

class _VisitSectionEmptyState extends StatelessWidget {
  const _VisitSectionEmptyState({
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
                child: const Icon(
                  Icons.event_busy_rounded,
                  color: AppColors.info,
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

class _VisitHistoryCard extends StatelessWidget {
  const _VisitHistoryCard({required this.item});

  final VisitAppointment item;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      key: ValueKey('visit-history-${item.date}'),
      accentColor: AppColors.info,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.cardElevated,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.history_rounded, color: AppColors.info),
          ),
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
