import 'package:academic_planner/src/core/di/app_version_provider.dart';
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

  test('build returns "version+buildNumber"', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final version = await container.read(appVersionProvider.future);

    expect(version, '1.2.3+42');
  });
}
