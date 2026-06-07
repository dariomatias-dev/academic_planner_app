import 'package:academic_planner/src/core/seeds/seed.dart';
import 'package:logging/logging.dart';

class SeedRunner {
  SeedRunner({required this.seeds});

  static final _log = Logger('seeds.SeedRunner');

  final List<Seed> seeds;

  Future<void> run() async {
    for (final seed in seeds) {
      _log.info('Running seed: ${seed.name}');

      try {
        await seed.run();

        _log.info('Finished seed: ${seed.name}');
      } on Exception catch (e, stackTrace) {
        _log.severe('Error running seed: ${seed.name}', e, stackTrace);

        rethrow;
      }
    }
  }
}
