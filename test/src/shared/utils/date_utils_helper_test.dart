import 'package:academic_planner/src/shared/utils/date_utils_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('DateUtilsHelper.formatWeekdayDate', () {
    test('first character is uppercase', () {
      final date = DateTime(2024);

      final result = DateUtilsHelper.formatWeekdayDate(date);

      expect(result[0], result[0].toUpperCase());
    });

    test('does not throw for any valid date', () {
      final dates = [
        DateTime(2024, 3, 15),
        DateTime(2024, 12, 31),
        DateTime(2024, 2, 29),
      ];

      for (final date in dates) {
        expect(() => DateUtilsHelper.formatWeekdayDate(date), returnsNormally);
      }
    });

    test('different weekdays produce different strings', () {
      final monday = DateTime(2024);
      final tuesday = DateTime(2024, 1, 2);
      final wednesday = DateTime(2024, 1, 3);
      final thursday = DateTime(2024, 1, 4);
      final friday = DateTime(2024, 1, 5);
      final saturday = DateTime(2024, 1, 6);
      final sunday = DateTime(2024, 1, 7);

      final results = {
        DateUtilsHelper.formatWeekdayDate(monday),
        DateUtilsHelper.formatWeekdayDate(tuesday),
        DateUtilsHelper.formatWeekdayDate(wednesday),
        DateUtilsHelper.formatWeekdayDate(thursday),
        DateUtilsHelper.formatWeekdayDate(friday),
        DateUtilsHelper.formatWeekdayDate(saturday),
        DateUtilsHelper.formatWeekdayDate(sunday),
      };

      expect(results.length, 7);
    });

    test('same date always produces same string', () {
      final date = DateTime(2024, 6, 15);

      final first = DateUtilsHelper.formatWeekdayDate(date);
      final second = DateUtilsHelper.formatWeekdayDate(date);

      expect(first, second);
    });
  });
}
