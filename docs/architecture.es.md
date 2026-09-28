<div align="center">

# Arquitectura

</div>

## Índice

- [Visión General](#visión-general)
- [Feature-First](#feature-first)
- [Clean Architecture](#clean-architecture)
- [MVVM](#mvvm)
- [Cómo se combinan las tres](#cómo-se-combinan-las-tres)
- [Capas por Feature](#capas-por-feature)
- [Reglas de Dependencia](#reglas-de-dependencia)
- [Flujo de Datos](#flujo-de-datos)
- [Gestión de Estado con Riverpod](#gestión-de-estado-con-riverpod)
- [Árbol de Carpetas](#árbol-de-carpetas)
- [Capa Core](#capa-core)
- [Capa Shared](#capa-shared)
- [Features Existentes](#features-existentes)
- [Organización de Widgets](#organización-de-widgets)
- [Seeds](#seeds)
- [Sistema de Navegación](#sistema-de-navegación)
- [Tecnologías](#tecnologías)

---

## Visión General

El proyecto combina tres enfoques complementarios para organizar el código de forma escalable, testeable y fácil de mantener:

| Enfoque                 | Responsabilidad                                    |
| ------------------------- | ----------------------------------------------------- |
| **Feature-First**       | Cómo se organiza el código en carpetas             |
| **Clean Architecture**  | Cómo se comunican y dependen entre sí las capas    |
| **MVVM**                | Cómo se conecta la UI con la lógica de negocio     |

Cada uno resuelve un problema diferente. Juntos forman una base sólida para el crecimiento de la aplicación sin acumular deuda técnica.

---

## Feature-First

### Qué es

Feature-First es una estrategia de **organización de carpetas** donde cada funcionalidad del producto está aislada en su propio módulo. En lugar de agrupar archivos por tipo técnico (todos los models juntos, todas las pantallas juntas), se agrupa por dominio de negocio.

```text
features/
├── activities/    # todo lo relacionado con actividades
├── disciplines/   # todo lo relacionado con asignaturas
├── notes/         # todo lo relacionado con notas
└── auth/          # todo lo relacionado con autenticación
```

### Por qué se eligió

- **Cohesión:** todo el código de una funcionalidad queda junto. Para entender o cambiar `activities`, navegas a `features/activities/` - sin buscar archivos dispersos.
- **Escalabilidad:** agregar una nueva feature no afecta a las existentes.
- **Aislamiento:** una feature puede eliminarse o refactorizarse sin efectos secundarios en otras.
- **Onboarding:** un nuevo desarrollador entiende el dominio con solo leer el árbol de carpetas.

### Comparación con Layer-First

| Layer-First (convencional)                 | Feature-First (adoptado)                         |
| -------------------------------------------- | ---------------------------------------------------- |
| `models/activity.dart`, `models/note.dart` | `activities/data/models/`, `notes/data/models/` |
| Fácil entender la estructura técnica       | Fácil entender el dominio del producto            |
| Mala escalabilidad                         | Buena escalabilidad                               |
| Los cambios cruzan muchas carpetas         | Los cambios quedan dentro de la feature           |

---

## Clean Architecture

### Qué es

Clean Architecture es un conjunto de **reglas de dependencia entre capas** creado por Robert C. Martin (Uncle Bob). El objetivo es separar las reglas de negocio de los detalles de infraestructura (base de datos, UI, frameworks).

```text
┌─────────────────────────────┐
│        Presentation         │  ← UI, ViewModels, Providers
├─────────────────────────────┤
│           Domain            │  ← Entidades, Contratos (Dart puro)
├─────────────────────────────┤
│            Data             │  ← Models, Services, Repositorios (impl.)
└─────────────────────────────┘
```

La regla central: **las dependencias apuntan hacia adentro**. La capa exterior (Presentation, Data) depende de la interior (Domain). Domain no depende de nadie.

### Por qué se eligió

- **Independencia de framework:** las reglas de negocio en Domain son Dart puro - sin Flutter, SQLite ni Riverpod.
- **Testeabilidad:** Domain puede probarse sin base de datos ni widgets.
- **Reemplazabilidad:** cambiar SQLite por otra persistencia solo requiere modificar la capa Data.
- **Protección del negocio:** la UI nunca accede directamente a la base de datos.

### Ejemplo práctico

```
domain/repositories/activity_repository.dart     → contrato (interfaz)
data/repositories/activity_repository_impl.dart  → implementación
data/datasources/activity_local_datasource.dart  → acceso a SQLite
```

Presentation solo conoce `ActivityRepository` (contrato). El sistema de DI decide qué implementación inyectar - la UI no sabe si los datos vienen de SQLite, una API o memoria.

---

## MVVM

> MVVM es el patrón recomendado por el propio Flutter para la arquitectura de aplicaciones. Ver: [Flutter App Architecture Guide](https://docs.flutter.dev/app-architecture/guide).

### Qué es

MVVM (Model-View-ViewModel) es un **patrón de presentación** que separa:

| Capa               | Responsabilidad                                       |
| -------------------- | -------------------------------------------------------- |
| **View** (Screen)  | Renderiza la UI y captura eventos del usuario          |
| **ViewModel**      | Contiene la lógica de presentación y gestiona el estado de la pantalla |
| **Model**          | Datos y reglas de negocio (Domain + Data)              |

### Por qué se eligió

- **Sin lógica en la View:** la pantalla solo observa el estado y dispara acciones - nunca decide nada.
- **ViewModel testeable:** al no depender de `BuildContext` ni de widgets, puede probarse con tests unitarios puros.
- **Separación clara:** la lógica de "qué mostrar" vive en el ViewModel; la de "cómo mostrarlo" vive en la View.

### Implementación con Riverpod

En este proyecto el ViewModel es una clase Dart pura. El `Notifier` de Riverpod actúa como adaptador que expone el estado del ViewModel de forma reactiva:

```dart
// ViewModel - lógica pura, sin Flutter
class ActivityViewModel {
  Future<void> createActivity(ActivityEntity activity) async { ... }
}

// Notifier - puente entre el ViewModel y la UI
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

Esta separación garantiza que el ViewModel pueda probarse sin simular el entorno reactivo de Riverpod.

---

## Cómo se combinan las tres

```text
Feature-First  → dónde vive el código (carpetas)
Clean Arch     → cómo se comunican las capas (reglas)
MVVM           → cómo se conectan UI y lógica (patrón)
```

Dentro de cada feature, Clean Architecture define las capas (`domain/`, `data/`, `presentation/`). Dentro de `presentation/`, MVVM define cómo se relacionan Screen, ViewModel y Notifier.

---

## Capas por Feature

### Domain

Capa central. Contiene solo código **Dart puro** - cero dependencia de Flutter o paquetes externos.

| Carpeta           | Contenido                                                |
| ------------------- | ----------------------------------------------------------- |
| `entities/`      | Representan la verdad del negocio (ej: `Activity`)        |
| `repositories/`  | Contratos (interfaces abstractas) de acceso a datos      |
| `value_objects/` | Tipos con validación incorporada (ej: `ActivityFilter`)   |

**Regla:** ningún archivo de Domain importa de la capa Data o Presentation.

### Data

Responsable de proveer y persistir los datos.

| Carpeta          | Contenido                                            |
| ------------------- | -------------------------------------------------------- |
| `models/`       | DTOs con lógica de mapeo (`fromMap`, `toMap`)         |
| `datasources/`  | Acceso directo a la fuente de datos (SQLite, Firebase) |
| `repositories/` | Implementaciones de los contratos definidos en Domain  |

Los **Models** convierten entre el formato de base de datos/API y las **Entities** de Domain. La capa Presentation nunca usa Models - solo Entities.

### Presentation

Capa de interfaz e interacción con el usuario.

| Carpeta         | Contenido                                                   |
| ------------------ | ---------------------------------------------------------------- |
| `screens/`     | Widgets de pantalla que construyen la UI y observan el estado |
| `view_models/` | Lógica de presentación pura, sin `BuildContext`               |
| `providers/`   | Notifiers de Riverpod que exponen estado reactivamente        |
| `widgets/`     | Componentes visuales específicos de la feature                |
| `actions/`     | Flujos de UI con varios pasos (ej: eliminar con confirmación) |

No todas las features tienen todas las capas o carpetas - solo las que tienen contenido. Ver [Features Existentes](#features-existentes).

---

## Reglas de Dependencia

```text
Presentation ──→ Domain ←── Data
```

1. **Domain no depende de nadie.** Es el núcleo protegido.
2. **Presentation depende de Domain** (contratos), nunca de Data (implementaciones).
3. **Data depende de Domain** para implementar los contratos.
4. **La capa DI (`di/`)** resuelve qué implementación concreta inyectar en tiempo de ejecución.

Violar estas reglas introduce acoplamiento que dificulta los tests y el reemplazo de implementaciones.

---

## Flujo de Datos

```text
View (Screen)
  ↓ dispara una acción (ej: botón guardar)
Provider (Notifier)
  ↓ delega a
ViewModel
  ↓ llama al contrato
Repository (Domain - interfaz)
  ↓ implementado por
RepositoryImpl (Data)
  ↓ usa
DataSource / Service (SQLite, Firebase)
```

El flujo inverso (datos llegando a la UI) es reactivo vía Riverpod: el Notifier notifica a la View cuando el estado cambia.

---

## Gestión de Estado con Riverpod

**Riverpod** es la solución de gestión de estado e inyección de dependencias del proyecto.

### Por qué Riverpod

- **Compile-safe:** los errores de provider se detectan en tiempo de compilación.
- **Sin `BuildContext`:** los providers pueden accederse fuera del árbol de widgets.
- **DI integrada:** el mismo sistema sirve para estado reactivo e inyección de dependencias.
- **Testeable:** los providers pueden sobrescribirse en tests sin configuración extra (ver [provider_graph_smoke_test.dart](../test/provider_graph_smoke_test.dart), que sobrescribe todas las dependencias externas a la vez).

### Tipos de providers utilizados

| Provider                | Uso                                                            |
| ------------------------- | ------------------------------------------------------------------ |
| `Provider`              | Dependencias inmutables (repositorios, servicios, datasources) |
| `AsyncNotifierProvider` | Estado asíncrono con ciclo de vida (listas, datos de BD/Firestore) |
| `NotifierProvider`      | Estado síncrono con lógica (filtros, tema, formularios)        |
| `FutureProvider`        | Lecturas asíncronas puntuales o derivadas, incluyendo `.family` |

### Estructura de providers por feature

```text
features/activities/
├── di/
│   └── activity_providers.dart   ← providers de DI (repositorio, datasource)
└── presentation/
    └── providers/
        ├── activity_notifier.dart         ← estado principal de la lista
        ├── activity_filter_notifier.dart  ← estado del filtro
        └── activity_stats_notifier.dart   ← estado de las estadísticas
```

Separar `di/` de `presentation/providers/` mantiene los providers de infraestructura (DI) aislados de los providers de UI (estado).

---

## Árbol de Carpetas

```text
lib/
├── main.dart                        # Punto de entrada de la aplicación
├── firebase_options.dart            # Configuración generada de Firebase
└── src/
    ├── academic_planner_app.dart    # Widget raíz (MaterialApp + tema + router)
    │
    ├── core/                        # Infraestructura global y transversal — ver Capa Core
    │
    ├── features/                    # Módulos de negocio aislados
    │   └── <feature>/               # Ver Features Existentes
    │       ├── data/
    │       │   ├── datasources/     # Acceso directo a base de datos/API
    │       │   ├── models/          # DTOs con fromMap/toMap
    │       │   ├── repositories/    # Implementación de los contratos de Domain
    │       │   └── seeds/           # Seeds de dev específicas de la feature (opcional)
    │       ├── di/                  # Providers de DI específicos de la feature
    │       ├── domain/
    │       │   ├── entities/        # Entidades puras del dominio
    │       │   ├── repositories/    # Contratos (interfaces abstractas)
    │       │   └── value_objects/   # Tipos con validación incorporada
    │       └── presentation/
    │           ├── actions/         # Flujos de UI con varios pasos
    │           ├── providers/       # Notifiers de estado
    │           ├── screens/         # Pantallas y sus widgets internos
    │           ├── view_models/     # Lógica de presentación pura
    │           └── widgets/         # Componentes visuales de la feature
    │
    └── shared/                      # Recursos globales reutilizables — ver Capa Shared
```

---

## Capa Core

La carpeta `core/` concentra código **transversal** compartido por todas las features. No es una feature - es infraestructura de la aplicación.

```text
core/
├── constants/                   # Datos estáticos y catálogo del curso
│   ├── disciplines/             # Datos de asignaturas por período
│   ├── day_names.dart
│   ├── schedules.dart
│   └── teachers.dart
│
├── database/                    # Persistencia SQLite
│   ├── app_database.dart        # Configuración central de la base de datos
│   ├── migrations/              # Migraciones versionadas del schema (migration_v1.dart, ...)
│   └── tables/                  # Definiciones de tablas
│
├── di/                          # Providers globales de inyección de dependencias
│   ├── app_version_provider.dart
│   ├── database_provider.dart
│   ├── firebase_providers.dart
│   ├── shared_preferences_provider.dart
│   └── theme_provider.dart
│
├── domain/entities/             # Entidades compartidas entre features (Pagination, Discipline, ScheduleEntry)
│
├── errors/                      # Patrón Result<T>/Failure + la frontera global de errores (ver abajo)
│
├── extensions/                  # Extensiones de tipos Dart/Flutter
│
├── logging/app_logger.dart          # Logging centralizado (ver abajo)
│
├── notifiers/app_version_notifier.dart
│
├── routes/                      # Sistema de navegación (GoRouter) — ver Sistema de Navegación
│   └── root_navigation.dart     # Widget raíz de navegación con bottom nav
│
├── seeds/                       # Infraestructura base de seeds (ver Seeds)
│
├── services/                    # Servicios de infraestructura reutilizables
│   └── shared_preferences_keys.dart # Claves de persistencia local
│
├── theme/                       # Configuración de tema claro/oscuro y persistencia
│   └── app_colors.dart          # Paleta de colores global
│
└── validators/validators.dart   # Validadores reutilizables de formulario
```

**`core/errors/`** - implementación del patrón `Result<T>`:

```dart
Result<List<Activity>> result = await repository.getAll();

switch (result) {
  case Success(:final value) => state = value,
  case Failure(:final failure) => handleError(failure),
}
```

La misma carpeta también arma la frontera global de errores de la app, vía `configureErrorBoundary` (llamado una vez desde `main()`): `FlutterError.onError` y `PlatformDispatcher.instance.onError` reenvían ambos a un `ErrorReporter` — un contrato con una única implementación hoy, `LoggingErrorReporter`, para que un backend real de crash reporting pueda conectarse después sin tocar quien lo llama. Solo en builds de release, `ErrorWidget.builder` también se reemplaza por `ErrorStateWidget` en lugar de la pantalla roja de error por defecto de Flutter, que se mantiene en debug, donde es útil.

**`core/database/`** - SQLite con sistema de migraciones versionado:

```dart
class MigrationV2 implements Migration {
  @override
  Future<void> up(Database db) async {
    await db.execute(NoteTable.createTableQuery);
  }
}
```

**`core/logging/app_logger.dart`** - único punto de logging: todo archivo que loguea crea su propio `AppLogger('feature.ClassName')` y lo usa. `package:logger` es un detalle de implementación usado solo dentro de este archivo, para la salida bonita en consola — ningún otro archivo lo importa.

---

## Capa Shared

Componentes sin conocimiento del dominio de negocio. Cualquier feature puede usarlos.

```text
shared/
├── models/    # Models compartidos entre features
├── screens/   # Pantallas sin feature dueña (about, splash, not_found, pdf_viewer)
├── utils/     # Funciones puras sin UI
└── widgets/   # Design System - componentes genéricos (buttons, dialogs, forms, inputs, states, ...)
```

- **`shared/widgets/`**: Design System - botones, inputs, diálogos, estados vacíos, tab bars.
- **`shared/utils/`**: Funciones puras sin UI.
- **`shared/models/`**: Models reutilizados entre varias features.
- **`shared/screens/`**: Pantallas que no pertenecen a ninguna feature de negocio (`about`, `splash`, `not_found`, `pdf_viewer`). Quedan fuera de `features/` para no simular un dominio que no existe; las subcarpetas `widgets/` aquí siguen la misma convención de descomposición local de pantalla usada en `features/<feature>/presentation/screens/<pantalla>/widgets/`.

---

## Features Existentes

| Feature          | Descripción                                                    | Capas                                  |
| ------------------ | ------------------------------------------------------------------ | ------------------------------------------ |
| `activities`     | CRUD de actividades académicas con filtros y estadísticas       | `data`, `domain`, `presentation`, `di` |
| `auth`           | Autenticación con Firebase (login, registro, recuperación de contraseña) | `data`, `domain`, `presentation`, `di` |
| `calendar`       | Vista de agenda con calendario y actividades por fecha           | `presentation`, `di`                   |
| `categories`     | Gestión de categorías de actividades                            | `data`, `domain`, `presentation`, `di` |
| `course_details` | Detalles del curso del usuario                                   | `presentation`                         |
| `disciplines`    | Gestión de asignaturas y selección por período académico         | `data`, `domain`, `presentation`, `di` |
| `home`           | Dashboard con resumen general                                    | `presentation`                         |
| `notes`          | CRUD de notas con editor de texto rico                            | `data`, `domain`, `presentation`, `di` |
| `schedule`       | Grilla semanal de horario de clases                               | `data`, `presentation`                 |
| `settings`       | Configuración del usuario (tema, eliminación de cuenta)           | `presentation`                         |
| `tags`           | Gestión de etiquetas de actividades                               | `data`, `domain`, `presentation`, `di` |
| `teacher`        | Información de los profesores de las asignaturas                  | `data`, `presentation`                 |
| `users`          | Perfil de usuario y gestión de cuentas                             | `data`, `domain`, `presentation`, `di` |

Las pantallas sin feature dueña (`about`, `splash`, `not_found`, `pdf_viewer`) viven en `shared/screens/` - ver [Capa Shared](#capa-shared).

---

## Organización de Widgets

Dos niveles de reutilización:

### `shared/widgets/` - Design System

Componentes genéricos sin conocimiento del dominio. Usados por cualquier feature.

```dart
AppButton(
  label: 'Guardar',
  onPressed: () => viewModel.save(),
)
```

### `features/<feature>/presentation/widgets/` - Componentes Semánticos

Widgets ligados al dominio de la feature. Pueden referenciar entidades y lógica específicas.

```dart
ActivityCardWidget(
  activity: activity,
  onTap: () => AppRoutes.goToActivityDetails(context, activityId: activity.id),
)
```

### Regla de decisión

| Escenario                                        | Dónde ubicarlo                                                    |
| --------------------------------------------------- | ------------------------------------------------------------------- |
| Usado por 2+ features                             | `shared/widgets/`                                                 |
| Usa entidades o lógica de una feature específica  | `features/<feature>/presentation/widgets/`                        |
| Es genérico pero se creó para una feature         | `features/<feature>/presentation/widgets/` (se puede promover después) |

---

## Seeds

Las seeds viven en dos lugares: infraestructura base en `core/seeds/` y datos específicos en `features/<feature>/data/seeds/`.

Las seeds **nunca se ejecutan en producción** (bloqueado por `kDebugMode`) y están **inactivas por defecto en debug** también. Doble protección:

```dart
// core/seeds/seed_initializer.dart
const _seedEnabled = bool.fromEnvironment('SEED_ENABLED', defaultValue: false);

Future<void> runDevSeeds(Database db) async {
  if (!kDebugMode || !_seedEnabled) return;
  // ...
}
```

| Caso de uso                              | Comando                                       |
| ------------------------------------------- | ------------------------------------------------ |
| Ejecutar la app con seeds en el primer inicio | `flutter run --dart-define=SEED_ENABLED=true` |
| Ejecutar seeds standalone (sin emulador)   | `dart run scripts/seed.dart`                  |
| Dev normal / release                       | las seeds nunca se ejecutan                    |

---

## Sistema de Navegación

La navegación fue diseñada para ser **desacoplada, tipada y centralizada**. La UI nunca navega directamente con strings o URLs - usa métodos semánticos que encapsulan todos los detalles de enrutamiento.

```text
UI → AppRoutes → GoRouter → Screen
```

Este flujo garantiza que un cambio de ruta (nombre, path, parámetros) impacte solo los archivos de navegación, no las pantallas.

### Por qué GoRouter

- Navegación declarativa y centralizada (rutas definidas en un solo lugar)
- Integración con Navigator 2.0 y soporte nativo de Deep Linking
- Soporte de path parameters y query parameters
- Navegación por nombre con `pushNamed`/`goNamed` - sin strings literales dispersos
- Manejo de errores integrado (pantalla 404)
- Escala bien para aplicaciones grandes

### Estructura de Archivos

```text
core/routes/
├── app_router.dart    # Configuración central de GoRouter y árbol de rutas
├── app_routes.dart    # Métodos semánticos de navegación (capa de abstracción)
├── route_names.dart   # Identificadores únicos de las rutas
└── route_paths.dart   # Paths (URLs) de las rutas
```

`route_names.dart` y `route_paths.dart` centralizan identificadores y URLs, evitando strings literales dispersos por el código:

```dart
// route_names.dart
static const disciplineDetails = 'discipline_details';

// route_paths.dart
static const disciplineDetails = '/discipline-details/:disciplineId';
```

`app_router.dart` expone el `GoRouter` como un provider de Riverpod (`routerProvider`), con el árbol de rutas, el manejo de errores y una redirección de autenticación centralizada: los usuarios sin sesión son enviados a `login` desde cualquier ruta protegida, y los usuarios con sesión en `login`/`register`/`forgot-password` son enviados a `home`. La decisión en sí vive en la función pura `resolveAuthRedirect`, y el router la reevalúa cuando cambia el estado de auth (ej: tras cerrar sesión), no solo al navegar. `home`, `myDisciplines`, `activities` y `settings` son pestañas de un `StatefulShellRoute` (la bottom navigation bar), a las que no se accede vía `AppRoutes`.

`app_routes.dart` es la capa de abstracción que encapsula toda la navegación. **La UI solo llama métodos de aquí:**

```dart
static Future<void> goToDisciplineDetails(
  BuildContext context, {
  required int disciplineId,
  int? tab,
}) async {
  await context.pushNamed(
    RouteNames.disciplineDetails,
    pathParameters: <String, String>{'disciplineId': disciplineId.toString()},
    queryParameters: <String, String>{if (tab != null) 'tab': tab.toString()},
  );
}
```

**Beneficios:** parámetros tipados (el compilador detecta errores antes del runtime), un único punto para cambiar el comportamiento de cualquier navegación, y la UI nunca conoce nombres de rutas, paths ni cómo pasar parámetros.

### Referencia de Rutas

| Nombre                | Path                                | Método en AppRoutes     | Parámetros                                    |
| ------------------------ | -------------------------------------- | -------------------------- | ------------------------------------------------ |
| `home`                | `/home`                             | pestaña del bottom nav    | -                                              |
| `myDisciplines`       | `/my-disciplines`                   | pestaña del bottom nav    | -                                              |
| `activities`          | `/activities`                       | pestaña del bottom nav / `goToActivities` | -                                |
| `settings`            | `/settings`                         | pestaña del bottom nav    | -                                              |
| `about`               | `/about`                            | `goToAbout`              | -                                              |
| `activityDetails`     | `/activity-details/:activityId`     | `goToActivityDetails`    | `activityId: String` (path)                   |
| `activityForm`        | `/activity-form`                    | `goToActivityForm`       | `activityId: String?`, `disciplineId: int?` (query), retorna `bool?` |
| `agenda`              | `/agenda`                           | `goToAgenda`              | -                                              |
| `categories`          | `/categories`                       | `goToCategories`          | -                                              |
| `courseDetails`       | `/course-details`                   | `goToCourseDetails`       | -                                              |
| `disciplineDetails`   | `/discipline-details/:disciplineId` | `goToDisciplineDetails`   | `disciplineId: int` (path), `tab: int?` (query) |
| `disciplineSelection` | `/discipline-selection`             | `goToDisciplineSelection` | -                                              |
| `disciplines`         | `/disciplines`                      | `goToDisciplines`         | -                                              |
| `editProfile`         | `/edit-profile`                     | `goToEditProfile`         | -                                              |
| `forgotPassword`      | `/forgot-password`                  | `goToForgotPassword`      | -                                              |
| `home` (push)         | `/home`                             | `goToHome`                | -                                              |
| `login`               | `/login`                            | `goToLogin`               | `replace: bool` (por defecto `false`)          |
| `mySchedule`          | `/my-schedule`                      | `goToMySchedule`          | -                                              |
| `noteDetails`         | `/note-details/:noteId`             | `goToNoteDetails`         | `noteId: String` (path)                        |
| `noteForm`            | `/note-form`                        | `goToNoteForm`            | `disciplineId: int` (query), `noteId: String?` (query) |
| `pdfViewer`           | `/pdf-viewer`                       | `goToPdfViewer`           | `url: String`, `title: String` (query)         |
| `register`            | `/register`                         | `goToRegister`            | `replace: bool` (por defecto `false`)          |
| `schedule`            | `/schedule`                         | `goToSchedule`            | `period: int?` (query)                         |
| `splash`              | `/splash`                           | ruta inicial               | -                                              |
| `tags`                | `/tags`                             | `goToTags`                | -                                              |
| `teacherDetails`      | `/teacher-details/:teacherId`       | `goToTeacherDetails`      | `teacherId: int` (path)                        |
| `userManagement`      | `/user-management`                  | `goToUserManagement`      | -                                              |

### Push vs Go

| Método        | Comportamiento                                             | Cuándo usarlo                             |
| --------------- | -------------------------------------------------------------- | -------------------------------------------- |
| `pushNamed()` | Apila una nueva ruta sobre la actual (el botón atrás funciona) | Detalles, formularios, flujos secundarios |
| `goNamed()`   | Reemplaza completamente la ruta actual                        | Login, splash, logout, reset de flujo     |

### Cómo Agregar una Nueva Ruta

1. Agrega el nombre en `route_names.dart` y el path en `route_paths.dart`.
2. Registra el `GoRoute` en `app_router.dart`.
3. Agrega un método `goTo...` en `app_routes.dart`.
4. Úsalo en la UI: `AppRoutes.goToMyNewScreen(context);`.

---

## Tecnologías

### Stack Principal

| Tecnología                      | Versión     | Rol en el proyecto           |
| ---------------------------------- | ------------- | -------------------------------- |
| [Flutter](https://flutter.dev/) | 3.44.9      | Framework de UI multiplataforma |
| [Dart](https://dart.dev/)       | SDK ^3.12.2 | Lenguaje de programación      |

### Estado y DI

| Paquete                                                         | Versión | Rol en el proyecto                                      |
| ----------------------------------------------------------------- | --------- | ------------------------------------------------------------ |
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | 3.4.3   | Gestión de estado reactivo e inyección de dependencias |
| [riverpod](https://pub.dev/packages/riverpod)                 | 3.4.3   | Núcleo de Riverpod (sin Flutter) - usado en la capa Domain |

**Por qué Riverpod:** solución compile-safe que unifica gestión de estado y DI. Los providers pueden accederse sin `BuildContext`, sobrescribirse en tests y componerse sin boilerplate. Ver [Gestión de Estado con Riverpod](#gestión-de-estado-con-riverpod).

### Persistencia

| Paquete                                                           | Versión | Rol en el proyecto                             |
| --------------------------------------------------------------------- | --------- | -------------------------------------------------- |
| [sqflite](https://pub.dev/packages/sqflite)                       | 2.4.4   | Base de datos SQLite local                     |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 2.5.5   | Persistencia simple de preferencias (tema, flags) |

**Por qué SQLite:** los datos relacionales complejos (actividades, notas, asignaturas) requieren queries, joins y migraciones versionadas - SQLite vía sqflite es la elección natural para Flutter offline-first.

### Autenticación y Backend

| Paquete                                                     | Versión | Rol en el proyecto                          |
| ----------------------------------------------------------------- | --------- | ---------------------------------------------- |
| [firebase_core](https://pub.dev/packages/firebase_core)     | 4.15.0  | Inicialización de Firebase                   |
| [firebase_auth](https://pub.dev/packages/firebase_auth)     | 6.7.0   | Autenticación de usuarios                    |
| [google_sign_in](https://pub.dev/packages/google_sign_in)   | 7.2.0   | Inicio de sesión con cuenta Google (vía Firebase Auth) |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore) | 6.10.0  | Base de datos en la nube para datos de usuario |

El proyecto adopta una **arquitectura de persistencia híbrida**: los datos locales (actividades, notas) viven en SQLite; los datos de usuario y autenticación viven en Firebase. Esto garantiza funcionalidad offline para las funciones principales.

**Configuración requerida de Firebase:** el inicio de sesión con Google solo funciona una vez que el proveedor está habilitado en Authentication → Sign-in method y la huella SHA-1 de la app está registrada en el proyecto.

### Navegación

| Paquete                                             | Versión | Rol en el proyecto                     |
| -------------------------------------------------------- | --------- | ------------------------------------------ |
| [go_router](https://pub.dev/packages/go_router) | 18.0.1  | Enrutamiento declarativo con Deep Linking |

Ver [Sistema de Navegación](#sistema-de-navegación) arriba.

### UI y Diseño

| Paquete                                                                               | Versión | Rol en el proyecto            |
| ------------------------------------------------------------------------------------------ | --------- | --------------------------------- |
| [google_fonts](https://pub.dev/packages/google_fonts)                                 | 8.2.1   | Tipografía (Google Fonts)      |
| [syncfusion_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar)   | 34.2.9  | Componente de calendario avanzado |
| [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) | 34.2.9  | Visor de PDF integrado         |
| [flutter_quill](https://pub.dev/packages/flutter_quill)                               | 11.6.0  | Editor de texto enriquecido para notas |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)                           | 1.0.9   | Íconos estilo iOS              |

### Utilidades

| Paquete                                                                       | Versión | Rol en el proyecto                                   |
| ----------------------------------------------------------------------------------- | --------- | ---------------------------------------------------------- |
| [intl](https://pub.dev/packages/intl)                                         | 0.20.2  | Formato de fecha, número e internacionalización     |
| [uuid](https://pub.dev/packages/uuid)                                         | 4.6.0   | Generación de identificadores únicos                 |
| [url_launcher](https://pub.dev/packages/url_launcher)                         | 6.3.2   | Apertura de URLs externas                              |
| [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) | 5.1.1   | Exportación de imágenes a la galería                 |
| [package_info_plus](https://pub.dev/packages/package_info_plus)               | 10.2.1  | Lectura de información del paquete (versión de la app) |
| [fluttertoast](https://pub.dev/packages/fluttertoast)                         | 10.0.0  | Notificaciones toast nativas                           |
| [logger](https://pub.dev/packages/logger)                                     | 2.8.0   | Salida legible en consola, encapsulada por `AppLogger` — ningún otro archivo lo importa directamente |

### Dev y Herramientas

| Paquete                                                                   | Versión | Rol en el proyecto                                       |
| -------------------------------------------------------------------------------- | --------- | -------------------------------------------------------------- |
| [very_good_analysis](https://pub.dev/packages/very_good_analysis)         | 10.3.0  | Conjunto estricto de reglas de lint                       |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | 0.14.4  | Generación del ícono de la app para todas las plataformas |
| [flutter_localizations](https://flutter.dev/)                             | SDK     | Soporte de localización (toolbar del editor Quill, fechas) |
| [mocktail](https://pub.dev/packages/mocktail)                             | 1.0.5   | Mocking en tests unitarios y de widgets                    |
| [fake_cloud_firestore](https://pub.dev/packages/fake_cloud_firestore)     | 4.3.0   | Fake en memoria de Firestore para tests                     |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)         | 2.4.3   | Driver SQLite FFI para tests y para ejecutar seeds en desktop |

### Sobre las Versiones

Las versiones listadas son las **versiones resueltas de `pubspec.lock`** - versiones exactas en uso, no los rangos de `pubspec.yaml`. Para actualizar:

```bash
# Ver dependencias desactualizadas
fvm flutter pub outdated

# Actualizar dentro de los rangos definidos
fvm flutter pub upgrade

# Actualizar a nuevas versiones major (atención a breaking changes)
fvm flutter pub upgrade --major-versions
```
