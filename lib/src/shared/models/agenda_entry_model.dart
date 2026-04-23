import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaEntryModel {
  final String id;
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool isAllDay;

  const AgendaEntryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.isAllDay = false,
  });

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
