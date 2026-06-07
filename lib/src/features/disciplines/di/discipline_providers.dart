import 'package:academic_planner/src/features/disciplines/presentation/providers/user_disciplines_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDisciplinesNotifierProvider =
    NotifierProvider<UserDisciplinesNotifier, Set<int>>(
      UserDisciplinesNotifier.new,
    );
