<div align="center">

# Tecnologías

</div>

## Índice

- [Stack Principal](#stack-principal)
- [Estado y DI](#estado-y-di)
- [Persistencia](#persistencia)
- [Autenticación y Backend](#autenticación-y-backend)
- [Navegación](#navegación)
- [UI y Diseño](#ui-y-diseño)
- [Utilidades](#utilidades)
- [Dev y Herramientas](#dev-y-herramientas)

---

## Stack Principal

| Tecnología                      | Versión     | Rol en el proyecto           |
| -------------------------------- | ----------- | ------------------------------ |
| [Flutter](https://flutter.dev/) | 3.35.0      | Framework de UI multiplataforma |
| [Dart](https://dart.dev/)       | SDK ^3.10.4 | Lenguaje de programación        |

---

## Estado y DI

| Paquete                                                        | Versión | Rol en el proyecto                                          |
| --------------------------------------------------------------- | -------- | -------------------------------------------------------------- |
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | 3.3.1   | Gestión de estado reactivo e inyección de dependencias      |
| [riverpod](https://pub.dev/packages/riverpod)                 | 3.2.1   | Core de Riverpod (sin Flutter) - usado en la capa Domain     |

**Por qué Riverpod:** solución compile-safe que unifica gestión de estado y DI. Los providers pueden accederse sin `BuildContext`, sobrescribirse en tests y componerse sin boilerplate. Ver [arquitectura.md - Gestión de Estado con Riverpod](arquitectura.md#gestión-de-estado-con-riverpod).

---

## Persistencia

| Paquete                                                           | Versión | Rol en el proyecto                             |
| -------------------------------------------------------------------- | -------- | -------------------------------------------------- |
| [sqflite](https://pub.dev/packages/sqflite)                       | 2.4.2   | Base de datos SQLite local                       |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 2.5.5   | Persistencia simple de preferencias (tema, flags) |

**Por qué SQLite:** los datos relacionales complejos (actividades, notas, asignaturas) requieren queries, joins y migraciones versionadas - SQLite vía sqflite es la elección natural para Flutter offline-first.

---

## Autenticación y Backend

| Paquete                                                     | Versión | Rol en el proyecto                            |
| -------------------------------------------------------------- | -------- | ------------------------------------------------- |
| [firebase_core](https://pub.dev/packages/firebase_core)     | 4.7.0   | Inicialización de Firebase                       |
| [firebase_auth](https://pub.dev/packages/firebase_auth)     | 6.4.0   | Autenticación de usuarios                        |
| [google_sign_in](https://pub.dev/packages/google_sign_in)   | 6.3.0   | Inicio de sesión con Google (vía Firebase Auth)  |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore) | 6.3.0   | Base de datos en la nube para datos de usuario   |

El proyecto adopta una **arquitectura híbrida de persistencia**: los datos locales (actividades, notas) viven en SQLite; los datos de usuario y autenticación viven en Firebase. Esto garantiza funcionamiento offline para las funcionalidades principales.

**Configuración requerida en Firebase:** el inicio de sesión con Google solo funciona con el proveedor habilitado en Authentication → Sign-in method y la huella SHA-1 de la app registrada en el proyecto. Ver [Configuración de Firebase](../../README.es.md#configuración-de-firebase) en el README.

---

## Navegación

| Paquete                                         | Versión | Rol en el proyecto                     |
| ----------------------------------------------- | -------- | ---------------------------------------- |
| [go_router](https://pub.dev/packages/go_router) | 17.1.0  | Enrutamiento declarativo con Deep Linking |

Ver [navegacion.md](navegacion.md) para la documentación completa del sistema de navegación.

---

## UI y Diseño

| Paquete                                                                               | Versión | Rol en el proyecto           |
| --------------------------------------------------------------------------------------- | -------- | ------------------------------ |
| [google_fonts](https://pub.dev/packages/google_fonts)                                 | 8.0.2   | Tipografía (Google Fonts)     |
| [syncfusion_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar)   | 33.1.46 | Componente de calendario avanzado |
| [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) | 33.1.44 | Visor de PDF integrado         |
| [carousel_slider](https://pub.dev/packages/carousel_slider)                           | 5.1.2   | Carrusel de imágenes/cards     |
| [flutter_quill](https://pub.dev/packages/flutter_quill)                               | 11.5.0  | Editor de texto enriquecido para notas |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)                           | 1.0.8   | Íconos estilo iOS              |

---

## Utilidades

| Paquete                                                                       | Versión | Rol en el proyecto                                  |
| ---------------------------------------------------------------------------------- | -------- | ------------------------------------------------------ |
| [intl](https://pub.dev/packages/intl)                                         | 0.20.2  | Formateo de fechas, números e internacionalización   |
| [uuid](https://pub.dev/packages/uuid)                                         | 4.5.3   | Generación de identificadores únicos                  |
| [url_launcher](https://pub.dev/packages/url_launcher)                         | 6.3.2   | Apertura de URLs externas                              |
| [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) | 4.0.1   | Exportación de imágenes a la galería                   |
| [package_info_plus](https://pub.dev/packages/package_info_plus)               | 9.0.1   | Lectura de información del paquete (versión de la app) |
| [fluttertoast](https://pub.dev/packages/fluttertoast)                         | 9.0.0   | Notificaciones toast nativas                            |
| [logger](https://pub.dev/packages/logger)                                     | 2.7.0   | Logging estructurado con niveles                        |

---

## Dev y Herramientas

| Paquete                                                                   | Versión | Rol en el proyecto                                        |
| ------------------------------------------------------------------------------ | -------- | -------------------------------------------------------------- |
| [flutter_lints](https://pub.dev/packages/flutter_lints)                   | 6.0.0   | Reglas de lint recomendadas para Flutter                    |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | 0.14.4  | Generación de íconos de la app para todas las plataformas   |
| [flutter_localizations](https://flutter.dev/)                             | SDK     | Soporte de localización e internacionalización               |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)         | 2.3.7+1 | Driver SQLite vía FFI para correr scripts de seed en desktop |

---

## Sobre las Versiones

Las versiones listadas son las **resueltas en `pubspec.lock`** - versiones exactas en uso, no los rangos de `pubspec.yaml`. Para actualizar:

```bash
# Ver dependencias desactualizadas
flutter pub outdated

# Actualizar dentro de los rangos definidos
flutter pub upgrade

# Actualizar a nuevas versiones major (atención a breaking changes)
flutter pub upgrade --major-versions
```
