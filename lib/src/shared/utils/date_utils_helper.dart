import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatWeekdayDate(DateTime date) {
    final raw = DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(date);

    return raw[0].toUpperCase() + raw.substring(1);
  }
}
