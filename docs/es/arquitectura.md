<div align="center">

# Arquitectura del Proyecto

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
- [Capa Core](#capa-core)
- [Gestión de Estado con Riverpod](#gestión-de-estado-con-riverpod)

---

## Visión General

El proyecto combina tres enfoques complementarios para organizar el código de forma escalable, testeable y fácil de mantener:

| Enfoque                 | Responsabilidad                                    |
| ------------------------ | --------------------------------------------------- |
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

- **Cohesión:** todo el código de una funcionalidad queda junto. Para entender o modificar `activities`, navegas a `features/activities/` - sin buscar archivos dispersos.
- **Escalabilidad:** agregar una nueva feature no afecta a las existentes.
- **Aislamiento:** una feature puede eliminarse o refactorizarse sin efectos secundarios en otras.
- **Onboarding:** un nuevo desarrollador entiende el dominio solo leyendo el árbol de carpetas.

### Comparación con Layer-First

| Layer-First (convencional)                 | Feature-First (adoptado)                        |
| ------------------------------------------ | ------------------------------------------------ |
| `models/activity.dart`, `models/note.dart` | `activities/data/models/`, `notes/data/models/` |
| Fácil de entender la estructura técnica    | Fácil de entender el dominio del producto        |
| Mala escalabilidad                          | Buena escalabilidad                              |
| Los cambios cruzan muchas carpetas          | Los cambios quedan dentro de la feature          |

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

La regla central: **las dependencias apuntan hacia adentro**. La capa externa (Presentation, Data) depende de la interna (Domain). Domain no depende de nada.

### Por qué se eligió

- **Independencia de framework:** las reglas de negocio en Domain son Dart puro - sin Flutter, SQLite ni Riverpod.
- **Testeabilidad:** Domain puede probarse sin base de datos ni widgets.
- **Reemplazabilidad:** cambiar SQLite por otra persistencia solo requiere modificar la capa Data.
- **Protección del negocio:** la UI nunca accede directamente a la base de datos.

### Ejemplo práctico

```
domain/repositories/activity_repository.dart     → contrato (interfaz)
data/repositories/activity_repository_impl.dart  → implementación
data/data_source/activity_local_datasource.dart  → acceso a SQLite
```

Presentation solo conoce `ActivityRepository` (contrato). El sistema de DI decide qué implementación inyectar - la UI no sabe si los datos vienen de SQLite, una API o memoria.

---

## MVVM

> MVVM es el patrón recomendado por el propio Flutter para la arquitectura de aplicaciones. Ver: [Flutter App Architecture Guide](https://docs.flutter.dev/app-architecture/guide).

### Qué es

MVVM (Model-View-ViewModel) es un **patrón de presentación** que separa:

| Capa               | Responsabilidad                                          |
| ------------------- | --------------------------------------------------------- |
| **View** (Screen)  | Renderiza la UI y captura eventos del usuario             |
| **ViewModel**      | Contiene la lógica de presentación y gestiona el estado   |
| **Model**          | Datos y reglas de negocio (Domain + Data)                 |

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

La capa central. Contiene solo código **Dart puro** - cero dependencia de Flutter o paquetes externos.

| Carpeta          | Contenido                                                |
| ---------------- | ---------------------------------------------------------- |
| `entities/`      | Representan la verdad del negocio (ej. `ActivityEntity`) |
| `repositories/`  | Contratos (interfaces abstractas) de acceso a datos       |
| `value_objects/` | Tipos con validación incorporada (ej. `ActivityFilter`)  |

**Regla:** ningún archivo de Domain importa de las capas Data o Presentation.

### Data

Responsable de proveer y persistir los datos.

| Carpeta         | Contenido                                             |
| --------------- | -------------------------------------------------------- |
| `models/`       | DTOs con lógica de mapeo (`fromMap`, `toMap`)          |
| `data_source/`  | Acceso directo a la fuente de datos (SQLite, Firebase) |
| `repositories/` | Implementaciones de los contratos definidos en Domain  |

Los **Models** convierten entre el formato de la base de datos/API y las **Entities** de Domain. Presentation nunca usa Models - solo Entities.

### Presentation

La capa de UI e interacción con el usuario.

| Carpeta        | Contenido                                                |
| -------------- | ------------------------------------------------------------ |
| `screens/`     | Widgets de pantalla que construyen la UI y observan el estado |
| `view_models/` | Lógica de presentación pura, sin `BuildContext`          |
| `providers/`   | Notifiers de Riverpod que exponen el estado reactivamente |
| `widgets/`     | Componentes visuales específicos de la feature            |
| `actions/`     | Flujos de UI con múltiples pasos (ej. borrar con confirmación) |

---

## Reglas de Dependencia

```text
Presentation ──→ Domain ←── Data
```

1. **Domain no depende de nada.** Es el núcleo protegido.
2. **Presentation depende de Domain** (contratos), nunca de Data (implementaciones).
3. **Data depende de Domain** para implementar los contratos.
4. **La capa de DI (`di/`)** resuelve qué implementación concreta inyectar en runtime.

Violar estas reglas introduce acoplamiento que dificulta los tests y el reemplazo de implementaciones.

---

## Flujo de Datos

```text
View (Screen)
  ↓ dispara acción (ej. botón guardar)
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

El flujo inverso (los datos llegando a la UI) es reactivo vía Riverpod: el Notifier notifica a la View cuando cambia el estado.

---

## Capa Core

La carpeta `core/` concentra infraestructura **transversal** compartida por todas las features. No es una feature - es infraestructura de la aplicación.

| Carpeta       | Responsabilidad                                                     |
| ------------- | ----------------------------------------------------------------------- |
| `constants/`  | Datos estáticos y mocks globales                                     |
| `database/`   | Configuración de SQLite, tablas y migraciones                         |
| `di/`         | Providers globales de DI (base de datos, tema, navegación, Firebase) |
| `domain/`     | Entidades compartidas entre features (ej. `Pagination`)               |
| `extensions/` | Extensiones utilitarias para tipos Dart/Flutter                       |
| `logging/`    | Servicio de logging centralizado                                     |
| `notifiers/`  | Notifiers globales (versión de la app, navegación)                   |
| `result/`     | Patrón `Result<T>` y `Failure` para manejo funcional de errores      |
| `routes/`     | Sistema de navegación centralizado (GoRouter)                         |
| `services/`   | Servicios de infraestructura reutilizables                            |
| `theme/`      | Configuración de tema claro/oscuro y persistencia                     |

---

## Gestión de Estado con Riverpod

**Riverpod** es la solución de gestión de estado e inyección de dependencias del proyecto.

### Por qué Riverpod

- **Compile-safe:** los errores de provider se detectan en tiempo de compilación.
- **Sin `BuildContext`:** los providers pueden accederse fuera del árbol de widgets.
- **DI integrada:** el mismo sistema sirve tanto para estado reactivo como para inyección de dependencias.
- **Testeable:** los providers pueden sobrescribirse en tests sin configuración extra.

### Tipos de providers utilizados

| Provider                | Uso                                                          |
| ------------------------ | -------------------------------------------------------------- |
| `Provider`              | Dependencias inmutables (repositorios, servicios)             |
| `AsyncNotifierProvider` | Estado asíncrono con ciclo de vida (listas, datos del banco) |
| `NotifierProvider`      | Estado síncrono con lógica (filtros, formularios)             |
| `StreamProvider`        | Datos reactivos en tiempo real (Firebase)                      |

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

La separación entre `di/` y `presentation/providers/` mantiene los providers de infraestructura (DI) aislados de los providers de UI (estado).
