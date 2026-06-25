import 'package:academic_planner/src/shared/utils/image_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _toastChannel = MethodChannel('PonnamKarthik/fluttertoast');
const _gallerySaverChannel = MethodChannel('image_gallery_saver_plus');

Widget _harness({
  required GlobalKey containerKey,
  required Future<void> Function(BuildContext context) onPressed,
  bool attachBoundary = true,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
          if (attachBoundary)
            RepaintBoundary(
              key: containerKey,
              child: const SizedBox(
                width: 10.0,
                height: 10.0,
                child: ColoredBox(color: Colors.red),
              ),
            ),
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => onPressed(context),
                child: const Text('trigger'),
              );
            },
          ),
        ],
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final toastCalls = <MethodCall>[];

  setUp(() {
    toastCalls.clear();

    messenger
      ..setMockMethodCallHandler(_toastChannel, (call) async {
        toastCalls.add(call);
        return true;
      })
      ..setMockMethodCallHandler(_gallerySaverChannel, (call) async {
        return {'isSuccess': true, 'filePath': '/fake/export.png'};
      });
  });

  tearDown(() {
    messenger
      ..setMockMethodCallHandler(_toastChannel, null)
      ..setMockMethodCallHandler(_gallerySaverChannel, null);
  });

  group('ImageExport.captureAndSave', () {
    testWidgets(
      'boundary not found → shows the loading toast then the error dialog',
      (tester) async {
        final containerKey = GlobalKey();

        await tester.pumpWidget(
          _harness(
            containerKey: containerKey,
            attachBoundary: false,
            onPressed: (context) => ImageExport.captureAndSave(
              context: context,
              containerKey: containerKey,
              fileName: 'export',
            ),
          ),
        );

        await tester.tap(find.text('trigger'));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));

        expect(
          toastCalls.any(
            (call) => (call.arguments as Map)['msg'] == 'Gerando arquivo...',
          ),
          isTrue,
        );
        expect(find.text('Erro na exportação'), findsOneWidget);
        expect(
          find.text('Não foi possível salvar a imagem. Tente novamente.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'capture and save succeed → shows the success toast, no error dialog',
      (tester) async {
        final containerKey = GlobalKey();

        await tester.pumpWidget(
          _harness(
            containerKey: containerKey,
            onPressed: (context) => ImageExport.captureAndSave(
              context: context,
              containerKey: containerKey,
              fileName: 'export',
            ),
          ),
        );

        await tester.runAsync(() async {
          await tester.tap(find.text('trigger'));
          await tester.pump();
          await Future<void>.delayed(const Duration(milliseconds: 300));
          await tester.pumpAndSettle();
        });

        expect(
          toastCalls.any(
            (call) =>
                (call.arguments as Map)['msg'] == 'Imagem salva com sucesso!',
          ),
          isTrue,
        );
        expect(find.text('Erro na exportação'), findsNothing);
      },
    );

    testWidgets('gallery save fails → shows the error dialog', (
      tester,
    ) async {
      final containerKey = GlobalKey();

      messenger.setMockMethodCallHandler(_gallerySaverChannel, (call) async {
        return {'isSuccess': false};
      });

      await tester.pumpWidget(
        _harness(
          containerKey: containerKey,
          onPressed: (context) => ImageExport.captureAndSave(
            context: context,
            containerKey: containerKey,
            fileName: 'export',
          ),
        ),
      );

      await tester.runAsync(() async {
        await tester.tap(find.text('trigger'));
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();
      });

      expect(find.text('Erro na exportação'), findsOneWidget);
    });

    testWidgets('error dialog can be dismissed', (tester) async {
      final containerKey = GlobalKey();

      await tester.pumpWidget(
        _harness(
          containerKey: containerKey,
          attachBoundary: false,
          onPressed: (context) => ImageExport.captureAndSave(
            context: context,
            containerKey: containerKey,
            fileName: 'export',
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Erro na exportação'), findsNothing);
    });
  });
}
