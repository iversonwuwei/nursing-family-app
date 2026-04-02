import 'package:nursing_family_app/app/data/models/family_models.dart';

class MockFamilyService {
  final ElderSummary currentElder = const ElderSummary(
    name: '张丽华',
    age: 78,
    room: '3号楼 201',
    careLevel: '半自理',
    admittedAt: '2024-03-15',
    todayStatus: '整体平稳，午后康复训练前需要补水提醒。',
    familyRelation: '女儿 Wei',
  );

  final List<VitalMetric> vitalMetrics = const [
    VitalMetric(
      label: '血压',
      value: '132/82',
      unit: 'mmHg',
      status: '正常',
      subtitle: '与近 7 日均值接近',
      points: [126, 128, 129, 130, 131, 132, 132],
    ),
    VitalMetric(
      label: '心率',
      value: '72',
      unit: 'bpm',
      status: '正常',
      subtitle: '夜间波动小',
      points: [68, 70, 71, 70, 72, 73, 72],
    ),
    VitalMetric(
      label: '睡眠',
      value: '6.5',
      unit: '小时',
      status: '关注',
      subtitle: '深睡时长略低于上周',
      points: [7.4, 7.1, 6.8, 6.9, 6.7, 6.4, 6.5],
    ),
    VitalMetric(
      label: '步数',
      value: '3250',
      unit: '步',
      status: '正常',
      subtitle: '康复训练日活动量稳定',
      points: [2800, 3100, 3000, 2900, 3300, 3400, 3250],
    ),
  ];

  final List<CareRecord> todayCareRecords = const [
    CareRecord(
      time: '08:00',
      title: '晨间巡检',
      description: '完成晨检、血压测量与精神状态确认。',
      status: '已完成',
    ),
    CareRecord(
      time: '09:00',
      title: '服药提醒',
      description: '按医嘱完成降压药和营养补充剂服用。',
      status: '已完成',
    ),
    CareRecord(
      time: '14:00',
      title: '康复训练',
      description: '步态训练 30 分钟，训练前建议补水。',
      status: '即将开始',
    ),
    CareRecord(
      time: '18:30',
      title: '晚间睡前巡视',
      description: '关注夜间离床与睡眠质量变化。',
      status: '待执行',
    ),
  ];

  VisitAppointment _upcomingVisit = const VisitAppointment(
    id: 'visit-upcoming-1',
    date: '2026-04-04',
    period: '下午 14:00 - 15:00',
    duration: '60 分钟',
    status: '审核通过',
    visitors: 2,
    note: '建议带一件薄外套，活动区空调较足。',
    companions: ['女婿 陈涛'],
    approvalMode: '人工审核',
  );

  final List<VisitAppointment> _visitHistory = [
    VisitAppointment(
      id: 'visit-history-1',
      date: '2026-03-26',
      period: '上午 10:00 - 10:30',
      duration: '30 分钟',
      status: '已完成',
      visitors: 1,
      note: '视频探视，情绪稳定。',
      approvalMode: '视频沟通',
    ),
    VisitAppointment(
      id: 'visit-history-2',
      date: '2026-03-21',
      period: '下午 15:00 - 16:00',
      duration: '60 分钟',
      status: '已完成',
      visitors: 3,
      note: '线下探视，已登记到访。',
      companions: ['女婿 陈涛', '外孙 陈一航'],
      approvalMode: '人工审核',
    ),
  ];

  final List<String> availableVisitDates = const [
    '2026-04-03',
    '2026-04-04',
    '2026-04-05',
    '2026-04-06',
  ];

  final List<String> availableVisitPeriods = const [
    '上午 09:30 - 10:30',
    '下午 14:00 - 15:00',
    '晚上 18:30 - 19:30',
  ];

  final List<String> availableVisitDurations = const [
    '30 分钟',
    '60 分钟',
    '90 分钟',
  ];

  final List<String> visitPolicies = const [
    '仅开放未来 7 天内的探视时段。',
    '同一天仅保留 1 个线下探视预约，避免重复占用接待资源。',
    '同一预约最多 3 人到访，超出后需线下沟通协调。',
    '若 AI 判断老人当前身体不适或护理冲突，该时段不自动通过。',
  ];

  final VisitAiRiskAnalysis visitAiRiskAnalysis = const VisitAiRiskAnalysis(
    level: '需避开部分时段',
    summary: 'AI 结合昨夜睡眠恢复和明晨护理观察，判断 4月3日上午不适合线下探视。',
    recommendation: '优先选择下午 14:00 - 15:00；若老人午后疲劳，可先改为视频沟通。',
    blockedSlots: [
      VisitAiBlockedSlot(
        date: '2026-04-03',
        period: '上午 09:30 - 10:30',
        reason: '老人晨起睡眠恢复不足且上午需完成护理观察，AI 不建议线下探视。',
      ),
    ],
  );

  final List<NotificationItem> notifications = const [
    NotificationItem(
      title: '护理完成提醒',
      body: '今日晨检与服药提醒已完成，状态正常。',
      time: '09:12',
      category: '护理',
    ),
    NotificationItem(
      title: '睡眠关注提醒',
      body: '昨夜深睡时长略低，建议关注今晚睡前状态。',
      time: '08:40',
      category: '健康',
    ),
    NotificationItem(
      title: '探视预约通过',
      body: '4月1日下午探视已审核通过，请准时到达。',
      time: '昨天',
      category: '探视',
    ),
    NotificationItem(
      title: '账单待确认',
      body: '三月护理账单已生成，可进入账单中心查看。',
      time: '昨天',
      category: '账单',
    ),
  ];

  final List<BillItem> bills = const [
    BillItem(
      title: '2026 年 3 月护理账单',
      amount: '¥ 6,980',
      dueDate: '2026-04-05',
      status: '待支付',
    ),
    BillItem(
      title: '2026 年 2 月护理账单',
      amount: '¥ 6,760',
      dueDate: '2026-03-05',
      status: '已支付',
    ),
  ];

  final List<AlertEvent> alerts = const [
    AlertEvent(
      title: '夜间离床提醒',
      level: 'P2',
      time: '2026-03-29 22:14',
      description: '离床传感器检测到 8 分钟离床，护理员已复位并陪同。',
    ),
    AlertEvent(
      title: '午间血压波动',
      level: 'P3',
      time: '2026-03-28 13:20',
      description: '血压短时升高，休息后恢复稳定。',
    ),
  ];

  final List<AiPromptItem> todayAiPrompts = const [
    AiPromptItem(
      question: '妈妈今天状态怎么样？',
      answer: '今天整体状态平稳，晨检和服药已完成，下午有一次康复训练安排。睡眠略低于近一周平均值，建议晚间通话时提醒早点休息。',
    ),
    AiPromptItem(
      question: '今天血压有没有异常？',
      answer: '今天血压 132/82 mmHg，在当前护理目标范围内，没有出现持续异常波动。',
    ),
    AiPromptItem(
      question: '我明天什么时候探视更合适？',
      answer: '建议选择下午 14:00 左右，避开晨检和午休，老人精神状态通常更好，也方便安排视频或线下探视。',
    ),
  ];

  final List<String> _visitSuggestions = const [
    '优先选择康复训练结束后 30 分钟进行视频或线下沟通。',
    '若希望查看精神状态，建议在下午 14:30 至 16:00 之间发起视频。',
    '探视前可先在 AI 助手页查看今日护理摘要，减少重复询问。',
  ];

  VisitAppointment get upcomingVisit => _upcomingVisit;

  List<VisitAppointment> get visitHistory => List.unmodifiable(_visitHistory);

  List<String> get visitSuggestions => List.unmodifiable(_visitSuggestions);

  List<VisitRuleCheck> evaluateVisitRequest(VisitBookingDraft draft) {
    final checks = <VisitRuleCheck>[
      const VisitRuleCheck(
        title: '预约窗口',
        detail: '当前选择的日期在开放预约窗口内。',
        isBlocking: false,
      ),
    ];

    final activeAppointments = [
      _upcomingVisit,
    ].where((item) => item.status != '已完成' && item.status != '已取消').toList();

    final hasSameSlot = activeAppointments.any(
      (item) => item.date == draft.date && item.period == draft.period,
    );
    if (hasSameSlot) {
      checks.add(
        const VisitRuleCheck(
          title: '重复预约',
          detail: '该时段已经存在预约，请不要重复提交相同时段。',
          isBlocking: true,
        ),
      );
    }

    final hasSameDayAppointment = activeAppointments.any(
      (item) => item.date == draft.date,
    );
    if (!hasSameSlot && hasSameDayAppointment) {
      checks.add(
        const VisitRuleCheck(
          title: '同日预约限制',
          detail: '同一天仅保留 1 个线下探视预约，请改选其他日期。',
          isBlocking: true,
        ),
      );
    }

    if (draft.visitors > 3) {
      checks.add(
        const VisitRuleCheck(
          title: '到访人数限制',
          detail: '当前机构单次线下探视最多支持 3 人到访。',
          isBlocking: true,
        ),
      );
    } else {
      checks.add(
        VisitRuleCheck(
          title: '到访人数限制',
          detail: '当前到访人数 ${draft.visitors} 人，符合最多 3 人的限制。',
          isBlocking: false,
        ),
      );
    }

    final blockedSlot = visitAiRiskAnalysis.blockedSlots
        .where((item) => item.date == draft.date && item.period == draft.period)
        .cast<VisitAiBlockedSlot?>()
        .firstWhere((item) => item != null, orElse: () => null);
    if (blockedSlot != null) {
      checks.add(
        VisitRuleCheck(
          title: 'AI 身体状态拦截',
          detail: blockedSlot.reason,
          isBlocking: true,
        ),
      );
    } else {
      checks.add(
        const VisitRuleCheck(
          title: 'AI 身体状态判断',
          detail: '当前时段未命中老人身体不适或护理冲突拦截，可继续申请。',
          isBlocking: false,
        ),
      );
    }

    return checks;
  }

  VisitBookingDecision submitVisitRequest(VisitBookingDraft draft) {
    final checks = evaluateVisitRequest(draft);
    final blockingChecks = checks.where((item) => item.isBlocking).toList();

    if (blockingChecks.isNotEmpty) {
      return VisitBookingDecision(
        approved: false,
        status: '未通过',
        summary: '本次预约未自动通过，请先处理重复预约或老人状态拦截问题。',
        checks: checks,
        alternativeSuggestion: visitAiRiskAnalysis.recommendation,
      );
    }

    final appointment = VisitAppointment(
      id: 'visit-upcoming-${DateTime.now().millisecondsSinceEpoch}',
      date: draft.date,
      period: draft.period,
      duration: draft.duration,
      status: '已自动通过',
      visitors: draft.visitors,
      note: draft.note.trim().isEmpty
          ? '系统已根据当前规则自动通过本次预约。'
          : draft.note.trim(),
      companions: draft.companions,
      approvalMode: '自动通过',
    );

    _upcomingVisit = appointment;

    return VisitBookingDecision(
      approved: true,
      status: '已通过',
      summary: '未命中重复预约、人数超限或 AI 身体状态拦截规则，预约已自动通过。',
      checks: checks,
      appointment: appointment,
    );
  }

  String get todayAiSummary =>
      'AI 判断今天的重点不是急性风险，而是睡眠恢复和下午训练前的补水提醒。家属如果晚间沟通，可优先关心休息和训练感受。';
}
