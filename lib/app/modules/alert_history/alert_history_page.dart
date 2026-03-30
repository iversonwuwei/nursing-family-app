import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';
import 'package:nursing_family_app/app/widgets/status_badge.dart';

class AlertHistoryController extends GetxController {
  AlertHistoryController(this._service);

  final MockFamilyService _service;

  List<AlertEvent> get alerts => _service.alerts;
}

class AlertHistoryView extends GetView<AlertHistoryController> {
  const AlertHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return FamilyPage(
      title: '报警历史',
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: controller.alerts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final alert = controller.alerts[index];
          return FamilyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    StatusBadge(
                      label: alert.level,
                      tone: alert.level == 'P2'
                          ? BadgeTone.warning
                          : BadgeTone.info,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(alert.description),
                const SizedBox(height: 8),
                Text(alert.time),
              ],
            ),
          );
        },
      ),
    );
  }
}
