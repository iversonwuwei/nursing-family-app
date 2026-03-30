import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';

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
              backgroundColor: const Color(0xFFEAF0FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '发起与 ${controller.elderName} 的视频沟通',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('护理站收到通知后会协助接通，单次通话建议不超过 15 分钟。'),
                  const SizedBox(height: 12),
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      children: controller.reasons
                          .map(
                            (reason) => ChoiceChip(
                              label: Text(reason),
                              selected:
                                  controller.selectedReason.value == reason,
                              onSelected: (_) =>
                                  controller.selectReason(reason),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
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
