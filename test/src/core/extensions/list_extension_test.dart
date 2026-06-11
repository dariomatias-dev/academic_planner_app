import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListExtension.builder', () {
    test('transforms each element with correct index', () {
      final result = [10, 20, 30].builder((e, i) => '$i:$e');
      expect(result, ['0:10', '1:20', '2:30']);
    });

    test('empty list → empty result', () {
      expect(<int>[].builder((e, i) => e * 2), isEmpty);
    });

    test('single element → index 0', () {
      expect([42].builder((e, i) => e + i), [42]);
    });

    test('preserves order', () {
      final result = ['c', 'b', 'a'].builder((e, i) => e);
      expect(result, ['c', 'b', 'a']);
    });
  });

  group('ListExtension.filter', () {
    test('keeps elements matching predicate', () {
      final result = [1, 2, 3, 4, 5].filter((e) => e.isEven);
      expect(result, [2, 4]);
    });

    test('no match → empty list', () {
      expect([1, 3, 5].filter((e) => e.isEven), isEmpty);
    });

    test('all match → all elements returned', () {
      expect([2, 4, 6].filter((e) => e.isEven), [2, 4, 6]);
    });

    test('empty list → empty result', () {
      expect(<int>[].filter((e) => e > 0), isEmpty);
    });

    test('preserves order of matched elements', () {
      final result = [5, 3, 8, 1, 6].filter((e) => e > 4);
      expect(result, [5, 8, 6]);
    });
  });

  group('ListExtension.separated', () {
    test('empty list → empty list', () {
      final result = <int>[].separated(
        () => const Text('sep'),
        (e, i) => Text('$e'),
      );
      expect(result, isEmpty);
    });

    test('n items → 2n - 1 elements', () {
      final result = [1, 2, 3].separated(
        () => const Text('sep'),
        (e, i) => Text('$e'),
      );
      expect(result.length, 5);
    });

    test('single item → 1 element, no separator', () {
      final result = [42].separated(
        () => const Text('sep'),
        (e, i) => Text('$e'),
      );
      expect(result.length, 1);
    });

    test('correct indices passed to itemBuilder', () {
      final capturedIndices = <int>[];
      [10, 20, 30].separated(
        () => const Text('sep'),
        (e, i) {
          capturedIndices.add(i);
          return Text('$e');
        },
      );
      expect(capturedIndices, [0, 1, 2]);
    });

    test('odd positions are separators, even are items', () {
      final result = ['a', 'b', 'c'].separated(
        () => const Text('|'),
        (e, i) => Text(e),
      );
      expect((result[0] as Text).data, 'a');
      expect((result[1] as Text).data, '|');
      expect((result[2] as Text).data, 'b');
      expect((result[3] as Text).data, '|');
      expect((result[4] as Text).data, 'c');
    });
  });

  group('ListExtension.reverse', () {
    test('reverses list', () {
      expect([1, 2, 3].reverse(), [3, 2, 1]);
    });

    test('empty list → empty result', () {
      expect(<int>[].reverse(), isEmpty);
    });

    test('single element → unchanged', () {
      expect([42].reverse(), [42]);
    });

    test('two elements → swapped', () {
      expect(['a', 'b'].reverse(), ['b', 'a']);
    });

    test('does not mutate original list', () {
      final original = [1, 2, 3];
      final reversed = original.reverse();
      expect(reversed, [3, 2, 1]);
      expect(original, [1, 2, 3]);
    });
  });
}
