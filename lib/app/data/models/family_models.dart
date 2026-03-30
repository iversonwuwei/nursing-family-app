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
    required this.date,
    required this.period,
    required this.duration,
    required this.status,
    required this.visitors,
    required this.note,
  });

  final String date;
  final String period;
  final String duration;
  final String status;
  final int visitors;
  final String note;
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
