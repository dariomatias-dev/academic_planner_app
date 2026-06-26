import 'package:academic_planner/src/features/activities/presentation/widgets/activity_stats_cards_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ActivityProgressCardWidget', () {
    testWidgets('loading → shows a progress indicator', (tester) async {
      await tester.pumpWidget(
        _harness(
          const ActivityProgressCardWidget(state: AsyncLoading<double>()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('error → shows the error icon', (tester) async {
      await tester.pumpWidget(
        _harness(
          const ActivityProgressCardWidget(
            state: AsyncError<double>('fail', StackTrace.empty),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('data → shows the percentage and the progress bar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const ActivityProgressCardWidget(state: AsyncData<double>(0.42)),
        ),
      );

      expect(find.text('42%'), findsOneWidget);
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, 0.42);
    });
  });

  group('ActivityUrgentCardWidget', () {
    testWidgets('data → shows the count and the "URGENTES" label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const ActivityUrgentCardWidget(state: AsyncData<int>(3))),
      );

      expect(find.text('3'), findsOneWidget);
      expect(find.text('URGENTES'), findsOneWidget);
    });

    testWidgets('loading → shows a progress indicator', (tester) async {
      await tester.pumpWidget(
        _harness(const ActivityUrgentCardWidget(state: AsyncLoading<int>())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('MetricCardWidget', () {
    testWidgets('no state and no value → falls back to "0"', (tester) async {
      await tester.pumpWidget(
        _harness(
          const MetricCardWidget(
            label: 'Total',
            icon: Icons.list,
            color: Colors.blue,
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets('value provided without state → shows the raw value', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const MetricCardWidget(
            label: 'Total',
            icon: Icons.list,
            color: Colors.blue,
            value: '12',
          ),
        ),
      );

      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('state provided → delegates to MetricCardValueWidget', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const MetricCardWidget(
            label: 'Total',
            icon: Icons.list,
            color: Colors.blue,
            state: AsyncData<int>(7),
          ),
        ),
      );

      expect(find.text('7'), findsOneWidget);
    });
  });

  group('MetricCardValueWidget', () {
    testWidgets('loading → shows a progress indicator', (tester) async {
      await tester.pumpWidget(
        _harness(const MetricCardValueWidget(state: AsyncLoading<int>())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('error → shows the error icon', (tester) async {
      await tester.pumpWidget(
        _harness(
          const MetricCardValueWidget(
            state: AsyncError<int>('fail', StackTrace.empty),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('data → shows the count as text', (tester) async {
      await tester.pumpWidget(
        _harness(const MetricCardValueWidget(state: AsyncData<int>(9))),
      );

      expect(find.text('9'), findsOneWidget);
    });
  });
}
