import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

enum AgendaEntryType { activity, holiday, exam, event }

class AgendaEntryModel {
  final String id;
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool isAllDay;
  final AgendaEntryType type;

  const AgendaEntryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.type,
    this.isAllDay = false,
  });

  String get typeLabel {
    return switch (type) {
      AgendaEntryType.activity => "Atividade",
      AgendaEntryType.holiday => "Feriado",
      AgendaEntryType.exam => "Avaliação",
      AgendaEntryType.event => "Evento",
    };
  }

  IconData get icon {
    return switch (type) {
      AgendaEntryType.activity => Icons.auto_stories_rounded,
      AgendaEntryType.holiday => Icons.flag_rounded,
      AgendaEntryType.exam => Icons.assignment_late_rounded,
      AgendaEntryType.event => Icons.stars_rounded,
    };
  }

  Appointment toAppointment() {
    return Appointment(
      id: id,
      startTime: startTime,
      endTime: endTime,
      subject: title,
      notes: subtitle,
      color: color,
      isAllDay: isAllDay,
    );
  }
}
