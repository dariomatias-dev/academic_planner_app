<div align="center">

# Architecture

</div>

## Table of Contents

- [Overview](#overview)
- [Feature-First](#feature-first)
- [Clean Architecture](#clean-architecture)
- [MVVM](#mvvm)
- [How the Three Combine](#how-the-three-combine)
- [Layers per Feature](#layers-per-feature)
- [Dependency Rules](#dependency-rules)
- [Data Flow](#data-flow)
- [State Management with Riverpod](#state-management-with-riverpod)
- [Folder Tree](#folder-tree)
- [Core Layer](#core-layer)
- [Shared Layer](#shared-layer)
- [Existing Features](#existing-features)
- [Widget Organization](#widget-organization)
- [Seeds](#seeds)
- [Navigation System](#navigation-system)
- [Technologies](#technologies)

---

## Overview

The project combines three complementary approaches to organize code in a scalable, testable, and maintainable way:

| Approach               | Responsibility                                  |
| ----------------------- | ----------------------------------------------- |
| **Feature-First**      | How code is organized into folders              |
| **Clean Architecture** | How layers communicate and depend on each other |
| **MVVM**               | How the UI connects to business logic           |

Each one solves a different problem. Together, they form a solid foundation for application growth without accumulating technical debt.

---

## Feature-First

### What it is

Feature-First is a **folder organization strategy** where each product feature is isolated in its own module. Instead of grouping files by technical type (all models together, all screens together), files are grouped by business domain.

```text
features/
├── activities/    # everything related to activities
├── disciplines/   # everything related to disciplines
├── notes/         # everything related to notes
└── auth/          # everything related to authentication
```

### Why it was chosen

- **Cohesion:** all code for a feature stays together. To understand or change `activities`, you navigate to `features/activities/` - no hunting for scattered files.
- **Scalability:** adding a new feature does not affect existing ones.
- **Isolation:** a feature can be removed or refactored without side effects on others.
- **Onboarding:** a new developer understands the domain just by reading the folder tree.

### Comparison with Layer-First

| Layer-First (conventional)                 | Feature-First (adopted)                         |
| -------------------------------------------- | ------------------------------------------------- |
| `models/activity.dart`, `models/note.dart` | `activities/data/models/`, `notes/data/models/` |
| Easy to understand the technical structure | Easy to understand the product domain           |
| Poor scalability                           | Good scalability                                |
| Changes cross many folders                 | Changes stay inside the feature                 |

---

## Clean Architecture

### What it is

Clean Architecture is a set of **layer dependency rules** created by Robert C. Martin (Uncle Bob). The goal is to separate business rules from infrastructure details (database, UI, frameworks).

```text
┌─────────────────────────────┐
│        Presentation         │  <- UI, ViewModels, Providers
├─────────────────────────────┤
│           Domain            │  <- Entities, Contracts (pure Dart)
├─────────────────────────────┤
│            Data             │  <- Models, Services, Repositories (impl.)
└─────────────────────────────┘
```

The core rule: **dependencies point inward**. The outer layer (Presentation, Data) depends on the inner one (Domain). Domain depends on nothing.

### Why it was chosen

- **Framework independence:** business rules in Domain are pure Dart - no Flutter, SQLite, or Riverpod.
- **Testability:** Domain can be tested without a database or widgets.
- **Replaceability:** swapping SQLite for another persistence solution only requires changing the Data layer.
- **Business protection:** the UI never accesses the database directly.

### Practical example

```
domain/repositories/activity_repository.dart     -> contract (interface)
data/repositories/activity_repository_impl.dart  -> implementation
data/datasources/activity_local_datasource.dart  -> SQLite access
```

Presentation only knows `ActivityRepository` (contract). The DI system decides which implementation to inject - the UI does not know whether data comes from SQLite, an API, or memory.

---

## MVVM

> MVVM is the pattern recommended by Flutter itself for application architecture. See: [Flutter App Architecture Guide](https://docs.flutter.dev/app-architecture/guide).

### What it is

MVVM (Model-View-ViewModel) is a **presentation pattern** that separates:

| Layer             | Responsibility                                       |
| ------------------ | ----------------------------------------------------- |
| **View** (Screen) | Renders the UI and captures user events              |
| **ViewModel**     | Contains presentation logic and manages screen state |
| **Model**         | Data and business rules (Domain + Data)              |

### Why it was chosen

- **No logic in the View:** the screen only observes state and fires actions - it never decides anything.
- **Testable ViewModel:** since it does not depend on `BuildContext` or widgets, it can be tested with pure unit tests.
- **Clear separation:** "what to show" logic lives in the ViewModel; "how to show it" logic lives in the View.

### Implementation with Riverpod

In this project the ViewModel is a plain Dart class. The Riverpod `Notifier` acts as an adapter that exposes the ViewModel's state reactively:

```dart
// ViewModel - pure logic, no Flutter
class ActivityViewModel {
  Future<void> createActivity(ActivityEntity activity) async { ... }
}

// Notifier - bridge between ViewModel and the UI
class ActivityNotifier extends AsyncNotifier<void> {
  late final ActivityViewModel _viewModel;

  @override
  Future<void> build() async {
    _viewModel = ActivityViewModel(ref.read(activityRepositoryProvider));
  }

  Future<Result<void>> add(Activity activity) async {
    return _viewModel.createActivity(activity);
  }
}
```

This separation ensures the ViewModel can be tested without simulating the Riverpod reactive environment.

---

## How the Three Combine

```text
Feature-First  -> where code lives (folders)
Clean Arch     -> how layers communicate (rules)
MVVM           -> how UI and logic connect (pattern)
```

Inside each feature, Clean Architecture defines the layers (`domain/`, `data/`, `presentation/`). Inside `presentation/`, MVVM defines how Screen, ViewModel, and Notifier relate to each other.

---

## Layers per Feature

### Domain

The central layer. Contains only **pure Dart code** - zero dependency on Flutter or external packages.

| Folder           | Content                                                |
| ----------------- | -------------------------------------------------------- |
| `entities/`      | Represent business truth (e.g. `Activity`)             |
| `repositories/`  | Contracts (abstract interfaces) for data access        |
| `value_objects/` | Types with built-in validation (e.g. `ActivityFilter`) |

**Rule:** no Domain file imports from the Data or Presentation layer.

### Data

Responsible for providing and persisting data.

| Folder          | Content                                             |
| ---------------- | ----------------------------------------------------- |
| `models/`       | DTOs with mapping logic (`fromMap`, `toMap`)        |
| `datasources/`  | Direct access to the data source (SQLite, Firebase) |
| `repositories/` | Implementations of the contracts defined in Domain  |

**Models** convert between the database/API format and Domain **Entities**. The Presentation layer never uses Models - only Entities.

### Presentation

The UI and user interaction layer.

| Folder         | Content                                             |
| --------------- | ------------------------------------------------------ |
| `screens/`     | Screen widgets that build the UI and observe state  |
| `view_models/` | Pure presentation logic, no `BuildContext`          |
| `providers/`   | Riverpod Notifiers that expose state reactively     |
| `widgets/`     | Visual components specific to the feature           |
| `actions/`     | Multi-step UI flows (e.g. delete with confirmation) |

Not every feature has every layer or folder — only the ones it has content for. See [Existing Features](#existing-features).

---

## Dependency Rules

```text
Presentation --> Domain <-- Data
```

1. **Domain depends on nothing.** It is the protected core.
2. **Presentation depends on Domain** (contracts), never on Data (implementations).
3. **Data depends on Domain** to implement the contracts.
4. **The DI layer (`di/`)** resolves which concrete implementation to inject at runtime.

Violating these rules introduces coupling that makes testing and swapping implementations harder.

---

## Data Flow

```text
View (Screen)
  | fires action (e.g. save button)
  v
Provider (Notifier)
  | delegates to
  v
ViewModel
  | calls contract
  v
Repository (Domain - interface)
  | implemented by
  v
RepositoryImpl (Data)
  | uses
  v
DataSource / Service (SQLite, Firebase)
```

The reverse flow (data arriving at the UI) is reactive via Riverpod: the Notifier notifies the View when state changes.

---

## State Management with Riverpod

**Riverpod** is the state management and dependency injection solution for the project.

### Why Riverpod

- **Compile-safe:** provider errors are caught at compile time.
- **No `BuildContext`:** providers can be accessed outside the widget tree.
- **Integrated DI:** the same system serves reactive state and dependency injection.
- **Testable:** providers can be overridden in tests without extra configuration (see [provider_graph_smoke_test.dart](../test/provider_graph_smoke_test.dart) for an example that overrides every external dependency at once).

### Provider types used

| Provider                | Usage                                                          |
| ------------------------ | ----------------------------------------------------------------- |
| `Provider`              | Immutable dependencies (repositories, services, data sources) |
| `AsyncNotifierProvider` | Async state with lifecycle (lists, database/Firestore data)   |
| `NotifierProvider`      | Sync state with logic (filters, theme, forms)                 |
| `FutureProvider`        | One-shot or derived async reads, including `.family` variants |

### Provider structure per feature

```text
features/activities/
├── di/
│   └── activity_providers.dart          <- DI providers (repository, datasource)
└── presentation/
    └── providers/
        ├── activity_notifier.dart        <- main list state
        ├── activity_filter_notifier.dart <- filter state
        └── activity_stats_notifier.dart  <- statistics state
```

Separating `di/` from `presentation/providers/` keeps infrastructure providers (DI) isolated from UI providers (state).

---

## Folder Tree

```text
lib/
├── main.dart                        # Application entry point
├── firebase_options.dart            # Firebase-generated configuration
└── src/
    ├── academic_planner_app.dart    # Root widget (MaterialApp + theme + router)
    │
    ├── core/                        # Global and cross-cutting infrastructure — see Core Layer
    │
    ├── features/                    # Isolated business modules
    │   └── <feature>/               # See Existing Features
    │       ├── data/
    │       │   ├── datasources/     # Direct database/API access
    │       │   ├── models/          # DTOs with fromMap/toMap
    │       │   ├── repositories/    # Domain contract implementations
    │       │   └── seeds/           # Feature-specific dev seeds (optional)
    │       ├── di/                  # Feature-specific DI providers
    │       ├── domain/
    │       │   ├── entities/        # Pure domain entities
    │       │   ├── repositories/    # Contracts (abstract interfaces)
    │       │   └── value_objects/   # Types with built-in validation
    │       └── presentation/
    │           ├── actions/         # Multi-step UI flows
    │           ├── providers/       # State notifiers
    │           ├── screens/         # Screens and their internal widgets
    │           ├── view_models/     # Pure presentation logic
    │           └── widgets/         # Feature-specific visual components
    │
    └── shared/                      # Reusable global resources — see Shared Layer
```

---

## Core Layer

The `core/` folder concentrates **cross-cutting** infrastructure shared by all features. It is not a feature - it is application infrastructure.

```text
core/
├── constants/                   # Static data and course catalog
│   ├── disciplines/             # Discipline data by academic period
│   ├── day_names.dart
│   ├── schedules.dart
│   └── teachers.dart
│
├── database/                    # SQLite persistence
│   ├── app_database.dart        # Central database configuration
│   ├── migrations/              # Versioned schema migrations (migration_v1.dart, ...)
│   └── tables/                  # Table definitions
│
├── di/                          # Global dependency injection providers
│   ├── app_version_provider.dart
│   ├── database_provider.dart
│   ├── firebase_providers.dart
│   ├── shared_preferences_provider.dart
│   └── theme_provider.dart
│
├── domain/entities/             # Entities shared across features (Pagination, Discipline, ScheduleEntry)
│
├── errors/                      # Result<T>/Failure pattern + the global error boundary (see below)
│
├── extensions/                  # Dart/Flutter type extensions
│
├── logging/app_logger.dart          # Centralized logging (see below)
│
├── notifiers/app_version_notifier.dart
│
├── routes/                      # Navigation system (GoRouter) — see Navigation System
│   └── root_navigation.dart     # Root navigation widget with bottom nav
│
├── seeds/                       # Base seed infrastructure (see Seeds)
│
├── services/                    # Reusable infrastructure services
│   └── shared_preferences_keys.dart # Local persistence keys
│
├── theme/                       # Light/dark theme configuration and persistence
│   └── app_colors.dart          # Global color palette
│
└── validators/validators.dart   # Reusable form field validators
```

**`core/errors/`** - implementation of the `Result<T>` pattern:

```dart
Result<List<Activity>> result = await repository.getAll();

switch (result) {
  case Success(:final value) => state = value,
  case Failure(:final failure) => handleError(failure),
}
```

The same folder also wires the app's global error boundary, via `configureErrorBoundary` (called once from `main()`): `FlutterError.onError` and `PlatformDispatcher.instance.onError` both forward to an `ErrorReporter` — a contract with a single `LoggingErrorReporter` implementation today, so a real crash-reporting backend can be swapped in later without touching call sites. In release builds only, `ErrorWidget.builder` is also replaced with `ErrorStateWidget` instead of Flutter's default red error screen, which stays in debug where it's useful.

**`core/database/`** - SQLite with a versioned migration system:

```dart
class MigrationV2 implements Migration {
  @override
  Future<void> up(Database db) async {
    await db.execute(NoteTable.createTableQuery);
  }
}
```

**`core/logging/app_logger.dart`** - the single point of logging: every file that logs creates its own `AppLogger('feature.ClassName')` and calls it. `package:logger` is an implementation detail used only inside this file, for pretty console output — no other file imports it. `silenceLogging()` turns the output off; `test/flutter_test_config.dart` calls it so test runs stay quiet.

---

## Shared Layer

Components with no knowledge of business domain. Any feature can use them.

```text
shared/
├── models/    # Models shared across features
├── screens/   # Screens with no owning feature (about, splash, not_found, pdf_viewer)
├── utils/     # Pure functions without UI
└── widgets/   # Design System - generic components (buttons, dialogs, forms, inputs, states, ...)
```

- **`shared/widgets/`**: Design System - buttons, inputs, dialogs, empty states, tab bars.
- **`shared/utils/`**: Pure functions without UI.
- **`shared/models/`**: Models reused across multiple features.
- **`shared/screens/`**: Screens that don't belong to any business feature (`about`, `splash`, `not_found`, `pdf_viewer`). Kept out of `features/` to avoid faking a domain that doesn't exist; internal `widgets/` subfolders here follow the same screen-local decomposition convention as `features/<feature>/presentation/screens/<screen>/widgets/`.

---

## Existing Features

| Feature          | Description                                                  | Layers                                 |
| ----------------- | -------------------------------------------------------------- | ----------------------------------------- |
| `activities`     | Academic activity CRUD with filters and statistics           | `data`, `domain`, `presentation`, `di` |
| `auth`           | Firebase authentication (login, register, password recovery) | `data`, `domain`, `presentation`, `di` |
| `calendar`       | Agenda view with calendar and activities by date              | `presentation`, `di`                   |
| `categories`     | Activity category management                                 | `data`, `domain`, `presentation`, `di` |
| `course_details` | User course details                                           | `presentation`                         |
| `disciplines`    | Discipline management and selection by academic period       | `data`, `domain`, `presentation`, `di` |
| `home`           | Dashboard with general summary                                | `presentation`                         |
| `notes`          | Note CRUD with rich text editor                               | `data`, `domain`, `presentation`, `di` |
| `schedule`       | Weekly class schedule grid                                    | `data`, `presentation`                 |
| `settings`       | User settings (theme, account deletion)                       | `presentation`                         |
| `tags`           | Activity tag management                                       | `data`, `domain`, `presentation`, `di` |
| `teacher`        | Discipline teacher information                                | `data`, `presentation`                 |
| `users`          | User profile and account management                           | `data`, `domain`, `presentation`, `di` |

Screens with no owning feature (`about`, `splash`, `not_found`, `pdf_viewer`) live in `shared/screens/` instead - see [Shared Layer](#shared-layer).

---

## Widget Organization

Two levels of reuse:

### `shared/widgets/` - Design System

Generic components with no domain knowledge. Used by any feature.

```dart
AppButton(
  label: 'Save',
  onPressed: () => viewModel.save(),
)
```

### `features/<feature>/presentation/widgets/` - Semantic Components

Widgets tied to the feature's domain. Can reference feature-specific entities and logic.

```dart
ActivityCardWidget(
  activity: activity,
  onTap: () => AppRoutes.goToActivityDetails(context, activityId: activity.id),
)
```

### Decision rule

| Scenario                                       | Where to place                                                  |
| ------------------------------------------------ | -------------------------------------------------------------- |
| Used by 2+ features                            | `shared/widgets/`                                              |
| Uses entities or logic from a specific feature | `features/<feature>/presentation/widgets/`                     |
| Generic but created for one feature            | `features/<feature>/presentation/widgets/` (can promote later) |

---

## Seeds

Seeds live in two places: base infrastructure in `core/seeds/` and feature-specific data in `features/<feature>/data/seeds/`.

Seeds **never execute in production** (blocked by `kDebugMode`) and are **inactive by default in debug** too. Double gate:

```dart
// core/seeds/seed_initializer.dart
const _seedEnabled = bool.fromEnvironment('SEED_ENABLED', defaultValue: false);

Future<void> runDevSeeds(Database db) async {
  if (!kDebugMode || !_seedEnabled) return;
  // ...
}
```

| Use case                           | Command                                       |
| ------------------------------------- | ------------------------------------------------ |
| Run app with seeds on first launch | `flutter run --dart-define=SEED_ENABLED=true` |
| Run seeds standalone (no emulator) | `dart run scripts/seed.dart`                  |
| Normal dev / release               | seeds never run                               |

---

## Navigation System

Navigation was designed to be **decoupled, typed, and centralized**. The UI never navigates directly with strings or URLs - it uses semantic methods that encapsulate all routing details.

```text
UI -> AppRoutes -> GoRouter -> Screen
```

This flow ensures that a route change (name, path, parameters) impacts only the navigation files, not the screens.

### Why GoRouter

- Declarative and centralized navigation (routes defined in one place)
- Navigator 2.0 integration with native Deep Linking support
- Path parameters and query parameters support
- Typed routes generated by `go_router_builder` - no literal strings scattered around
- Built-in error handling (404 screen)
- Scales well for large applications

### File Structure

```text
core/routes/
├── app_router.dart    # Central GoRouter configuration and route tree
├── app_routes.dart    # Semantic navigation methods (abstraction layer)
├── typed_routes.dart  # Typed route classes (path, parameters, screen)
└── typed_routes.g.dart # Generated by go_router_builder (committed)
```

Each route is a class extending `GoRouteData` in `typed_routes.dart`, annotated with its path. Path and query parameters are typed constructor fields, and `go_router_builder` generates the route tree (`$appRoutes`, used by `app_router.dart`) and each route's `location`/`go`/`push` into `typed_routes.g.dart`, which is committed. Query parameter names are derived from the field names in kebab-case (`disciplineId` becomes `discipline-id`). Run `dart run build_runner build` after changing `typed_routes.dart`; `scripts/verify.sh` and CI regenerate the code and fail if it differs from what is committed.

`app_router.dart` exposes the `GoRouter` as a Riverpod provider (`routerProvider`), with the route tree, error handling and a centralized authentication redirect: signed-out users are sent to `login` from any protected route, and signed-in users on `login`/`register`/`forgot-password` are sent to `home`. The decision itself lives in the pure function `resolveAuthRedirect`, and the router re-evaluates it whenever auth state changes (e.g. after logout), not just on navigation. `home`, `myDisciplines`, `activities` and `settings` are tabs of a `StatefulShellRoute` (the bottom navigation bar), not reached through `AppRoutes`.

`app_routes.dart` is the abstraction layer that encapsulates all navigation. **The UI only calls methods from here:**

```dart
static Future<void> goToDisciplineDetails(
  BuildContext context, {
  required int disciplineId,
  int? tab,
}) async {
  await DisciplineDetailsRoute(
    disciplineId: disciplineId,
    tab: tab ?? 0,
  ).push<void>(context);
}
```

**Benefits:** typed parameters (the compiler catches errors before runtime), a single point to change the behavior of any navigation, and the UI never knows route names, paths, or how to pass parameters.

### Route Reference

| Name                  | Path                                | Method in AppRoutes     | Parameters                                    |
| ---------------------- | -------------------------------------- | -------------------------- | ------------------------------------------------ |
| `home`                | `/home`                             | bottom nav tab           | -                                              |
| `myDisciplines`       | `/my-disciplines`                   | bottom nav tab           | -                                              |
| `activities`          | `/activities`                       | bottom nav tab / `goToActivities` | -                                       |
| `settings`            | `/settings`                         | bottom nav tab           | -                                              |
| `about`               | `/about`                            | `goToAbout`              | -                                              |
| `activityDetails`     | `/activity-details/:activityId`     | `goToActivityDetails`    | `activityId: String` (path)                   |
| `activityForm`        | `/activity-form`                    | `goToActivityForm`       | `activityId: String?`, `disciplineId: int?` (query), returns `bool?` |
| `agenda`              | `/agenda`                           | `goToAgenda`              | -                                              |
| `categories`          | `/categories`                       | `goToCategories`          | -                                              |
| `courseDetails`       | `/course-details`                   | `goToCourseDetails`       | -                                              |
| `disciplineDetails`   | `/discipline-details/:disciplineId` | `goToDisciplineDetails`   | `disciplineId: int` (path), `tab: int?` (query) |
| `disciplineSelection` | `/discipline-selection`             | `goToDisciplineSelection` | -                                              |
| `disciplines`         | `/disciplines`                      | `goToDisciplines`         | -                                              |
| `editProfile`         | `/edit-profile`                     | `goToEditProfile`         | -                                              |
| `forgotPassword`      | `/forgot-password`                  | `goToForgotPassword`      | -                                              |
| `home` (push)         | `/home`                             | `goToHome`                | -                                              |
| `login`               | `/login`                            | `goToLogin`               | `replace: bool` (default `false`)              |
| `mySchedule`          | `/my-schedule`                      | `goToMySchedule`          | -                                              |
| `noteDetails`         | `/note-details/:noteId`             | `goToNoteDetails`         | `noteId: String` (path)                        |
| `noteForm`            | `/note-form`                        | `goToNoteForm`            | `disciplineId: int` (query), `noteId: String?` (query) |
| `pdfViewer`           | `/pdf-viewer`                       | `goToPdfViewer`           | `url: String`, `title: String` (query)         |
| `register`            | `/register`                         | `goToRegister`            | `replace: bool` (default `false`)              |
| `schedule`            | `/schedule`                         | `goToSchedule`            | `period: int?` (query)                         |
| `splash`              | `/splash`                           | initial route             | -                                              |
| `tags`                | `/tags`                             | `goToTags`                | -                                              |
| `teacherDetails`      | `/teacher-details/:teacherId`       | `goToTeacherDetails`      | `teacherId: int` (path)                        |
| `userManagement`      | `/user-management`                  | `goToUserManagement`      | -                                              |

### Push vs Go

| Method        | Behavior                                                         | When to use                       |
| --------------- | -------------------------------------------------------------------- | ------------------------------------ |
| `push()` | Stacks a new route on top of the current one (back button works) | Details, forms, secondary flows   |
| `go()`   | Completely replaces the current route                            | Login, splash, logout, flow reset |

### How to Add a New Route

1. Add a route class (with its `@TypedGoRoute` path) in `typed_routes.dart`.
2. Run `dart run build_runner build` to regenerate `typed_routes.g.dart`.
3. Add a `goTo...` method in `app_routes.dart`.
4. Call it from the UI: `AppRoutes.goToMyNewScreen(context);`.

---

## Technologies

### Core Stack

| Technology                      | Version     | Role in the project         |
| ---------------------------------- | ------------- | ------------------------------ |
| [Flutter](https://flutter.dev/) | 3.44.9      | Cross-platform UI framework |
| [Dart](https://dart.dev/)       | SDK ^3.12.2 | Programming language        |

### State Management and DI

| Package                                                       | Version | Role in the project                                    |
| ----------------------------------------------------------------- | --------- | ---------------------------------------------------------- |
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | 3.4.3   | Reactive state management and dependency injection     |
| [riverpod](https://pub.dev/packages/riverpod)                 | 3.4.3   | Riverpod core (without Flutter) - used in Domain layer |

**Why Riverpod:** compile-safe solution that unifies state management and DI. Providers can be accessed without `BuildContext`, overridden in tests, and composed without boilerplate. See [State Management with Riverpod](#state-management-with-riverpod).

### Persistence

| Package                                                           | Version | Role in the project                          |
| ------------------------------------------------------------------- | --------- | ----------------------------------------------- |
| [sqflite](https://pub.dev/packages/sqflite)                       | 2.4.4   | Local SQLite database                        |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 2.5.5   | Simple preference persistence (theme, flags) |

**Why SQLite:** complex relational data (activities, notes, disciplines) requires queries, joins, and versioned migrations - SQLite via sqflite is the natural choice for offline-first Flutter.

### Authentication and Backend

| Package                                                     | Version | Role in the project                        |
| --------------------------------------------------------------- | --------- | ---------------------------------------------- |
| [firebase_core](https://pub.dev/packages/firebase_core)     | 4.15.0  | Firebase initialization                    |
| [firebase_auth](https://pub.dev/packages/firebase_auth)     | 6.7.0   | User authentication                        |
| [google_sign_in](https://pub.dev/packages/google_sign_in)   | 7.2.0   | Google account sign-in (via Firebase Auth) |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore) | 6.10.0  | Cloud database for user data               |

The project adopts a **hybrid persistence architecture**: local data (activities, notes) lives in SQLite; user data and authentication live in Firebase. This ensures offline functionality for the core features.

**Required Firebase configuration:** Google sign-in only works once the provider is enabled in Authentication → Sign-in method and the app's SHA-1 fingerprint is registered on the project.

### Navigation

| Package                                         | Version | Role in the project                   |
| --------------------------------------------------- | --------- | ---------------------------------------- |
| [go_router](https://pub.dev/packages/go_router) | 18.0.1  | Declarative routing with Deep Linking |

See [Navigation System](#navigation-system) above.

### UI and Design

| Package                                                                               | Version | Role in the project         |
| ----------------------------------------------------------------------------------------- | --------- | ------------------------------- |
| [google_fonts](https://pub.dev/packages/google_fonts)                                 | 8.2.1   | Typography (Google Fonts)   |
| [syncfusion_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar)   | 34.2.9  | Advanced calendar component |
| [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) | 34.2.9  | Built-in PDF viewer         |
| [flutter_quill](https://pub.dev/packages/flutter_quill)                               | 11.6.0  | Rich text editor for notes  |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)                           | 1.0.9   | iOS-style icons             |

### Utilities

| Package                                                                       | Version | Role in the project                              |
| --------------------------------------------------------------------------------- | --------- | ---------------------------------------------------- |
| [intl](https://pub.dev/packages/intl)                                         | 0.20.2  | Date, number formatting and internationalization |
| [uuid](https://pub.dev/packages/uuid)                                         | 4.6.0   | Unique identifier generation                     |
| [url_launcher](https://pub.dev/packages/url_launcher)                         | 6.3.2   | Opening external URLs                            |
| [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) | 5.1.1   | Exporting images to the gallery                  |
| [package_info_plus](https://pub.dev/packages/package_info_plus)               | 10.2.1  | Reading package info (app version)               |
| [fluttertoast](https://pub.dev/packages/fluttertoast)                         | 10.0.0  | Native toast notifications                       |
| [logger](https://pub.dev/packages/logger)                                     | 2.8.0   | Pretty console output, wrapped by `AppLogger` — no other file imports it directly |

### Dev and Tooling

| Package                                                                   | Version | Role in the project                                    |
| ------------------------------------------------------------------------------ | --------- | ---------------------------------------------------------- |
| [very_good_analysis](https://pub.dev/packages/very_good_analysis)         | 10.3.0  | Strict lint rule set                                    |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | 0.14.4  | App icon generation for all platforms                  |
| [flutter_localizations](https://flutter.dev/)                             | SDK     | Localization support (Quill's editor toolbar, dates)    |
| [mocktail](https://pub.dev/packages/mocktail)                             | 1.0.5   | Mocking in unit and widget tests                        |
| [fake_cloud_firestore](https://pub.dev/packages/fake_cloud_firestore)     | 4.3.0   | In-memory Firestore fake for tests                       |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)         | 2.4.3   | SQLite FFI driver for tests and running seed scripts on desktop |

### About the Versions

The versions listed are the **resolved versions from `pubspec.lock`** - exact versions in use, not the ranges from `pubspec.yaml`. To update:

```bash
# View outdated dependencies
fvm flutter pub outdated

# Update within defined ranges
fvm flutter pub upgrade

# Update to new major versions (watch for breaking changes)
fvm flutter pub upgrade --major-versions
```
