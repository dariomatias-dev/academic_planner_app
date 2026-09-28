import 'package:academic_planner/src/core/routes/typed_routes.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/shared/screens/not_found/not_found_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Paths reachable without an authenticated session.
final Set<String> _publicRoutePaths = {
  const SplashRoute().location,
  const LoginRoute().location,
  const RegisterRoute().location,
  const ForgotPasswordRoute().location,
};

/// The decision behind the centralized authentication redirect: signed-out
/// users are sent to `login` from anywhere else, and signed-in users are
/// sent to `home` if they land on an auth-only screen (login, register,
/// forgot password). `splash` is left alone — it drives its own transition
/// once the session has finished loading. While the session is still
/// resolving (`isLoading`), no redirect decision is made, to avoid bouncing
/// the user before there's an answer.
///
/// A pure function of primitives (not `Ref`/`GoRouterState`) so it can be
/// unit-tested directly, without building the destination screen.
@visibleForTesting
String? resolveAuthRedirect({
  required bool isLoggedIn,
  required bool isLoading,
  required String matchedLocation,
}) {
  if (matchedLocation == const SplashRoute().location) return null;
  if (isLoading) return null;

  final isPublicRoute = _publicRoutePaths.contains(matchedLocation);

  if (!isLoggedIn && !isPublicRoute) return const LoginRoute().location;
  if (isLoggedIn && isPublicRoute) return const HomeRoute().location;

  return null;
}

String? _authRedirect(Ref ref, GoRouterState state) {
  final authState = ref.read(authNotifierProvider);

  return resolveAuthRedirect(
    isLoggedIn: authState.hasValue && authState.value != null,
    isLoading: authState.isLoading,
    matchedLocation: state.matchedLocation,
  );
}

/// Notifies [GoRouter] to re-run its redirect whenever auth state changes
/// (sign in, sign out, session restore), not just on navigation.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authNotifierProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: const SplashRoute().location,
    refreshListenable: refreshNotifier,
    redirect: (context, state) => _authRedirect(ref, state),
    errorBuilder: (context, state) {
      return const NotFoundScreen();
    },
    routes: $appRoutes,
  );
});
