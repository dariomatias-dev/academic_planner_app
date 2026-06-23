<div align="center">

# Technologies

</div>

## Table of Contents

- [Core Stack](#core-stack)
- [State Management and DI](#state-management-and-di)
- [Persistence](#persistence)
- [Authentication and Backend](#authentication-and-backend)
- [Navigation](#navigation)
- [UI and Design](#ui-and-design)
- [Utilities](#utilities)
- [Dev and Tooling](#dev-and-tooling)

---

## Core Stack

| Technology                      | Version     | Role in the project         |
| ------------------------------- | ----------- | --------------------------- |
| [Flutter](https://flutter.dev/) | 3.35.0      | Cross-platform UI framework |
| [Dart](https://dart.dev/)       | SDK ^3.10.4 | Programming language        |

---

## State Management and DI

| Package                                                       | Version | Role in the project                                    |
| ------------------------------------------------------------- | ------- | ------------------------------------------------------ |
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | 3.3.1   | Reactive state management and dependency injection     |
| [riverpod](https://pub.dev/packages/riverpod)                 | 3.2.1   | Riverpod core (without Flutter) - used in Domain layer |

**Why Riverpod:** compile-safe solution that unifies state management and DI. Providers can be accessed without `BuildContext`, overridden in tests, and composed without boilerplate. See [architecture.md - State Management with Riverpod](architecture.md#state-management-with-riverpod).

---

## Persistence

| Package                                                           | Version | Role in the project                          |
| ----------------------------------------------------------------- | ------- | -------------------------------------------- |
| [sqflite](https://pub.dev/packages/sqflite)                       | 2.4.2   | Local SQLite database                        |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 2.5.5   | Simple preference persistence (theme, flags) |

**Why SQLite:** complex relational data (activities, notes, disciplines) requires queries, joins, and versioned migrations - SQLite via sqflite is the natural choice for offline-first Flutter.

---

## Authentication and Backend

| Package                                                     | Version | Role in the project                        |
| ----------------------------------------------------------- | ------- | ------------------------------------------ |
| [firebase_core](https://pub.dev/packages/firebase_core)     | 4.7.0   | Firebase initialization                    |
| [firebase_auth](https://pub.dev/packages/firebase_auth)     | 6.4.0   | User authentication                        |
| [google_sign_in](https://pub.dev/packages/google_sign_in)   | 6.3.0   | Google account sign-in (via Firebase Auth) |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore) | 6.3.0   | Cloud database for user data               |

The project adopts a **hybrid persistence architecture**: local data (activities, notes) lives in SQLite; user data and authentication live in Firebase. This ensures offline functionality for the core features.

**Required Firebase configuration:** Google sign-in only works once the provider is enabled in Authentication → Sign-in method and the app's SHA-1 fingerprint is registered on the project. See [Firebase Setup](../../README.md#firebase-setup) in the README.

---

## Navigation

| Package                                         | Version | Role in the project                   |
| ----------------------------------------------- | ------- | ------------------------------------- |
| [go_router](https://pub.dev/packages/go_router) | 17.1.0  | Declarative routing with Deep Linking |

See [navigation.md](navigation.md) for complete navigation system documentation.

---

## UI and Design

| Package                                                                               | Version | Role in the project         |
| ------------------------------------------------------------------------------------- | ------- | --------------------------- |
| [google_fonts](https://pub.dev/packages/google_fonts)                                 | 8.0.2   | Typography (Google Fonts)   |
| [syncfusion_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar)   | 33.1.46 | Advanced calendar component |
| [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) | 33.1.44 | Built-in PDF viewer         |
| [carousel_slider](https://pub.dev/packages/carousel_slider)                           | 5.1.2   | Image/card carousel         |
| [flutter_quill](https://pub.dev/packages/flutter_quill)                               | 11.5.0  | Rich text editor for notes  |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)                           | 1.0.8   | iOS-style icons             |

---

## Utilities

| Package                                                                       | Version | Role in the project                              |
| ----------------------------------------------------------------------------- | ------- | ------------------------------------------------ |
| [intl](https://pub.dev/packages/intl)                                         | 0.20.2  | Date, number formatting and internationalization |
| [uuid](https://pub.dev/packages/uuid)                                         | 4.5.3   | Unique identifier generation                     |
| [url_launcher](https://pub.dev/packages/url_launcher)                         | 6.3.2   | Opening external URLs                            |
| [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) | 4.0.1   | Exporting images to the gallery                  |
| [package_info_plus](https://pub.dev/packages/package_info_plus)               | 9.0.1   | Reading package info (app version)               |
| [fluttertoast](https://pub.dev/packages/fluttertoast)                         | 9.0.0   | Native toast notifications                       |
| [logger](https://pub.dev/packages/logger)                                     | 2.7.0   | Structured logging with levels                   |

---

## Dev and Tooling

| Package                                                                   | Version | Role in the project                                   |
| ------------------------------------------------------------------------- | ------- | ----------------------------------------------------- |
| [flutter_lints](https://pub.dev/packages/flutter_lints)                   | 6.0.0   | Recommended Flutter lint rules                        |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | 0.14.4  | App icon generation for all platforms                 |
| [flutter_localizations](https://flutter.dev/)                             | SDK     | Localization and internationalization support         |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)         | 2.3.7+1 | SQLite FFI driver for running seed scripts on desktop |

---

## About the Versions

The versions listed are the **resolved versions from `pubspec.lock`** - exact versions in use, not the ranges from `pubspec.yaml`. To update:

```bash
# View outdated dependencies
flutter pub outdated

# Update within defined ranges
flutter pub upgrade

# Update to new major versions (watch for breaking changes)
flutter pub upgrade --major-versions
```
