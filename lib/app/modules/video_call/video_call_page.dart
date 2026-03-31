import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/theme/app_theme.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';
import 'package:nursing_family_app/app/widgets/hero_panel.dart';
import 'package:nursing_family_app/app/widgets/responsive_metric_group.dart';
import 'package:nursing_family_app/app/widgets/section_header.dart';

class VideoCallController extends GetxController {
  VideoCallController(this._service);

  final MockFamilyService _service;
  final selectedReason = '探视'.obs;
  final reasons = const ['探视', '了解情况', '其他'];

  String get elderName => _service.currentElder.name;

  void selectReason(String value) {
    selectedReason.value = value;
  }
}

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return FamilyPage(
      title: '远程视频',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF122A45), Color(0xFF101724)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              accentColor: AppColors.info,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroPanelHeader(
                    icon: Icons.videocam_rounded,
                    color: AppColors.info,
                    title: '远程视频链路',
                    subtitle: '发起与 ${controller.elderName} 的视频沟通，护理站会协助完成接通。',
                  ),
                  const SizedBox(height: 18),
                  const ResponsiveMetricGroup(
                    children: [
                      _VideoMetric(
                        label: '建议时长',
                        value: '15 分钟',
                        color: AppColors.info,
                      ),
                      _VideoMetric(
                        label: '当前状态',
                        value: '待发起',
                        color: AppColors.primary,
                      ),
                      _VideoMetric(
                        label: '接通方式',
                        value: '护理站协助',
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: '通话目的',
              subtitle: '先确认本次沟通目的，让护理站提前准备对应场景',
            ),
            const SizedBox(height: 14),
            FamilyCard(
              accentColor: AppColors.info,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.reasons
                          .map(
                            (reason) => _ReasonChip(
                              key: ValueKey('video-call-reason-$reason'),
                              label: reason,
                              selected:
                                  controller.selectedReason.value == reason,
                              onTap: () => controller.selectReason(reason),
                            ),
                          )
                          .toList(),
                    ),
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
                      children: const [
                        _CallStep(
                          index: '01',
                          label: '发起申请',
                          description: '家属端提交视频沟通请求',
                        ),
                        SizedBox(height: 12),
                        _CallStep(
                          index: '02',
                          label: '护理站确认',
                          description: '护理站协助老人到位并确认设备',
                        ),
                        SizedBox(height: 12),
                        _CallStep(
                          index: '03',
                          label: '建立连接',
                          description: '接通后进入单次 15 分钟沟通时段',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    key: const ValueKey('video-call-submit'),
                    onPressed: () =>
                        Get.snackbar('呼叫已发起', '护理站已收到视频沟通请求，请稍候接通。'),
                    icon: const Icon(Icons.videocam_rounded),
                    label: const Text('发起视频呼叫'),
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

class _VideoMetric extends StatelessWidget {
  const _VideoMetric({
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

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({
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

class _CallStep extends StatelessWidget {
  const _CallStep({
    required this.index,
    required this.label,
    required this.description,
  });

  final String index;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            index,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }
}
