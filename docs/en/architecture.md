<div align="center">

# Project Architecture

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
- [Core Layer](#core-layer)
- [State Management with Riverpod](#state-management-with-riverpod)

---

## Overview

The project combines three complementary approaches to organize code in a scalable, testable, and maintainable way:

| Approach               | Responsibility                                  |
| ---------------------- | ----------------------------------------------- |
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
| ------------------------------------------ | ----------------------------------------------- |
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
data/data_source/activity_local_datasource.dart  -> SQLite access
```

Presentation only knows `ActivityRepository` (contract). The DI system decides which implementation to inject - the UI does not know whether data comes from SQLite, an API, or memory.

---

## MVVM

> MVVM is the pattern recommended by Flutter itself for application architecture. See: [Flutter App Architecture Guide](https://docs.flutter.dev/app-architecture/guide).

### What it is

MVVM (Model-View-ViewModel) is a **presentation pattern** that separates:

| Layer             | Responsibility                                       |
| ----------------- | ---------------------------------------------------- |
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
class ActivityNotifier extends AsyncNotifier<List<ActivityEntity>> {
  late final ActivityViewModel _viewModel;

  @override
  Future<List<ActivityEntity>> build() async {
    _viewModel = ActivityViewModel(ref.read(activityRepositoryProvider));
    return _viewModel.loadActivities();
  }

  Future<void> create(ActivityEntity activity) async {
    await _viewModel.createActivity(activity);
    ref.invalidateSelf();
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
| ---------------- | ------------------------------------------------------ |
| `entities/`      | Represent business truth (e.g. `ActivityEntity`)       |
| `repositories/`  | Contracts (abstract interfaces) for data access        |
| `value_objects/` | Types with built-in validation (e.g. `ActivityFilter`) |

**Rule:** no Domain file imports from the Data or Presentation layer.

### Data

Responsible for providing and persisting data.

| Folder          | Content                                             |
| --------------- | --------------------------------------------------- |
| `models/`       | DTOs with mapping logic (`fromMap`, `toMap`)        |
| `data_source/`  | Direct access to the data source (SQLite, Firebase) |
| `repositories/` | Implementations of the contracts defined in Domain  |

**Models** convert between the database/API format and Domain **Entities**. The Presentation layer never uses Models - only Entities.

### Presentation

The UI and user interaction layer.

| Folder         | Content                                             |
| -------------- | --------------------------------------------------- |
| `screens/`     | Screen widgets that build the UI and observe state  |
| `view_models/` | Pure presentation logic, no `BuildContext`          |
| `providers/`   | Riverpod Notifiers that expose state reactively     |
| `widgets/`     | Visual components specific to the feature           |
| `actions/`     | Multi-step UI flows (e.g. delete with confirmation) |

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

## Core Layer

The `core/` folder concentrates **cross-cutting** infrastructure shared by all features. It is not a feature - it is application infrastructure.

| Folder        | Responsibility                                                  |
| ------------- | --------------------------------------------------------------- |
| `constants/`  | Static data and global mocks                                    |
| `database/`   | SQLite configuration, tables, and migrations                    |
| `di/`         | Global DI providers (database, theme, navigation, Firebase)     |
| `domain/`     | Entities shared across features (e.g. `Pagination`)             |
| `extensions/` | Utility extensions for Dart/Flutter types                       |
| `logging/`    | Centralized logging service                                     |
| `notifiers/`  | Global notifiers (app version, navigation)                      |
| `result/`     | `Result<T>` and `Failure` pattern for functional error handling |
| `routes/`     | Centralized navigation system (GoRouter)                        |
| `services/`   | Reusable infrastructure services                                |
| `theme/`      | Light/dark theme configuration and persistence                  |

---

## State Management with Riverpod

**Riverpod** is the state management and dependency injection solution for the project.

### Why Riverpod

- **Compile-safe:** provider errors are caught at compile time.
- **No `BuildContext`:** providers can be accessed outside the widget tree.
- **Integrated DI:** the same system serves reactive state and dependency injection.
- **Testable:** providers can be overridden in tests without extra configuration.

### Provider types used

| Provider                | Usage                                             |
| ----------------------- | ------------------------------------------------- |
| `Provider`              | Immutable dependencies (repositories, services)   |
| `AsyncNotifierProvider` | Async state with lifecycle (lists, database data) |
| `NotifierProvider`      | Sync state with logic (filters, forms)            |
| `StreamProvider`        | Real-time reactive data (Firebase)                |

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
