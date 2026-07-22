<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-3.35.0-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-SDK%20^3.10.4-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Riverpod-3.3.1-08479E?style=for-the-badge" alt="Riverpod">
<img src="https://img.shields.io/badge/Architecture-MVVM%20%2B%20Clean%20%2B%20Feature--First-green?style=for-the-badge" alt="Architecture">
</div>
<br>

<p align="center">
<strong>English</strong> · <a href="README.pt-BR.md">Português (BR)</a> · <a href="README.es.md">Español</a>
</p>

<h1 align="center">Academic Planner</h1>

<p align="center">
Reference project for <strong>MVVM + Clean Architecture + Feature-First</strong> architecture in Flutter.
<br>
<a href="#about-the-project"><strong>Explore the docs »</strong></a>
<br>
<br>
<a href="https://github.com/dariomatias-dev/academic-planner/issues">Report Bug</a>
·
<a href="https://github.com/dariomatias-dev/academic-planner/issues">Request Feature</a>
</p>

## Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Architecture](#architecture)
- [Folder Structure](#folder-structure)
- [Key Technologies](#key-technologies)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
- [Scripts](#scripts)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Author](#author)

## About the Project

Academic Planner is a student routine management application that serves as an **architectural reference project**. The main goal is not just the functionality itself, but to demonstrate how to structure a medium/large Flutter application using:

- **Feature-First**: code organization by business domain
- **Clean Architecture**: separation of concerns into layers with explicit dependency rules
- **MVVM**: decoupling between UI and presentation logic

Every architectural decision is documented with its rationale. The project is intentional: there are no shortcuts that compromise the structure to gain development speed.

## Features

| Feature             | Description                                                                               |
| ------------------- | ----------------------------------------------------------------------------------------- |
| Activities          | Create, edit, and delete academic activities with filters by status, date, and discipline |
| Disciplines         | Manage disciplines by academic period with schedule and teacher details                   |
| Agenda              | Calendar view with activities grouped by date                                             |
| Notes               | Rich text editor for creating notes linked to disciplines                                 |
| Schedule            | Weekly class schedule grid view                                                           |
| Categories and Tags | Organize activities with custom categories and tags                                       |
| Authentication      | Sign in, sign up, and password recovery via Firebase Auth                                 |
| Settings            | Light/dark theme toggle with local persistence                                            |
| About               | App info with version and source code link                                                |

## Architecture

The project combines three complementary approaches:

```
Feature-First  ->  how code is organized into folders
Clean Arch     ->  how layers communicate (dependency rules)
MVVM           ->  how the UI connects to business logic
```

### Why these three?

**Feature-First** solves the organization problem: instead of grouping files by technical type (all models together, all screens together), it groups by business domain. Each feature is an isolated module - changing `activities` does not require opening other feature folders.

**Clean Architecture** solves the dependency problem: it defines explicit rules about which layer can depend on which. The Domain (business rules) is pure Dart, with no external dependencies. The UI never accesses the database directly.

**MVVM** solves the UI coupling problem: the screen never contains logic. The ViewModel manages screen state without depending on `BuildContext` - it is testable in isolation.

Inside each feature:

```text
features/activities/
├── domain/          # Entities and contracts (pure Dart, zero dependencies)
├── data/            # Models, datasources, and repository implementations
├── presentation/    # Screens, ViewModels, Providers, and Widgets
└── di/              # Feature-specific dependency injection
```

Data flow:

```
Screen -> Provider -> ViewModel -> Repository (contract) -> RepositoryImpl -> DataSource
```

> Full documentation with code examples: [docs/en/architecture.md](docs/en/architecture.md)

## Folder Structure

```text
lib/src/
├── core/        # Global infrastructure (database, routes, theme, DI, logging, seeds)
├── features/    # 17 isolated business modules
└── shared/      # Design System and global utilities
```

Existing features: `about`, `activities`, `auth`, `calendar`, `categories`, `course_details`, `disciplines`, `home`, `notes`, `not_found`, `pdf_viewer`, `schedule`, `settings`, `splash`, `tags`, `teacher`, `users`.

> Full annotated folder tree: [docs/en/structure.md](docs/en/structure.md)

## Key Technologies

| Technology       | Version | Role                       |
| ---------------- | ------- | -------------------------- |
| Flutter          | 3.35.0  | UI Framework               |
| Dart SDK         | ^3.10.4 | Language                   |
| flutter_riverpod | 3.3.1   | State management and DI    |
| go_router        | 17.1.0  | Declarative navigation     |
| sqflite          | 2.4.2   | Local persistence (SQLite) |
| firebase_auth    | 6.4.0   | Authentication             |
| cloud_firestore  | 6.3.0   | Cloud backend              |
| flutter_quill    | 11.5.0  | Rich text editor           |

> Full list with exact versions and rationale for each choice: [docs/en/technologies.md](docs/en/technologies.md)

## Screenshots

<div align="center">
<img src="screenshots/01_home.png" width="200" alt="Home"/>
<img src="screenshots/02_agenda.png" width="200" alt="Agenda"/>
<img src="screenshots/03_activities.png" width="200" alt="Activities"/>
<img src="screenshots/04_activity_details.png" width="200" alt="Activity details"/>
<img src="screenshots/05_my_disciplines.png" width="200" alt="My disciplines"/>
<img src="screenshots/06_discipline_details.png" width="200" alt="Discipline details"/>
<img src="screenshots/07_settings.png" width="200" alt="Settings"/>
<img src="screenshots/08_categories.png" width="200" alt="Categories"/>
<img src="screenshots/09_tags.png" width="200" alt="Tags"/>
<img src="screenshots/10_about.png" width="200" alt="About"/>
</div>

## Getting Started

### Prerequisites

- Flutter 3.35.0+
- Dart SDK ^3.10.4
- Firebase project configured (for authentication and Firestore)

### Firebase Setup

The project uses Firebase Authentication (email/password and Google) and Cloud Firestore for user data. With the Firebase project created and connected (see Prerequisites), the following configuration is required in the Firebase Console:

**1. Enable the sign-in providers**

Go to **Authentication → Sign-in method** and enable **Email/Password** and **Google**.

**2. Register the app's SHA-1 fingerprint (required for Google sign-in on Android)**

The Google provider validates the app using its signing certificate fingerprint. Without that fingerprint registered, Google sign-in fails with a generic error, even though the provider is configured as enabled.

1. Get the SHA-1 fingerprint from the debug keystore:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
2. In **Project Settings → your Android app → Add fingerprint**, paste the `SHA1` value.
3. Download the updated `google-services.json` and replace `android/app/google-services.json`.
4. Run `flutter clean && flutter pub get`.

> Before publishing the application, repeat this procedure with the **release** keystore's SHA-1; the debug fingerprint covers local builds only.

**Justification:** until a SHA-1 fingerprint is registered, `google-services.json`'s `oauth_client` array remains empty, and every Google sign-in attempt results in `UnknownFailure`.

### Installation

```bash
# Clone the repository
git clone https://github.com/dariomatias-dev/academic-planner.git

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Development Seeds

Seeds populate the database with sample data for development. Inactive by default, never run in release builds.

```bash
# Run app with seeds on first launch (debug only)
flutter run --dart-define=SEED_ENABLED=true

# Run seeds as a standalone script (no emulator needed)
dart run scripts/seed.dart
```

## Scripts

Utility scripts live under `scripts/`.

| Script       | Command                             | Description                                                                                                                                                       |
| ------------ | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `seed`       | `dart run scripts/seed.dart`        | Populates the database with sample data for local development (see [Development Seeds](#development-seeds)).                                                    |
| `screenshot` | `scripts/screenshot.sh [device-id]` | Drives the app through its main screens on a connected device or emulator and saves a screenshot of each one into `screenshots/`, used for the README. Run `fvm flutter devices` to list available device ids. |

## Documentation

Documentation is organized into separate files by topic for easier navigation:

| Document                                  | What you will find                                                                                                                            |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| [Architecture](docs/en/architecture.md)   | Detailed explanation of MVVM, Clean Architecture, and Feature-First, with code examples from the project itself and rationale for each choice |
| [Project Structure](docs/en/structure.md) | Full annotated folder tree, details of each section, and a table with all existing features                                                   |
| [Navigation](docs/en/navigation.md)       | How the routing system works with GoRouter, complete route reference, and a guide for adding new routes                                       |
| [Technologies](docs/en/technologies.md)   | All dependencies with exact versions (from `pubspec.lock`) and reason for each choice                                                         |

## Contributing

Contributions make the open-source community an amazing place to learn and create. Any contributions you make are greatly appreciated.

Before opening a pull request, see [CONTRIBUTING.md](CONTRIBUTING.md) for the local setup, commit message convention (Conventional Commits), and branching rules this project follows.

## Author

Developed by **Dário Matias**:

- **Portfolio**: [dariomatias-dev](https://dariomatias-dev.com)
- **GitHub**: [dariomatias-dev](https://github.com/dariomatias-dev)
- **Email**: [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com)
- **Instagram**: [@dariomatias_dev](https://instagram.com/dariomatias_dev)
- **LinkedIn**: [linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
