import 'package:academic_planner/src/core/seeds/seed.dart';
import 'package:academic_planner/src/core/seeds/seed_runner.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSeed implements Seed {
  _FakeSeed(this.name, {this.onRun});

  @override
  final String name;

  final Future<void> Function()? onRun;

  int runCalls = 0;

  @override
  Future<void> run() async {
    runCalls++;

    await onRun?.call();
  }
}

void main() {
  group('SeedRunner', () {
    test('runs every seed once, in order', () async {
      final order = <String>[];
      final first = _FakeSeed('first', onRun: () async => order.add('first'));
      final second = _FakeSeed(
        'second',
        onRun: () async => order.add('second'),
      );

      await SeedRunner(seeds: [first, second]).run();

      expect(order, ['first', 'second']);
      expect(first.runCalls, 1);
      expect(second.runCalls, 1);
    });

    test('rethrows and stops running the remaining seeds on failure', () async {
      final failing = _FakeSeed(
        'failing',
        onRun: () async => throw Exception('seed boom'),
      );
      final after = _FakeSeed('after');

      await expectLater(
        () => SeedRunner(seeds: [failing, after]).run(),
        throwsException,
      );

      expect(after.runCalls, 0);
    });
  });
}
