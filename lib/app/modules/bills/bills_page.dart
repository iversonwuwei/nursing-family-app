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
import 'package:nursing_family_app/app/widgets/status_badge.dart';

class BillsController extends GetxController {
  BillsController(this._service);

  final MockFamilyService _service;

  final RxString selectedStatus = '全部'.obs;

  List<BillItem> get bills {
    final sortedBills = [..._service.bills];
    sortedBills.sort(_compareBills);
    return sortedBills;
  }

  List<String> get statuses => [
    '全部',
    ...bills.map((bill) => bill.status).toSet(),
  ];

  List<BillItem> get visibleBills {
    if (selectedStatus.value == '全部') {
      return bills;
    }

    return bills.where((bill) => bill.status == selectedStatus.value).toList();
  }

  List<BillItem> get pendingBills =>
      bills.where((bill) => bill.status == '待支付').toList();

  List<BillItem> get paidBills =>
      bills.where((bill) => bill.status == '已支付').toList();

  double get totalPending => pendingBills.fold<double>(
    0,
    (sum, bill) => sum + parseAmount(bill.amount),
  );

  String get latestPendingDueDate =>
      pendingBills.isEmpty ? '无' : pendingBills.first.dueDate;

  void selectStatus(String status) {
    selectedStatus.value = status;
  }

  bool isSelectedStatus(String status) => selectedStatus.value == status;

  double parseAmount(String amount) {
    final value = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(value) ?? 0;
  }

  int _compareBills(BillItem left, BillItem right) {
    final leftRank = left.status == '待支付' ? 0 : 1;
    final rightRank = right.status == '待支付' ? 0 : 1;
    if (leftRank != rightRank) {
      return leftRank - rightRank;
    }

    final leftDate = DateTime.tryParse(left.dueDate);
    final rightDate = DateTime.tryParse(right.dueDate);
    if (leftDate == null || rightDate == null) {
      return 0;
    }

    return leftDate.compareTo(rightDate);
  }
}

class BillsView extends GetView<BillsController> {
  const BillsView({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = controller.statuses;

    return FamilyPage(
      title: '账单中心',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF312211), Color(0xFF111B27)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              accentColor: AppColors.warning,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeroPanelHeader(
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppColors.warning,
                    title: '费用驾驶舱',
                    subtitle: '账单、支付进度与到期风险统一集中在一条资金轨道上',
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '¥ ${controller.totalPending.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.pendingBills.isEmpty
                        ? '当前没有待支付账单。'
                        : '当前共有 ${controller.pendingBills.length} 笔费用待处理。',
                  ),
                  const SizedBox(height: 16),
                  ResponsiveMetricGroup(
                    children: [
                      _BillMetric(
                        label: '待支付',
                        value: '${controller.pendingBills.length}',
                      ),
                      _BillMetric(
                        label: '已完成',
                        value: '${controller.paidBills.length}',
                      ),
                      _BillMetric(
                        label: '最近到期',
                        value: controller.latestPendingDueDate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: statuses
                          .map(
                            (status) => _BillFilterChip(
                              key: ValueKey('bills-filter-$status'),
                              label: status,
                              selected: controller.isSelectedStatus(status),
                              onTap: () => controller.selectStatus(status),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(
              title: '账单轨迹',
              subtitle: '按状态筛选账单流，优先暴露待处理金额、到期动作和空态兜底',
            ),
            const SizedBox(height: 14),
            Obx(() {
              final visibleBills = controller.visibleBills;
              if (visibleBills.isEmpty) {
                return _BillsEmptyState(
                  selectedStatus: controller.selectedStatus.value,
                  onReset: () => controller.selectStatus('全部'),
                );
              }

              return Column(
                children: visibleBills
                    .map(
                      (bill) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _BillTile(bill: bill),
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _BillMetric extends StatelessWidget {
  const _BillMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return HeroMetricTile(label: label, value: value);
  }
}

class _BillFilterChip extends StatelessWidget {
  const _BillFilterChip({
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
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.warning.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.warning.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? AppColors.warning : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _BillsEmptyState extends StatelessWidget {
  const _BillsEmptyState({required this.selectedStatus, required this.onReset});

  final String selectedStatus;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      key: const ValueKey('bills-empty-state'),
      accentColor: AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前没有账单记录',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selectedStatus == '全部'
                          ? '新账单同步后会显示在这里，当前页面保持只读摘要模式。'
                          : '“$selectedStatus” 状态下暂时没有账单，可以切回全部查看。',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton.tonalIcon(
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('查看全部账单'),
          ),
        ],
      ),
    );
  }
}

class _BillTile extends StatelessWidget {
  const _BillTile({required this.bill});

  final BillItem bill;

  @override
  Widget build(BuildContext context) {
    return FamilyCard(
      key: ValueKey('bills-tile-${bill.title}'),
      accentColor: bill.status == '已支付' ? AppColors.primary : AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bill.amount,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              StatusBadge(
                label: bill.status,
                tone: bill.status == '已支付'
                    ? BadgeTone.success
                    : BadgeTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text('到期日 ${bill.dueDate}'),
                const Spacer(),
                Text(
                  bill.status == '待支付' ? '等待确认' : '已入账',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bill.status == '待支付'
                        ? AppColors.warning
                        : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: bill.status == '待支付'
                      ? () => Get.snackbar('演示模式', '当前为设计预览，支付能力待接真实网关。')
                      : null,
                  child: Text(bill.status == '待支付' ? '去支付' : '已支付'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      Get.snackbar('账单详情', '${bill.title} 的明细将接入真实结算接口。'),
                  child: const Text('查看明细'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
