<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-3.35.0-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-SDK%20^3.10.4-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Riverpod-3.3.1-08479E?style=for-the-badge" alt="Riverpod">
<img src="https://img.shields.io/badge/Arquitectura-MVVM%20%2B%20Clean%20%2B%20Feature--First-green?style=for-the-badge" alt="Arquitectura">
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
- [Funcionalidades](#funcionalidades)
- [Arquitectura](#arquitectura)
- [Estructura de Carpetas](#estructura-de-carpetas)
- [Tecnologías Principales](#tecnologías-principales)
- [Primeros Pasos](#primeros-pasos)
- [Documentación](#documentación)
- [Contribuir](#contribuir)
- [Autor](#autor)

## Sobre el Proyecto

Academic Planner es una aplicación de gestión de rutina estudiantil que sirve como **proyecto de referencia arquitectónico**. El objetivo principal no es solo la funcionalidad en sí, sino demostrar cómo estructurar una aplicación Flutter de mediano/gran tamaño utilizando:

- **Feature-First**: organización del código por dominio de negocio
- **Clean Architecture**: separación de responsabilidades en capas con reglas de dependencia explícitas
- **MVVM**: desacoplamiento entre la UI y la lógica de presentación

Cada decisión arquitectónica está documentada con su justificación. El proyecto es intencional: no hay atajos que comprometan la estructura para ganar velocidad de desarrollo.

## Funcionalidades

| Funcionalidad       | Descripción                                                                                |
| ------------------- | ------------------------------------------------------------------------------------------- |
| Actividades         | Creación, edición y eliminación de actividades académicas con filtros por estado, fecha y asignatura |
| Asignaturas         | Gestión de asignaturas por período académico con horario y detalles del profesor           |
| Agenda              | Vista de calendario con actividades agrupadas por fecha                                     |
| Notas               | Editor de texto enriquecido para crear notas vinculadas a asignaturas                       |
| Horario             | Vista de cuadrícula del horario semanal de clases                                           |
| Categorías y Tags   | Organización de actividades con categorías y tags personalizados                            |
| Autenticación       | Inicio de sesión, registro y recuperación de contraseña vía Firebase Auth                   |
| Configuración       | Alternancia de tema claro/oscuro con persistencia local                                     |
| Acerca de           | Información de la app con versión y enlace al código fuente                                 |

## Arquitectura

El proyecto combina tres enfoques complementarios:

```
Feature-First  ->  cómo se organiza el código en carpetas
Clean Arch     ->  cómo se comunican las capas (reglas de dependencia)
MVVM           ->  cómo se conecta la UI a la lógica de negocio
```

### ¿Por qué estos tres?

**Feature-First** resuelve el problema de organización: en lugar de agrupar archivos por tipo técnico (todos los models juntos, todas las pantallas juntas), agrupa por dominio de negocio. Cada feature es un módulo aislado: modificar `activities` no requiere abrir carpetas de otras funcionalidades.

**Clean Architecture** resuelve el problema de dependencias: define reglas explícitas sobre qué capa puede depender de cuál. El Domain (reglas de negocio) es Dart puro, sin dependencias externas. La UI nunca accede directamente a la base de datos.

**MVVM** resuelve el problema de acoplamiento en la UI: la pantalla nunca contiene lógica. El ViewModel gestiona el estado de la pantalla sin depender de `BuildContext`, por lo que es testeable de forma aislada.

Dentro de cada feature:

```text
features/activities/
├── domain/          # Entidades y contratos (Dart puro, cero dependencias)
├── data/            # Models, datasources e implementaciones de repositorios
├── presentation/    # Screens, ViewModels, Providers y Widgets
└── di/              # Inyección de dependencias de la feature
```

Flujo de datos:

```
Screen -> Provider -> ViewModel -> Repository (contrato) -> RepositoryImpl -> DataSource
```

> Documentación completa con ejemplos de código: [docs/en/architecture.md](docs/en/architecture.md)

## Estructura de Carpetas

```text
lib/src/
├── core/        # Infraestructura global (base de datos, rutas, tema, DI, logging, seeds)
├── features/    # 17 módulos de negocio aislados
└── shared/      # Design System y utilidades globales
```

Features existentes: `about`, `activities`, `auth`, `calendar`, `categories`, `course_details`, `disciplines`, `home`, `notes`, `not_found`, `pdf_viewer`, `schedule`, `settings`, `splash`, `tags`, `teacher`, `users`.

> Árbol de carpetas completo y comentado: [docs/en/structure.md](docs/en/structure.md)

## Tecnologías Principales

| Tecnología       | Versión | Rol                          |
| ---------------- | ------- | ----------------------------- |
| Flutter          | 3.35.0  | Framework de UI               |
| Dart SDK         | ^3.10.4 | Lenguaje                      |
| flutter_riverpod | 3.3.1   | Gestión de estado e inyección de dependencias |
| go_router        | 17.1.0  | Navegación declarativa        |
| sqflite          | 2.4.2   | Persistencia local (SQLite)   |
| firebase_auth    | 6.4.0   | Autenticación                 |
| cloud_firestore  | 6.3.0   | Backend en la nube            |
| flutter_quill    | 11.5.0  | Editor de texto enriquecido   |

> Lista completa con versiones exactas y justificación de cada elección: [docs/en/technologies.md](docs/en/technologies.md)

## Primeros Pasos

### Prerrequisitos

- Flutter 3.35.0+
- Dart SDK ^3.10.4
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
4. Ejecuta `flutter clean && flutter pub get`.

> Antes de publicar la aplicación, repite este procedimiento con la SHA-1 del keystore de **release**; la huella de debug solo cubre las builds locales.

**Justificación:** hasta que se registre una huella SHA-1, el array `oauth_client` de `google-services.json` permanece vacío, y todo intento de inicio de sesión con Google resulta en `UnknownFailure`.

### Instalación

```bash
# Clona el repositorio
git clone https://github.com/dariomatias-dev/academic-planner.git

# Instala las dependencias
flutter pub get

# Ejecuta la aplicación
flutter run
```

### Seeds de Desarrollo

Las seeds llenan la base de datos con datos de ejemplo para desarrollo. Inactivas por defecto, nunca se ejecutan en builds de release.

```bash
# Ejecutar la app con seeds en el primer inicio (solo debug)
flutter run --dart-define=SEED_ENABLED=true

# Ejecutar las seeds como script independiente (sin emulador)
dart run scripts/seed.dart
```

## Documentación

La documentación está organizada en archivos separados por tema para facilitar la navegación:

| Documento                                  | Qué encontrarás                                                                                                                                |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Arquitectura](docs/en/architecture.md)   | Explicación detallada de MVVM, Clean Architecture y Feature-First, con ejemplos de código del propio proyecto y justificación de cada elección |
| [Estructura del Proyecto](docs/en/structure.md) | Árbol de carpetas completo y comentado, detalle de cada sección y tabla con todas las features existentes                                       |
| [Navegación](docs/en/navigation.md)       | Cómo funciona el sistema de rutas con GoRouter, referencia completa de rutas y guía para agregar nuevas                                        |
| [Tecnologías](docs/en/technologies.md)    | Todas las dependencias con versiones exactas (de `pubspec.lock`) y motivo de cada elección                                                     |

## Contribuir

Las contribuciones hacen que la comunidad de código abierto sea un lugar increíble para aprender y crear. Cualquier contribución que hagas será muy apreciada.

Antes de abrir un pull request, consulta [CONTRIBUTING.md](CONTRIBUTING.md) (en inglés) para la configuración local, la convención de mensajes de commit (Conventional Commits) y las reglas de branch de este proyecto.

## Autor

Desarrollado por **Dário Matias**:

- **Portfolio**: [dariomatias-dev](https://dariomatias-dev.com)
- **GitHub**: [dariomatias-dev](https://github.com/dariomatias-dev)
- **Email**: [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com)
- **Instagram**: [@dariomatias_dev](https://instagram.com/dariomatias_dev)
- **LinkedIn**: [linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
</content>
