import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/fields/activity_form_tag_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityFormTagSelectorWidget', () {
    testWidgets('renders every available tag', (tester) async {
      await tester.pumpWidget(
        _harness(
          ActivityFormTagSelectorWidget(
            availableTags: const ['urgente', 'prova'],
            selectedTags: const [],
            onToggle: (_, {value = false}) {},
            onCreate: () {},
          ),
        ),
      );

      expect(find.text('urgente'), findsOneWidget);
      expect(find.text('prova'), findsOneWidget);
    });

    testWidgets('tapping an unselected tag toggles it on', (tester) async {
      String? toggledTag;
      bool? toggledValue;

      await tester.pumpWidget(
        _harness(
          ActivityFormTagSelectorWidget(
            availableTags: const ['urgente'],
            selectedTags: const [],
            onToggle: (tag, {value = false}) {
              toggledTag = tag;
              toggledValue = value;
            },
            onCreate: () {},
          ),
        ),
      );

      await tester.tap(find.text('urgente'));

      expect(toggledTag, 'urgente');
      expect(toggledValue, isTrue);
    });

    testWidgets('tapping a selected tag toggles it off', (tester) async {
      bool? toggledValue;

      await tester.pumpWidget(
        _harness(
          ActivityFormTagSelectorWidget(
            availableTags: const ['urgente'],
            selectedTags: const ['urgente'],
            onToggle: (tag, {value = false}) => toggledValue = value,
            onCreate: () {},
          ),
        ),
      );

      await tester.tap(find.text('urgente'));

      expect(toggledValue, isFalse);
    });

    testWidgets('tapping "+ Nova Tag" calls onCreate', (tester) async {
      var createCalls = 0;

      await tester.pumpWidget(
        _harness(
          ActivityFormTagSelectorWidget(
            availableTags: const [],
            selectedTags: const [],
            onToggle: (_, {value = false}) {},
            onCreate: () => createCalls++,
          ),
        ),
      );

      await tester.tap(find.text('+ Nova Tag'));

      expect(createCalls, 1);
    });
  });
}
