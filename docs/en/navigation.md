<div align="center">

# Navigation System

</div>

## Table of Contents

- [Overview](#overview)
- [Why GoRouter](#why-gorouter)
- [File Structure](#file-structure)
- [Route Reference](#route-reference)
- [Route Parameters](#route-parameters)
- [Push vs Go](#push-vs-go)
- [How to Add a New Route](#how-to-add-a-new-route)

---

## Overview

Navigation was designed to be **decoupled, typed, and centralized**. The UI never navigates directly with strings or URLs - it uses semantic methods that encapsulate all routing details.

```text
UI -> AppRoutes -> GoRouter -> Screen
```

This flow ensures that a route change (name, path, parameters) impacts only the navigation files, not the screens.

---

## Why GoRouter

The project uses **GoRouter** as Flutter's official declarative navigation solution.

**Reasons for the choice:**

- Declarative and centralized navigation (routes defined in one place)
- Navigator 2.0 integration with native Deep Linking support
- Path parameters and query parameters support
- Named navigation with `pushNamed`/`goNamed` - no literal strings scattered around
- Built-in error handling (404 screen)
- Scales well for large applications

---

## File Structure

```text
core/routes/
├── app_router.dart    # Central GoRouter configuration and route tree
├── app_routes.dart    # Semantic navigation methods (abstraction layer)
├── route_names.dart   # Unique route identifiers
└── route_paths.dart   # Route paths (URLs)
```

### `route_names.dart` and `route_paths.dart`

Centralize identifiers and URLs. Prevent literal strings from being scattered across the codebase.

```dart
// route_names.dart
static const disciplineDetails = 'discipline-details';

// route_paths.dart
static const disciplineDetails = '/discipline-details/:disciplineId';
```

### `app_router.dart`

Configures `GoRouter` with the route tree, initial route, and error handling:

```dart
static final router = GoRouter(
  initialLocation: RoutePaths.splash,
  errorBuilder: (context, state) => const NotFoundScreen(),
  routes: <RouteBase>[
    GoRoute(
      name: RouteNames.disciplineDetails,
      path: RoutePaths.disciplineDetails,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['disciplineId']!);
        return DisciplineDetailsScreen(disciplineId: id);
      },
    ),
    // ...
  ],
);
```

### `app_routes.dart`

Abstraction layer that encapsulates all navigation. **The UI only calls methods from here.**

```dart
static void goToDisciplineDetails(
  BuildContext context, {
  required int disciplineId,
}) {
  context.pushNamed(
    RouteNames.disciplineDetails,
    pathParameters: {'disciplineId': disciplineId.toString()},
  );
}
```

**Benefits:**

- Typed parameters - the compiler catches errors before runtime
- Single point to change the behavior of any navigation
- The UI does not know route names, paths, or how to pass parameters

---

## Route Reference

| Name                | Path                                | Method in AppRoutes     | Parameters                   |
| ------------------- | ----------------------------------- | ----------------------- | ---------------------------- |
| `splash`            | `/splash`                           | -                       | -                            |
| `login`             | `/login`                            | `goToLogin`             | -                            |
| `register`          | `/register`                         | `goToRegister`          | -                            |
| `forgotPassword`    | `/forgot-password`                  | `goToForgotPassword`    | -                            |
| `home`              | `/home`                             | `goToHome`              | -                            |
| `activities`        | `/activities`                       | `goToActivities`        | -                            |
| `activityDetails`   | `/activity-details/:activityId`     | `goToActivityDetails`   | `activityId: int`            |
| `activityForm`      | `/activity-form`                    | `goToActivityForm`      | `disciplineId: int?` (query) |
| `disciplines`       | `/disciplines`                      | `goToDisciplines`       | -                            |
| `disciplineDetails` | `/discipline-details/:disciplineId` | `goToDisciplineDetails` | `disciplineId: int`          |
| `calendar`          | `/calendar`                         | `goToCalendar`          | -                            |
| `notes`             | `/notes`                            | `goToNotes`             | -                            |
| `noteForm`          | `/note-form`                        | `goToNoteForm`          | `noteId: int?` (query)       |
| `settings`          | `/settings`                         | `goToSettings`          | -                            |
| `about`             | `/about`                            | `goToAbout`             | -                            |

---

## Route Parameters

### Path Parameters

Used when the parameter **identifies** the resource - it is part of the URL.

```text
/discipline-details/5
```

**Definition:**

```dart
static const disciplineDetails = '/discipline-details/:disciplineId';
```

**Reading:**

```dart
final id = state.pathParameters['disciplineId']!;
```

### Query Parameters

Used for **optional or complementary** state - they do not identify the route.

```text
/activity-form?disciplineId=10
```

**Reading:**

```dart
final disciplineId = state.uri.queryParameters['disciplineId'];
```

### Strategy adopted

| Type            | When to use                         | Example                          |
| --------------- | ----------------------------------- | -------------------------------- |
| Path Parameter  | Resource identity (always required) | `/activities/5`                  |
| Query Parameter | Optional context (can be null)      | `/activity-form?disciplineId=10` |

---

## Push vs Go

The project uses two distinct navigation behaviors:

| Method        | Behavior                                                         | When to use                       |
| ------------- | ---------------------------------------------------------------- | --------------------------------- |
| `pushNamed()` | Stacks a new route on top of the current one (back button works) | Details, forms, secondary flows   |
| `goNamed()`   | Completely replaces the current route                            | Login, splash, logout, flow reset |

```dart
// Stacks - user can go back
AppRoutes.goToActivityDetails(context, activityId: 5);

// Replaces - no going back (suitable for logout)
AppRoutes.goToLogin(context);
```

---

## How to Add a New Route

1. **Add the name** in `route_names.dart`:

```dart
static const myNewScreen = 'my-new-screen';
```

2. **Add the path** in `route_paths.dart`:

```dart
static const myNewScreen = '/my-new-screen';
// With parameter: '/my-new-screen/:id'
```

3. **Register the route** in `app_router.dart`:

```dart
GoRoute(
  name: RouteNames.myNewScreen,
  path: RoutePaths.myNewScreen,
  builder: (context, state) => const MyNewScreen(),
),
```

4. **Create the navigation method** in `app_routes.dart`:

```dart
static void goToMyNewScreen(BuildContext context) {
  context.pushNamed(RouteNames.myNewScreen);
}
```

5. **Use it in the UI:**

```dart
AppRoutes.goToMyNewScreen(context);
```
