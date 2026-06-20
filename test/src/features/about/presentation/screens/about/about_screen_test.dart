import 'package:academic_planner/src/features/about/presentation/screens/about/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Academic Planner',
      packageName: 'com.example.academic_planner',
      version: '1.2.3',
      buildNumber: '42',
      buildSignature: '',
    );
  });

  testWidgets('renders the main sections of the about screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: AboutScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sobre o App'), findsOneWidget);
    expect(find.text('Academic Planner'), findsOneWidget);
    expect(find.text('FUNCIONALIDADES'), findsOneWidget);
    expect(find.text('ESPECIFICAÇÕES'), findsOneWidget);
    expect(find.text('Código-fonte'), findsOneWidget);
    expect(find.text('Versão Instalada'), findsOneWidget);
    expect(find.text('1.2.3+42'), findsOneWidget);
  });
}
