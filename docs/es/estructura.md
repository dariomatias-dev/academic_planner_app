<div align="center">

# Estructura del Proyecto

</div>

## Índice

- [Árbol de Carpetas](#árbol-de-carpetas)
- [Detalle por Sección](#detalle-por-sección)
- [Features Existentes](#features-existentes)
- [Organización de Widgets](#organización-de-widgets)
- [Seeds](#seeds)

---

## Árbol de Carpetas

```text
lib/
├── main.dart                        # Punto de entrada de la aplicación
├── firebase_options.dart            # Configuración generada por Firebase
└── src/
    ├── app_widget.dart              # Widget raíz (MaterialApp + tema + router)
    │
    ├── core/                        # Infraestructura global y transversal
    │   ├── app_colors.dart          # Paleta de colores global
    │   ├── root_navigation.dart     # Widget raíz de navegación con bottom nav
    │   ├── shared_preferences_keys.dart  # Claves de persistencia local
    │   ├── validators.dart          # Validadores reutilizables
    │   │
    │   ├── constants/               # Datos estáticos y mocks
    │   │   ├── disciplines/         # Datos de asignaturas por período (ADS)
    │   │   ├── day_names.dart       # Nombres de los días de la semana
    │   │   ├── mock_activities.dart # Actividades mock para desarrollo
    │   │   └── schedules.dart       # Horarios por defecto
    │   │
    │   ├── database/                # Persistencia SQLite
    │   │   ├── app_database.dart    # Configuración central de la base de datos
    │   │   ├── migrations/          # Migraciones versionadas del schema
    │   │   │   ├── migration.dart   # Interfaz base de migración
    │   │   │   ├── migration_v1.dart
    │   │   │   └── migration_v2.dart
    │   │   └── tables/              # Definiciones de tablas
    │   │       ├── activity_table.dart
    │   │       └── note_table.dart
    │   │
    │   ├── di/                      # Providers globales de inyección de dependencias
    │   │   ├── app_version_provider.dart
    │   │   ├── database_provider.dart
    │   │   ├── firebase_providers.dart
    │   │   ├── navigation_provider.dart
    │   │   ├── shared_preferences_provider.dart
    │   │   └── theme_provider.dart
    │   │
    │   ├── domain/                  # Entidades compartidas entre features
    │   │   └── entities/
    │   │       └── pagination.dart
    │   │
    │   ├── extensions/              # Extensiones de tipos Dart/Flutter
    │   │   ├── activity_status_extension.dart
    │   │   ├── announcement_type_extension.dart
    │   │   ├── list_extension.dart
    │   │   ├── theme_mode_extension.dart
    │   │   └── user_role_extension.dart
    │   │
    │   ├── logging/                 # Servicio de logging centralizado
    │   │   ├── logger_provider.dart
    │   │   ├── logger_service.dart       # Interfaz
    │   │   └── logger_service_impl.dart  # Implementación
    │   │
    │   ├── seeds/                   # Seeds de desarrollo (inactivas por defecto)
    │   │   ├── seed.dart            # Interfaz base Seed
    │   │   ├── seed_runner.dart     # Ejecutor secuencial de seeds
    │   │   └── seed_initializer.dart  # Punto de entrada con doble protección
    │   │
    │   ├── notifiers/               # Notifiers globales de estado
    │   │   ├── app_version_notifier.dart
    │   │   └── navigation_notifier.dart
    │   │
    │   ├── result/                  # Manejo funcional de errores
    │   │   ├── exception_mapper.dart
    │   │   ├── failure.dart         # Tipos de error
    │   │   └── result.dart          # Wrapper Result<T>
    │   │
    │   ├── routes/                  # Sistema de navegación (GoRouter)
    │   │   ├── app_router.dart      # Árbol de rutas y configuración central
    │   │   ├── app_routes.dart      # Métodos semánticos de navegación
    │   │   ├── route_names.dart     # Identificadores únicos de rutas
    │   │   └── route_paths.dart     # Rutas (URLs)
    │   │
    │   ├── services/                # Servicios de infraestructura reutilizables
    │   │   ├── image_export_service.dart
    │   │   └── shared_preferences_service.dart
    │   │
    │   └── theme/                   # Tematización de la aplicación
    │       ├── app_theme.dart       # Definición de temas claro y oscuro
    │       └── theme_notifier.dart  # Control y persistencia del tema
    │
    ├── features/                    # Módulos de negocio aislados
    │   └── <feature>/               # Ver sección "Features Existentes"
    │       ├── data/
    │       │   ├── data_source/     # Acceso directo a base de datos/API
    │       │   ├── models/          # DTOs con fromMap/toMap
    │       │   ├── repositories/    # Implementación de los contratos del Domain
    │       │   └── seeds/           # Seeds de dev específicas de la feature (opcional)
    │       ├── di/                  # Providers de DI específicos de la feature
    │       ├── domain/
    │       │   ├── entities/        # Entidades puras del dominio
    │       │   ├── repositories/    # Contratos (interfaces abstractas)
    │       │   └── value_objects/   # Tipos con validación incorporada
    │       └── presentation/
    │           ├── actions/         # Flujos de UI con múltiples pasos
    │           ├── providers/       # Notifiers de estado
    │           ├── screens/         # Pantallas y sus widgets internos
    │           ├── view_models/     # Lógica de presentación pura
    │           └── widgets/         # Componentes visuales de la feature
    │
    └── shared/                      # Recursos globales reutilizables
        ├── models/                  # Models compartidos entre features
        ├── screens/                 # Pantallas sin feature dueña (about, splash, not_found, pdf_viewer)
        ├── utils/                   # Funciones utilitarias sin UI
        └── widgets/                 # Design System - componentes genéricos
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

## Detalle por Sección

### `core/`

Infraestructura compartida por toda la aplicación. Ninguna feature depende de otra feature - todas dependen de `core/` cuando necesitan recursos globales.

**`core/result/`** - implementación del patrón `Result<T, Failure>`:

```dart
// Retorno tipado sin excepciones dispersas
Result<List<ActivityEntity>, Failure> result = await repository.getAll();

result.when(
  success: (activities) => state = activities,
  failure: (failure) => handleError(failure),
);
```

**`core/database/`** - SQLite con sistema de migraciones versionado:

```dart
// Cada versión del schema tiene su propia clase de migración
class MigrationV2 implements Migration {
  @override
  Future<void> up(Database db) async {
    await db.execute('ALTER TABLE activities ADD COLUMN ...');
  }
}
```

### `shared/`

Componentes sin conocimiento del dominio de negocio. Cualquier feature puede usarlos.

- **`shared/widgets/`**: Design System - botones, inputs, diálogos, estados vacíos, tab bars.
- **`shared/utils/`**: Funciones puras sin UI.
- **`shared/models/`**: Models reutilizados entre múltiples features.
- **`shared/screens/`**: Pantallas que no pertenecen a ninguna feature de negocio - sin dominio propio (`about`, `splash`, `not_found`, `pdf_viewer`). Quedan fuera de `features/` para no simular un dominio que no existe; las subcarpetas `widgets/` aquí siguen la misma convención de descomposición local de pantalla usada en `features/<feature>/presentation/screens/<pantalla>/widgets/`.

### Seeds

Las seeds viven en dos lugares: infraestructura base en `core/seeds/` y datos específicos en `features/<feature>/data/seeds/`.

Las seeds **nunca se ejecutan en producción** (bloqueadas por `kDebugMode`) y están **inactivas por defecto en debug** también. Doble protección:

```dart
// core/seeds/seed_initializer.dart
const _seedEnabled = bool.fromEnvironment('SEED_ENABLED', defaultValue: false);

Future<void> runDevSeeds(Database db) async {
  if (!kDebugMode || !_seedEnabled) return;
  // ...
}
```

| Caso de uso                                    | Comando                                       |
| ------------------------------------------------ | ---------------------------------------------- |
| Correr la app con seeds en el primer arranque  | `flutter run --dart-define=SEED_ENABLED=true` |
| Correr seeds standalone (sin emulador)          | `dart run scripts/seed.dart`                  |
| Dev normal / release                            | las seeds nunca se ejecutan                    |

---

## Features Existentes

| Feature          | Descripción                                                        | Capas                                    |
| ---------------- | -------------------------------------------------------------------- | ------------------------------------------ |
| `activities`     | CRUD de actividades académicas con filtros y estadísticas          | `data`, `domain`, `presentation`, `di` |
| `auth`           | Autenticación con Firebase (login, registro, recuperación de clave) | `data`, `domain`, `presentation`, `di` |
| `calendar`       | Vista de agenda con calendario y actividades por fecha               | `presentation`, `di`                   |
| `categories`     | Gestión de categorías de actividades                                 | `data`, `domain`, `presentation`, `di` |
| `course_details` | Detalles de la carrera del usuario                                    | `presentation`                         |
| `disciplines`    | Gestión de asignaturas y selección por período                      | `data`, `domain`, `presentation`, `di` |
| `home`           | Dashboard con resumen general                                        | `presentation`                         |
| `notes`          | CRUD de notas con editor de texto enriquecido                        | `data`, `domain`, `presentation`, `di` |
| `schedule`       | Grilla de horarios semanales                                          | `data`, `presentation`                 |
| `settings`       | Configuración del usuario (tema, eliminación de cuenta)              | `presentation`                         |
| `tags`           | Gestión de etiquetas de actividades                                   | `data`, `domain`, `presentation`, `di` |
| `teacher`        | Información sobre los profesores de las asignaturas                  | `data`, `presentation`                 |
| `users`          | Perfil del usuario y gestión de cuenta                                | `data`, `domain`, `presentation`, `di` |

Las pantallas sin feature dueña (`about`, `splash`, `not_found`, `pdf_viewer`) viven en `shared/screens/` - ver [Detalle por Sección](#shared) más arriba.

---

## Organización de Widgets

Dos niveles de reutilización:

### `shared/widgets/` - Design System

Componentes genéricos sin conocimiento del dominio. Usados por cualquier feature.

```dart
// Ejemplo: botón estándar del Design System
AppButton(
  label: 'Guardar',
  onPressed: () => viewModel.save(),
)
```

### `features/<feature>/presentation/widgets/` - Componentes Semánticos

Widgets ligados al dominio de la feature. Pueden referenciar entidades y lógica específicas.

```dart
// Ejemplo: card específica de actividad
ActivityCardWidget(
  activity: activity,
  onTap: () => AppRoutes.goToActivityDetails(context, id: activity.id),
)
```

### Regla de decisión

| Escenario                                            | Dónde ubicarlo                                                    |
| ------------------------------------------------------ | ------------------------------------------------------------------- |
| Usado por 2+ features                                 | `shared/widgets/`                                                  |
| Usa entidades o lógica de una feature específica     | `features/<feature>/presentation/widgets/`                        |
| Genérico pero creado para una feature                | `features/<feature>/presentation/widgets/` (se puede promover luego) |
