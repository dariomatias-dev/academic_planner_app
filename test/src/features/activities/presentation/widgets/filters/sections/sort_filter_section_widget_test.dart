import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_field.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/sort_filter_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('SortFilterSectionWidget', () {
    testWidgets('renders the order toggles', (tester) async {
      await tester.pumpWidget(
        _harness(
          SortFilterSectionWidget(
            sortField: null,
            sortOrder: null,
            onFieldChanged: (_) {},
            onOrderChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Crescente'), findsOneWidget);
      expect(find.text('Decrescente'), findsOneWidget);
    });

    testWidgets('no sortField selected → order toggles are disabled', (
      tester,
    ) async {
      var orderChangedCalls = 0;

      await tester.pumpWidget(
        _harness(
          SortFilterSectionWidget(
            sortField: null,
            sortOrder: null,
            onFieldChanged: (_) {},
            onOrderChanged: (_) => orderChangedCalls++,
          ),
        ),
      );

      await tester.tap(find.text('Crescente'), warnIfMissed: false);

      expect(orderChangedCalls, 0);
    });

    testWidgets('sortField selected → tapping an order toggle calls '
        'onOrderChanged', (tester) async {
      ActivitySortOrder? selectedOrder;

      await tester.pumpWidget(
        _harness(
          SortFilterSectionWidget(
            sortField: ActivitySortField.title,
            sortOrder: ActivitySortOrder.asc,
            onFieldChanged: (_) {},
            onOrderChanged: (value) => selectedOrder = value,
          ),
        ),
      );

      await tester.tap(find.text('Decrescente'));

      expect(selectedOrder, ActivitySortOrder.desc);
    });

    testWidgets('selecting a sort field in the dropdown calls '
        'onFieldChanged', (tester) async {
      ActivitySortField? selectedField;

      await tester.pumpWidget(
        _harness(
          SortFilterSectionWidget(
            sortField: null,
            sortOrder: null,
            onFieldChanged: (value) => selectedField = value,
            onOrderChanged: (_) {},
          ),
        ),
      );

      await tester.tap(
        find.byType(DropdownButtonFormField<ActivitySortField>),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Título').last);
      await tester.pumpAndSettle();

      expect(selectedField, ActivitySortField.title);
    });
  });
}
