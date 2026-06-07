import 'package:flutter/material.dart';

extension ListExtension<R> on List<R> {
  List<T> builder<T>(T Function(R e, int index) toElement) {
    return List.generate(length, (index) {
      return toElement(elementAt(index), index);
    });
  }

  List<Widget> separated(
    Widget Function() separatorBuilder,
    Widget Function(R e, int index) itemBuilder,
  ) {
    return List.generate(isNotEmpty ? length * 2 - 1 : 0, (index) {
      if (index.isOdd) {
        return separatorBuilder();
      }

      final currentIndex = index ~/ 2;

      return itemBuilder(elementAt(currentIndex), currentIndex);
    });
  }

  List<R> filter(bool Function(R e) test) {
    final result = <R>[];

    for (final item in this) {
      if (test(item)) {
        result.add(item);
      }
    }

    return result;
  }

  List<R> reverse() {
    final result = <R>[];

    for (var i = length - 1; i >= 0; i--) {
      result.add(this[i]);
    }

    return result;
  }
}
