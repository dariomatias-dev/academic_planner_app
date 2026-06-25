import 'package:academic_planner/src/shared/widgets/form_error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('FormErrorMessageWidget', () {
    testWidgets('hasError true → renders the error text', (tester) async {
      await tester.pumpWidget(
        _harness(
          const FormErrorMessageWidget(
            hasError: true,
            errorText: 'Campo obrigatório',
          ),
        ),
      );

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('hasError true → expands height, slides in and fades in', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const FormErrorMessageWidget(
            hasError: true,
            errorText: 'Campo obrigatório',
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 26.0);

      final slide = tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));
      expect(slide.offset, Offset.zero);

      final opacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(opacity.opacity, 1.0);
    });

    testWidgets(
      'hasError false → collapses height, slides up and fades out',
      (tester) async {
        await tester.pumpWidget(
          _harness(const FormErrorMessageWidget(hasError: false)),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, 0.0);

        final slide = tester.widget<AnimatedSlide>(
          find.byType(AnimatedSlide),
        );
        expect(slide.offset, const Offset(0, -0.3));

        final opacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );
        expect(opacity.opacity, 0.0);
      },
    );

    testWidgets('errorText omitted → renders an empty message', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const FormErrorMessageWidget(hasError: true)),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.data, '');
    });
  });
}
