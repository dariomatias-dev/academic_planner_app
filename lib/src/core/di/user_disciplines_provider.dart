import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/notifiers/user_disciplines_notifier.dart';

final userDisciplinesNotifierProvider =
    NotifierProvider<UserDisciplinesNotifier, Set<int>>(
      UserDisciplinesNotifier.new,
    );
