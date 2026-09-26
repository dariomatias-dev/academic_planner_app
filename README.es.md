<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-3.44.9-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter: 3.44.9">
<img src="https://img.shields.io/badge/Dart-SDK%20^3.12.2-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart: SDK ^3.12.2">
<img src="https://img.shields.io/badge/Riverpod-3.4.3-08479E?style=for-the-badge" alt="Riverpod: 3.4.3">
<img src="https://img.shields.io/badge/Arquitectura-MVVM%20%2B%20Clean%20%2B%20Feature--First-green?style=for-the-badge" alt="Arquitectura: MVVM + Clean + Feature-First">
<img src="https://github.com/dariomatias-dev/academic-planner/actions/workflows/ci.yaml/badge.svg?branch=main&style=for-the-badge" alt="CI: status">
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" alt="Licencia: MIT">
</div>
<br>

<p align="center">
<a href="README.md">English</a> · <a href="README.pt-BR.md">Português (BR)</a> · <strong>Español</strong>
</p>

<h1 align="center">Academic Planner</h1>

<p align="center">
Proyecto de referencia para la arquitectura <strong>MVVM + Clean Architecture + Feature-First</strong> en Flutter.
<br>
<a href="#sobre-el-proyecto"><strong>Explora la documentación »</strong></a>
<br>
<br>
<a href="https://github.com/dariomatias-dev/academic-planner/issues">Reportar Error</a>
·
<a href="https://github.com/dariomatias-dev/academic-planner/issues">Solicitar Función</a>
</p>

## Tabla de Contenidos

- [Sobre el Proyecto](#sobre-el-proyecto)
- [Vista Previa](#vista-previa)
- [Funcionalidades](#funcionalidades)
- [Stack Tecnológico](#stack-tecnológico)
- [Arquitectura](#arquitectura)
- [Primeros Pasos](#primeros-pasos)
- [Scripts](#scripts)
- [Tests](#tests)
- [Documentación](#documentación)
- [Contribuir](#contribuir)
- [Seguridad](#seguridad)
- [Licencia](#licencia)
- [Autor](#autor)

## Sobre el Proyecto

Academic Planner es una aplicación de gestión de rutina estudiantil que sirve como **proyecto de referencia arquitectónico**. El objetivo principal no es solo la funcionalidad en sí, sino demostrar cómo estructurar una aplicación Flutter de mediano/gran tamaño utilizando:

- **Feature-First**: organización del código por dominio de negocio
- **Clean Architecture**: separación de responsabilidades en capas con reglas de dependencia explícitas
- **MVVM**: desacoplamiento entre la UI y la lógica de presentación

Cada decisión arquitectónica está documentada con su justificación. El proyecto es intencional: no hay atajos que comprometan la estructura para ganar velocidad de desarrollo.

## Vista Previa

<div align="center">
<img src="screenshots/01_home.png" width="200" alt="Inicio"/>
<img src="screenshots/02_agenda.png" width="200" alt="Agenda"/>
<img src="screenshots/03_activities.png" width="200" alt="Actividades"/>
<img src="screenshots/04_activity_details.png" width="200" alt="Detalles de la actividad"/>
<img src="screenshots/05_my_disciplines.png" width="200" alt="Mis asignaturas"/>
<img src="screenshots/06_discipline_details.png" width="200" alt="Detalles de la asignatura"/>
<img src="screenshots/07_settings.png" width="200" alt="Configuración"/>
<img src="screenshots/08_categories.png" width="200" alt="Categorías"/>
<img src="screenshots/09_tags.png" width="200" alt="Tags"/>
<img src="screenshots/10_about.png" width="200" alt="Acerca de"/>
</div>

## Funcionalidades

| Funcionalidad       | Descripción                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------- |
| Actividades         | Creación, edición y eliminación de actividades académicas con filtros por estado, fecha y asignatura |
| Asignaturas         | Gestión de asignaturas por período académico con horario y detalles del profesor           |
| Agenda              | Vista de calendario con actividades agrupadas por fecha                                     |
| Notas               | Editor de texto enriquecido para crear notas vinculadas a asignaturas                       |
| Horario             | Vista de cuadrícula del horario semanal de clases                                           |
| Categorías y Tags   | Organización de actividades con categorías y tags personalizados                            |
| Autenticación       | Inicio de sesión, registro y recuperación de contraseña vía Firebase Auth                   |
| Configuración       | Alternancia de tema claro/oscuro con persistencia local                                     |
| Acerca de           | Información de la app con versión y enlace al código fuente                                 |

## Stack Tecnológico

| Rol                       | Tecnología                                                |
| ---------------------------- | -------------------------------------------------------------- |
| Framework                 | Flutter 3.44.9, Dart SDK ^3.12.2                          |
| Estado e inyección de dependencias | flutter_riverpod                                      |
| Persistencia local        | sqflite (SQLite), shared_preferences                      |
| Backend y Autenticación   | firebase_auth, google_sign_in, cloud_firestore             |
| Navegación                | go_router                                                  |
| UI enriquecida            | flutter_quill, syncfusion_flutter_calendar, google_fonts   |

> Cada dependencia con su versión exacta resuelta y su rol: [docs/architecture.es.md](docs/architecture.es.md#tecnologías)

## Arquitectura

Feature-First + Clean Architecture + MVVM. Cada feature en `lib/src/features/<feature>/` tiene sus propias capas `domain/` (Dart puro, cero dependencias), `data/`, `presentation/` y `di/`, y ninguna feature importa la `presentation/` de otra:

```
Screen -> Provider -> ViewModel -> Repository (contrato) -> RepositoryImpl -> DataSource
```

> Explicación completa con ejemplos de código, el árbol de carpetas comentado y el sistema de navegación con GoRouter: [docs/architecture.es.md](docs/architecture.es.md)

## Primeros Pasos

### Prerrequisitos

- Flutter 3.44.9+ (fijado vía [fvm](https://fvm.app/), ver `.fvmrc`)
- Dart SDK ^3.12.2
- Proyecto Firebase configurado (para autenticación y Firestore)

### Configuración de Firebase

El proyecto usa Firebase Authentication (email/contraseña y Google) y Cloud Firestore para los datos de usuario. Con el proyecto Firebase creado y conectado (ver Prerrequisitos), se requiere la siguiente configuración en la Consola de Firebase:

**1. Habilitar los proveedores de inicio de sesión**

Ve a **Authentication → Sign-in method** y habilita **Email/contraseña** y **Google**.

**2. Registrar la huella SHA-1 de la app (requerido para el inicio de sesión con Google en Android)**

El proveedor de Google valida la app mediante la huella de su certificado de firma. Sin esa huella registrada, el inicio de sesión con Google falla con un error genérico, aunque el proveedor esté configurado como habilitado.

1. Obtén la huella SHA-1 del keystore de debug:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
2. En **Project Settings → tu app de Android → Add fingerprint**, pega el valor `SHA1`.
3. Descarga el `google-services.json` actualizado y reemplaza `android/app/google-services.json`.
4. Ejecuta `fvm flutter clean && fvm flutter pub get`.

> Antes de publicar la aplicación, repite este procedimiento con la SHA-1 del keystore de **release**; la huella de debug solo cubre las builds locales.

**Justificación:** hasta que se registre una huella SHA-1, el array `oauth_client` de `google-services.json` permanece vacío, y todo intento de inicio de sesión con Google resulta en `UnknownFailure`.

### Instalación

```bash
# Clona el repositorio
git clone https://github.com/dariomatias-dev/academic-planner.git
cd academic-planner

# Instala las dependencias
fvm flutter pub get

# Ejecuta la aplicación
fvm flutter run
```

### Seeds de Desarrollo

Las seeds llenan la base de datos con datos de ejemplo para desarrollo. Inactivas por defecto, nunca se ejecutan en builds de release.

```bash
# Ejecutar la app con seeds en el primer inicio (solo debug)
fvm flutter run --dart-define=SEED_ENABLED=true

# Ejecutar las seeds como script independiente (sin emulador)
dart run scripts/seed.dart
```

## Scripts

Los scripts utilitarios están en `scripts/`.

| Script       | Comando                             | Descripción                                                                                                                                                    |
| ------------ | ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `seed`       | `dart run scripts/seed.dart`        | Llena la base de datos con datos de ejemplo para desarrollo local (ver [Seeds de Desarrollo](#seeds-de-desarrollo)).                                          |
| `screenshot` | `scripts/screenshot.sh [device-id]` | Recorre las principales pantallas de la app en un dispositivo o emulador conectado y guarda una captura de cada una en `screenshots/`, usadas en el README. Ejecuta `fvm flutter devices` para listar los ids de dispositivos disponibles. |
| `check_coverage` | `scripts/check_coverage.sh <lcov-file> <minimum-percent>` | Falla si la cobertura de líneas de un reporte lcov está por debajo del mínimo indicado, excluyendo archivos generados (`*.g.dart`). |
| `verify` | `scripts/verify.sh [--all] [--skip-tests]` | Gate de verificación local que refleja el CI: formato, análisis, tests y el piso de cobertura. Por defecto solo revisa los cambios pendientes; `--all` revisa todo el repositorio y se omite si nada cambió desde la última ejecución exitosa (ver [The local gate](docs/contributing.es.md#el-gate-local)). |
| `workspace_hash` | `scripts/workspace_hash.sh` | Imprime un hash que representa el estado actual del workspace (último commit más cambios pendientes), usado por `verify.sh` para detectar ejecuciones redundantes. |

## Tests

```bash
fvm flutter test              # tests unitarios y de widgets
fvm flutter test --coverage   # con reporte de cobertura lcov
```

`test/` refleja `lib/` ruta a ruta. [test/provider_graph_smoke_test.dart](test/provider_graph_smoke_test.dart) resuelve todos los providers de Riverpod de la app con overrides mínimos, para detectar errores de wiring que el test de un provider aislado no detectaría. `integration_test/` cubre flujos de extremo a extremo y genera las capturas de pantalla de arriba vía `scripts/screenshot.sh`.

```bash
scripts/verify.sh --all
```

ejecuta las mismas verificaciones que el CI — formato, análisis, tests — más un piso de cobertura de líneas del 93% que el CI todavía no aplica.

## Documentación

La documentación está organizada en archivos separados por tema para facilitar la navegación:

| Documento                              | Qué encontrarás                                                                                                                                                                                              |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Arquitectura](docs/architecture.es.md) | MVVM, Clean Architecture y Feature-First con ejemplos de código y justificación; el árbol de carpetas completo; el sistema de navegación con GoRouter y referencia completa de rutas; y cada dependencia con versión exacta y rol |

## Contribuir

Las contribuciones son bienvenidas. Consulta [docs/contributing.es.md](docs/contributing.es.md) para la configuración local, el checklist previo al PR y las convenciones de mensajes de commit y branch de este proyecto:

```bash
scripts/verify.sh --all
```

## Seguridad

¿Encontraste una vulnerabilidad? Por favor no abras un issue público — consulta [docs/security.es.md](docs/security.es.md) para saber cómo reportarla de forma privada.

## Licencia

Distribuido bajo la Licencia MIT. Consulta [LICENSE](LICENSE) para el texto completo.

## Autor

Desarrollado por **Dário Matias**:

- **Portfolio**: [dariomatias-dev](https://dariomatias-dev.com)
- **GitHub**: [dariomatias-dev](https://github.com/dariomatias-dev)
- **Email**: [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com)
- **Instagram**: [@dariomatias_dev](https://instagram.com/dariomatias_dev)
- **LinkedIn**: [linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
