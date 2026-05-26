<div align="center">

# Project Structure

</div>

## Table of Contents

- [Folder Tree](#folder-tree)
- [Section Details](#section-details)
- [Existing Features](#existing-features)
- [Widget Organization](#widget-organization)
- [Seeds](#seeds)

---

## Folder Tree

```text
lib/
├── main.dart                        # Application entry point
├── firebase_options.dart            # Firebase-generated configuration
└── src/
    ├── app_widget.dart              # Root widget (MaterialApp + theme + router)
    │
    ├── core/                        # Global and cross-cutting infrastructure
    │   ├── app_colors.dart          # Global color palette
    │   ├── root_navigation.dart     # Root navigation widget with bottom nav
    │   ├── shared_preferences_keys.dart  # Local persistence keys
    │   ├── validators.dart          # Reusable validators
    │   │
    │   ├── constants/               # Static data and mocks
    │   │   ├── disciplines/         # Discipline data by period (ADS course)
    │   │   ├── day_names.dart       # Day-of-week names
    │   │   ├── mock_activities.dart # Mock activities for development
    │   │   └── schedules.dart       # Default schedules
    │   │
    │   ├── database/                # SQLite persistence
    │   │   ├── app_database.dart    # Central database configuration
    │   │   ├── migrations/          # Versioned schema migrations
    │   │   │   ├── migration.dart   # Base migration interface
    │   │   │   ├── migration_v1.dart
    │   │   │   └── migration_v2.dart
    │   │   └── tables/              # Table definitions
    │   │       ├── activity_table.dart
    │   │       └── note_table.dart
    │   │
    │   ├── di/                      # Global dependency injection providers
    │   │   ├── app_version_provider.dart
    │   │   ├── database_provider.dart
    │   │   ├── firebase_providers.dart
    │   │   ├── navigation_provider.dart
    │   │   ├── shared_preferences_provider.dart
    │   │   └── theme_provider.dart
    │   │
    │   ├── domain/                  # Entities shared across features
    │   │   └── entities/
    │   │       └── pagination.dart
    │   │
    │   ├── extensions/              # Dart/Flutter type extensions
    │   │   ├── activity_status_extension.dart
    │   │   ├── announcement_type_extension.dart
    │   │   ├── list_extension.dart
    │   │   ├── theme_mode_extension.dart
    │   │   └── user_role_extension.dart
    │   │
    │   ├── logging/                 # Centralized logging service
    │   │   ├── logger_provider.dart
    │   │   ├── logger_service.dart       # Interface
    │   │   └── logger_service_impl.dart  # Implementation
    │   │
    │   ├── seeds/                   # Development seeds  (inactive by default)
    │   │   ├── seed.dart            # Base Seed interface
    │   │   ├── seed_runner.dart     # Sequential seed executor
    │   │   └── seed_initializer.dart  # Gated entry point (kDebugMode + dart-define)
    │   │
    │   ├── notifiers/               # Global state notifiers
    │   │   ├── app_version_notifier.dart
    │   │   └── navigation_notifier.dart
    │   │
    │   ├── result/                  # Functional error handling
    │   │   ├── exception_mapper.dart
    │   │   ├── failure.dart         # Error types
    │   │   └── result.dart          # Result<T> wrapper
    │   │
    │   ├── routes/                  # Navigation system (GoRouter)
    │   │   ├── app_router.dart      # Route tree and central configuration
    │   │   ├── app_routes.dart      # Semantic navigation methods
    │   │   ├── route_names.dart     # Unique route identifiers
    │   │   └── route_paths.dart     # Route paths (URLs)
    │   │
    │   ├── services/                # Reusable infrastructure services
    │   │   ├── image_export_service.dart
    │   │   └── shared_preferences_service.dart
    │   │
    │   └── theme/                   # Application theming
    │       ├── app_theme.dart       # Light and dark theme definitions
    │       └── theme_notifier.dart  # Theme control and persistence
    │
    ├── features/                    # Isolated business modules
    │   └── <feature>/               # See "Existing Features" section
    │       ├── data/
    │       │   ├── data_source/     # Direct database/API access
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
    └── shared/                      # Reusable global resources
        ├── models/                  # Models shared across features
        ├── utils/                   # Utility functions without UI
        └── widgets/                 # Design System - generic components
            ├── buttons/
            ├── dialogs/
            ├── forms/
            ├── icon_buttons/
            ├── inputs/
            ├── nav_bar/
            ├── periods_tab_bar/
            ├── popup_menu/
            ├── schedule_table_view/
            └── states/
```

---

## Section Details

### `core/`

Infrastructure shared across the entire application. No feature depends on another feature - all depend on `core/` when they need global resources.

**`core/result/`** - implementation of the `Result<T, Failure>` pattern:

```dart
// Typed return without scattered exceptions
Result<List<ActivityEntity>, Failure> result = await repository.getAll();

result.when(
  success: (activities) => state = activities,
  failure: (failure) => handleError(failure),
);
```

**`core/database/`** - SQLite with a versioned migration system:

```dart
// Each schema version has its own migration class
class MigrationV2 implements Migration {
  @override
  Future<void> up(Database db) async {
    await db.execute('ALTER TABLE activities ADD COLUMN ...');
  }
}
```

### `shared/`

Components with no knowledge of business domain. Any feature can use them.

- **`shared/widgets/`**: Design System - buttons, inputs, dialogs, empty states, tab bars.
- **`shared/utils/`**: Pure functions without UI.
- **`shared/models/`**: Models reused across multiple features.

### Seeds

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
| ---------------------------------- | --------------------------------------------- |
| Run app with seeds on first launch | `flutter run --dart-define=SEED_ENABLED=true` |
| Run seeds standalone (no emulator) | `dart run scripts/seed.dart`                  |
| Normal dev / release               | seeds never run                               |

---

## Existing Features

| Feature          | Description                                                  | Layers                                 |
| ---------------- | ------------------------------------------------------------ | -------------------------------------- |
| `about`          | App info screen with source code link                        | `presentation`                         |
| `activities`     | Academic activity CRUD with filters and statistics           | `data`, `domain`, `presentation`, `di` |
| `auth`           | Firebase authentication (login, register, password recovery) | `data`, `domain`, `presentation`, `di` |
| `calendar`       | Agenda view with calendar and activities by date             | `presentation`, `di`                   |
| `categories`     | Activity category management                                 | `data`, `domain`, `presentation`, `di` |
| `course_details` | User course details                                          | `presentation`                         |
| `disciplines`    | Discipline management and selection by academic period       | `data`, `domain`, `presentation`, `di` |
| `home`           | Dashboard with general summary                               | `presentation`                         |
| `notes`          | Note CRUD with rich text editor                              | `data`, `domain`, `presentation`, `di` |
| `not_found`      | 404 screen for invalid routes                                | `presentation`                         |
| `pdf_viewer`     | Built-in PDF viewer                                          | `presentation`                         |
| `schedule`       | Weekly class schedule grid                                   | `data`, `presentation`                 |
| `settings`       | User settings (theme, account deletion)                      | `presentation`                         |
| `splash`         | Initial screen with authentication check                     | `presentation`                         |
| `tags`           | Activity tag management                                      | `data`, `domain`, `presentation`, `di` |
| `teacher`        | Discipline teacher information                               | `data`, `presentation`                 |
| `users`          | User profile and account management                          | `data`, `domain`, `presentation`, `di` |

---

## Widget Organization

Two levels of reuse:

### `shared/widgets/` - Design System

Generic components with no domain knowledge. Used by any feature.

```dart
// Example: standard Design System button
AppButton(
  label: 'Save',
  onPressed: () => viewModel.save(),
)
```

### `features/<feature>/presentation/widgets/` - Semantic Components

Widgets tied to the feature's domain. Can reference feature-specific entities and logic.

```dart
// Example: activity-specific card
ActivityCardWidget(
  activity: activity,
  onTap: () => AppRoutes.goToActivityDetails(context, id: activity.id),
)
```

### Decision rule

| Scenario                                       | Where to place                                                 |
| ---------------------------------------------- | -------------------------------------------------------------- |
| Used by 2+ features                            | `shared/widgets/`                                              |
| Uses entities or logic from a specific feature | `features/<feature>/presentation/widgets/`                     |
| Generic but created for one feature            | `features/<feature>/presentation/widgets/` (can promote later) |
