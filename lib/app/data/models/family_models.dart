class ElderSummary {
  const ElderSummary({
    required this.name,
    required this.age,
    required this.room,
    required this.careLevel,
    required this.admittedAt,
    required this.todayStatus,
    required this.familyRelation,
  });

  final String name;
  final int age;
  final String room;
  final String careLevel;
  final String admittedAt;
  final String todayStatus;
  final String familyRelation;
}

class VitalMetric {
  const VitalMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.status,
    required this.subtitle,
    required this.points,
  });

  final String label;
  final String value;
  final String unit;
  final String status;
  final String subtitle;
  final List<double> points;
}

class CareRecord {
  const CareRecord({
    required this.time,
    required this.title,
    required this.description,
    required this.status,
  });

  final String time;
  final String title;
  final String description;
  final String status;
}

class VisitAppointment {
  const VisitAppointment({
    required this.id,
    required this.date,
    required this.period,
    required this.duration,
    required this.status,
    required this.visitors,
    required this.note,
    this.companions = const [],
    this.approvalMode = '人工审核',
  });

  final String id;
  final String date;
  final String period;
  final String duration;
  final String status;
  final int visitors;
  final String note;
  final List<String> companions;
  final String approvalMode;
}

class VisitBookingDraft {
  const VisitBookingDraft({
    required this.date,
    required this.period,
    required this.duration,
    required this.visitors,
    required this.companions,
    required this.note,
  });

  final String date;
  final String period;
  final String duration;
  final int visitors;
  final List<String> companions;
  final String note;
}

class VisitRuleCheck {
  const VisitRuleCheck({
    required this.title,
    required this.detail,
    required this.isBlocking,
  });

  final String title;
  final String detail;
  final bool isBlocking;
}

class VisitAiBlockedSlot {
  const VisitAiBlockedSlot({
    required this.date,
    required this.period,
    required this.reason,
  });

  final String date;
  final String period;
  final String reason;
}

class VisitAiRiskAnalysis {
  const VisitAiRiskAnalysis({
    required this.level,
    required this.summary,
    required this.recommendation,
    this.blockedSlots = const [],
  });

  final String level;
  final String summary;
  final String recommendation;
  final List<VisitAiBlockedSlot> blockedSlots;
}

class VisitBookingDecision {
  const VisitBookingDecision({
    required this.approved,
    required this.status,
    required this.summary,
    required this.checks,
    this.alternativeSuggestion,
    this.appointment,
  });

  final bool approved;
  final String status;
  final String summary;
  final List<VisitRuleCheck> checks;
  final String? alternativeSuggestion;
  final VisitAppointment? appointment;
}

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.category,
  });

  final String title;
  final String body;
  final String time;
  final String category;
}

class BillItem {
  const BillItem({
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  final String title;
  final String amount;
  final String dueDate;
  final String status;
}

class AlertEvent {
  const AlertEvent({
    required this.title,
    required this.level,
    required this.time,
    required this.description,
  });

  final String title;
  final String level;
  final String time;
  final String description;
}

class AiPromptItem {
  const AiPromptItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
