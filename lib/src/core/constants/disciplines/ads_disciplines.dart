import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_fifth.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_first.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_fourth.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_second.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_sixth.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_third.dart';

import 'package:academic_planner/src/features/disciplines/domain/entities/discipline.dart';

final adsDisciplines = <Discipline>[
  ...adsDisciplinesFirst,
  ...adsDisciplinesSecond,
  ...adsDisciplinesThird,
  ...adsDisciplinesFourth,
  ...adsDisciplinesFifth,
  ...adsDisciplinesSixth,
];
