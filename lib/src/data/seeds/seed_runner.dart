import 'package:academic_planner/src/core/logging/logger_service.dart';

import 'package:academic_planner/src/data/seeds/seed.dart';

class SeedRunner {
  final List<Seed> seeds;
  final LoggerService logger;

  SeedRunner({required this.seeds, required this.logger});

  Future<void> run() async {
    for (final seed in seeds) {
      logger.info('Running seed: ${seed.name}');

      try {
        await seed.run();

        logger.info('Finished seed: ${seed.name}');
      } catch (e, stackTrace) {
        logger.error(
          'Error running seed: ${seed.name}',
          error: e,
          stackTrace: stackTrace,
        );

        rethrow;
      }
    }
  }
}
