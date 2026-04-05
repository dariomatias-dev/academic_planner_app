import 'package:logger/logger.dart';

import 'package:academic_planner/src/data/seeds/seed.dart';

class SeedRunner {
  final List<Seed> seeds;
  final Logger logger;

  SeedRunner({required this.seeds, required this.logger});

  Future<void> run() async {
    for (final seed in seeds) {
      logger.i('Running seed: ${seed.name}');

      try {
        await seed.run();

        logger.i('Finished seed: ${seed.name}');
      } catch (e, stackTrace) {
        logger.e(
          'Error running seed: ${seed.name}',
          error: e,
          stackTrace: stackTrace,
        );

        rethrow;
      }
    }
  }
}
