import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:academic_planner/src/features/auth/data/auth_service.dart';
import 'package:academic_planner/src/features/auth/domain/auth_repository_impl.dart';
import 'package:academic_planner/src/features/auth/presentation/auth_notifier.dart';

final authInjection = <SingleChildWidget>[
  ChangeNotifierProvider(
    create: (_) {
      final firebaseAuth = FirebaseAuth.instance;
      final service = AuthService(firebaseAuth);
      final repository = AuthRepositoryImpl(service);

      return AuthNotifier(repository);
    },
  ),
];
