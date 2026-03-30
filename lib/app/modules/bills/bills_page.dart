import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursing_family_app/app/data/models/family_models.dart';
import 'package:nursing_family_app/app/data/services/mock_family_service.dart';
import 'package:nursing_family_app/app/widgets/family_card.dart';
import 'package:nursing_family_app/app/widgets/family_page.dart';
import 'package:nursing_family_app/app/widgets/status_badge.dart';

class BillsController extends GetxController {
  BillsController(this._service);

  final MockFamilyService _service;

  List<BillItem> get bills => _service.bills;
}

class BillsView extends GetView<BillsController> {
  const BillsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FamilyPage(
      title: '账单中心',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FamilyCard(
            backgroundColor: const Color(0xFFF5F0E8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('待处理费用', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '¥ 6,980',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text('支持查看每月账单、支付记录与欠费提醒。'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...controller.bills.map(
            (bill) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FamilyCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            bill.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        StatusBadge(
                          label: bill.status,
                          tone: bill.status == '已支付'
                              ? BadgeTone.success
                              : BadgeTone.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bill.amount,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text('到期日 ${bill.dueDate}'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: bill.status == '待支付'
                          ? () => Get.snackbar('演示模式', '当前为设计预览，支付能力待接真实网关。')
                          : null,
                      child: Text(bill.status == '待支付' ? '去支付' : '已支付'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
