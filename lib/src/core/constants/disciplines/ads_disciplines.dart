import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_fifth.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_first.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_fourth.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_second.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_sixth.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines_third.dart';

import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';

final adsDisciplines = <DisciplineModel>[
  ...adsDisciplinesFirst,
  ...adsDisciplinesSecond,
  ...adsDisciplinesThird,
  ...adsDisciplinesFourth,
  ...adsDisciplinesFifth,
  ...adsDisciplinesSixth,
];
