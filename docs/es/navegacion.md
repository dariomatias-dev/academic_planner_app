<div align="center">

# Sistema de Navegación

</div>

## Índice

- [Visión General](#visión-general)
- [Por qué GoRouter](#por-qué-gorouter)
- [Estructura de Archivos](#estructura-de-archivos)
- [Referencia de Rutas](#referencia-de-rutas)
- [Parámetros de Ruta](#parámetros-de-ruta)
- [Push vs Go](#push-vs-go)
- [Cómo Agregar una Nueva Ruta](#cómo-agregar-una-nueva-ruta)

---

## Visión General

La navegación fue diseñada para ser **desacoplada, tipada y centralizada**. La UI nunca navega directamente con strings o URLs - usa métodos semánticos que encapsulan todos los detalles de enrutamiento.

```text
UI → AppRoutes → GoRouter → Screen
```

Este flujo garantiza que un cambio de ruta (nombre, path, parámetros) impacte solo los archivos de navegación, no las pantallas.

---

## Por qué GoRouter

El proyecto usa **GoRouter** como solución oficial de navegación declarativa de Flutter.

**Motivos de la elección:**

- Navegación declarativa y centralizada (rutas definidas en un solo lugar)
- Integración con Navigator 2.0 y soporte nativo de Deep Linking
- Soporte de path parameters y query parameters
- Navegación por nombre con `pushNamed`/`goNamed` - sin strings literales dispersos
- Manejo de errores integrado (pantalla 404)
- Escala bien para aplicaciones grandes

---

## Estructura de Archivos

```text
core/routes/
├── app_router.dart    # Configuración central de GoRouter y árbol de rutas
├── app_routes.dart    # Métodos semánticos de navegación (capa de abstracción)
├── route_names.dart   # Identificadores únicos de rutas
└── route_paths.dart   # Rutas (URLs)
```

### `route_names.dart` y `route_paths.dart`

Centralizan identificadores y URLs. Evitan strings literales dispersos por el código.

```dart
// route_names.dart
static const disciplineDetails = 'discipline-details';

// route_paths.dart
static const disciplineDetails = '/discipline-details/:disciplineId';
```

### `app_router.dart`

Configura `GoRouter` con el árbol de rutas, la ruta inicial y el manejo de errores:

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

Capa de abstracción que encapsula toda la navegación. **La UI solo llama métodos de aquí.**

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

**Beneficios:**

- Parámetros tipados - el compilador detecta errores antes del runtime
- Un único punto para cambiar el comportamiento de cualquier navegación
- La UI no conoce nombres de rutas, paths ni cómo pasar parámetros

---

## Referencia de Rutas

| Nombre              | Path                                | Método en AppRoutes     | Parámetros                   |
| ------------------- | ----------------------------------- | ------------------------ | ----------------------------- |
| `splash`            | `/splash`                           | -                        | -                             |
| `login`             | `/login`                            | `goToLogin`              | -                             |
| `register`          | `/register`                         | `goToRegister`           | -                             |
| `forgotPassword`    | `/forgot-password`                  | `goToForgotPassword`     | -                             |
| `home`              | `/home`                             | `goToHome`               | -                             |
| `activities`        | `/activities`                       | `goToActivities`         | -                             |
| `activityDetails`   | `/activity-details/:activityId`     | `goToActivityDetails`    | `activityId: int`             |
| `activityForm`      | `/activity-form`                    | `goToActivityForm`       | `disciplineId: int?` (query) |
| `disciplines`       | `/disciplines`                      | `goToDisciplines`        | -                             |
| `disciplineDetails` | `/discipline-details/:disciplineId` | `goToDisciplineDetails`  | `disciplineId: int`           |
| `calendar`          | `/calendar`                         | `goToCalendar`           | -                             |
| `notes`             | `/notes`                            | `goToNotes`              | -                             |
| `noteForm`          | `/note-form`                        | `goToNoteForm`           | `noteId: int?` (query)        |
| `settings`          | `/settings`                         | `goToSettings`           | -                             |
| `about`             | `/about`                            | `goToAbout`              | -                             |

---

## Parámetros de Ruta

### Path Parameters

Se usan cuando el parámetro **identifica** el recurso - es parte de la URL.

```text
/discipline-details/5
```

**Definición:**

```dart
static const disciplineDetails = '/discipline-details/:disciplineId';
```

**Lectura:**

```dart
final id = state.pathParameters['disciplineId']!;
```

### Query Parameters

Se usan para estado **opcional o complementario** - no identifican la ruta.

```text
/activity-form?disciplineId=10
```

**Lectura:**

```dart
final disciplineId = state.uri.queryParameters['disciplineId'];
```

### Estrategia adoptada

| Tipo            | Cuándo usarlo                          | Ejemplo                          |
| ---------------- | ----------------------------------------- | --------------------------------- |
| Path Parameter  | Identidad del recurso (siempre requerido) | `/activities/5`                  |
| Query Parameter | Contexto opcional (puede ser nulo)        | `/activity-form?disciplineId=10` |

---

## Push vs Go

El proyecto usa dos comportamientos de navegación distintos:

| Método        | Comportamiento                                                   | Cuándo usarlo                        |
| -------------- | ------------------------------------------------------------------ | -------------------------------------- |
| `pushNamed()` | Apila una nueva ruta sobre la actual (el botón atrás funciona)     | Detalles, formularios, flujos secundarios |
| `goNamed()`   | Reemplaza completamente la ruta actual                              | Login, splash, logout, reset de flujo  |

```dart
// Apila - el usuario puede volver atrás
AppRoutes.goToActivityDetails(context, activityId: 5);

// Reemplaza - sin vuelta atrás (adecuado para logout)
AppRoutes.goToLogin(context);
```

---

## Cómo Agregar una Nueva Ruta

1. **Agrega el nombre** en `route_names.dart`:

```dart
static const myNewScreen = 'my-new-screen';
```

2. **Agrega el path** en `route_paths.dart`:

```dart
static const myNewScreen = '/my-new-screen';
// Con parámetro: '/my-new-screen/:id'
```

3. **Registra la ruta** en `app_router.dart`:

```dart
GoRoute(
  name: RouteNames.myNewScreen,
  path: RoutePaths.myNewScreen,
  builder: (context, state) => const MyNewScreen(),
),
```

4. **Crea el método de navegación** en `app_routes.dart`:

```dart
static void goToMyNewScreen(BuildContext context) {
  context.pushNamed(RouteNames.myNewScreen);
}
```

5. **Úsalo en la UI:**

```dart
AppRoutes.goToMyNewScreen(context);
```
