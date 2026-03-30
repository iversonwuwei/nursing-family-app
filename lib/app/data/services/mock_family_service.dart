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

  final VisitAppointment upcomingVisit = const VisitAppointment(
    date: '2026-04-01',
    period: '下午 14:00 - 15:00',
    duration: '60 分钟',
    status: '审核通过',
    visitors: 2,
    note: '建议带一件薄外套，活动区空调较足。',
  );

  final List<VisitAppointment> visitHistory = const [
    VisitAppointment(
      date: '2026-03-26',
      period: '上午 10:00 - 10:30',
      duration: '30 分钟',
      status: '已完成',
      visitors: 1,
      note: '视频探视，情绪稳定。',
    ),
    VisitAppointment(
      date: '2026-03-21',
      period: '下午 15:00 - 16:00',
      duration: '60 分钟',
      status: '已完成',
      visitors: 3,
      note: '线下探视，已登记到访。',
    ),
  ];

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

  final List<String> visitSuggestions = const [
    '优先选择康复训练结束后 30 分钟进行视频或线下沟通。',
    '若希望查看精神状态，建议在下午 14:30 至 16:00 之间发起视频。',
    '探视前可先在 AI 助手页查看今日护理摘要，减少重复询问。',
  ];

  String get todayAiSummary =>
      'AI 判断今天的重点不是急性风险，而是睡眠恢复和下午训练前的补水提醒。家属如果晚间沟通，可优先关心休息和训练感受。';
}
