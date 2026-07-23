import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatWeekdayDate(DateTime date) {
    final raw = DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(date);

    return raw[0].toUpperCase() + raw.substring(1);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat("dd 'de' MMMM, yyyy", 'pt_BR').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy', 'pt_BR').format(date).toUpperCase();
  }

  static String formatSlashDate(DateTime date) {
    return DateFormat('dd / MM / yyyy').format(date);
  }
}
