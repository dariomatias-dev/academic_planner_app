<div align="center">

# Arquitetura

</div>

## Sumário

- [Visão Geral](#visão-geral)
- [Feature-First](#feature-first)
- [Clean Architecture](#clean-architecture)
- [MVVM](#mvvm)
- [Como as três se combinam](#como-as-três-se-combinam)
- [Camadas por Feature](#camadas-por-feature)
- [Regras de Dependência](#regras-de-dependência)
- [Fluxo de Dados](#fluxo-de-dados)
- [Gerenciamento de Estado com Riverpod](#gerenciamento-de-estado-com-riverpod)
- [Árvore de Pastas](#árvore-de-pastas)
- [Camada Core](#camada-core)
- [Camada Shared](#camada-shared)
- [Features Existentes](#features-existentes)
- [Organização de Widgets](#organização-de-widgets)
- [Seeds](#seeds)
- [Sistema de Navegação](#sistema-de-navegação)
- [Tecnologias](#tecnologias)

---

## Visão Geral

O projeto combina três abordagens complementares para organizar o código de forma escalável, testável e fácil de manter:

| Abordagem              | Responsabilidade                                 |
| ----------------------- | -------------------------------------------------- |
| **Feature-First**      | Como o código é organizado em pastas             |
| **Clean Architecture** | Como as camadas se comunicam e dependem entre si |
| **MVVM**               | Como a UI se conecta à lógica de negócio         |

Cada uma resolve um problema diferente. Juntas, formam uma base sólida para o crescimento da aplicação sem acúmulo de débito técnico.

---

## Feature-First

### O que é

Feature-First é uma estratégia de **organização de pastas** onde cada funcionalidade do produto é isolada em seu próprio módulo. Em vez de agrupar arquivos por tipo técnico (todos os models juntos, todas as telas juntas), agrupa-se por domínio de negócio.

```text
features/
├── activities/    # tudo relacionado a atividades
├── disciplines/   # tudo relacionado a disciplinas
├── notes/         # tudo relacionado a anotações
└── auth/          # tudo relacionado a autenticação
```

### Por que foi escolhida

- **Coesão:** todo o código de uma funcionalidade fica junto. Para entender ou alterar `activities`, você navega em `features/activities/` - sem caçar arquivos espalhados.
- **Escalabilidade:** adicionar uma nova feature não afeta as existentes.
- **Isolamento:** uma feature pode ser removida ou refatorada sem efeitos colaterais em outras.
- **Onboarding:** um novo desenvolvedor entende o domínio lendo a árvore de pastas.

### Comparação com Layer-First

| Layer-First (convencional)                 | Feature-First (adotado)                         |
| -------------------------------------------- | -------------------------------------------------- |
| `models/activity.dart`, `models/note.dart` | `activities/data/models/`, `notes/data/models/` |
| Fácil de entender a estrutura técnica      | Fácil de entender o domínio do produto          |
| Ruim para escalar                          | Bom para escalar                                |
| Mudanças cruzam muitas pastas              | Mudanças ficam dentro da feature                |

---

## Clean Architecture

### O que é

Clean Architecture é um conjunto de **regras de dependência entre camadas** criado por Robert C. Martin (Uncle Bob). O objetivo é separar regras de negócio de detalhes de infraestrutura (banco de dados, UI, frameworks).

```text
┌─────────────────────────────┐
│        Presentation         │  ← UI, ViewModels, Providers
├─────────────────────────────┤
│           Domain            │  ← Entidades, Contratos (puro Dart)
├─────────────────────────────┤
│            Data             │  ← Models, Services, Repositórios (impl.)
└─────────────────────────────┘
```

A regra central: **dependências apontam para dentro**. A camada de fora (Presentation, Data) depende da de dentro (Domain). O Domain não depende de ninguém.

### Por que foi escolhida

- **Independência de framework:** as regras de negócio no Domain são Dart puro - não importam Flutter, SQLite ou Riverpod.
- **Testabilidade:** o Domain pode ser testado sem banco de dados ou widgets.
- **Substituibilidade:** trocar SQLite por outra persistência exige mudar só a camada Data.
- **Proteção do negócio:** a UI nunca acessa o banco de dados diretamente.

### Exemplo prático

```
domain/repositories/activity_repository.dart     → contrato (interface)
data/repositories/activity_repository_impl.dart  → implementação
data/datasources/activity_local_datasource.dart  → acesso ao SQLite
```

A Presentation conhece apenas `ActivityRepository` (contrato). Quem fornece a implementação é o sistema de DI - a UI não sabe se os dados vêm de SQLite, API ou memória.

---

## MVVM

> O padrão MVVM é a abordagem recomendada pelo próprio Flutter para organização de aplicações. Veja: [Flutter App Architecture Guide](https://docs.flutter.dev/app-architecture/guide).

### O que é

MVVM (Model-View-ViewModel) é um padrão de **apresentação** que separa:

| Camada            | Responsabilidade                                            |
| ------------------ | -------------------------------------------------------------- |
| **View** (Screen) | Renderiza a UI e captura eventos do usuário                 |
| **ViewModel**     | Contém a lógica de apresentação e gerencia o estado da tela |
| **Model**         | Dados e regras de negócio (Domain + Data)                   |

### Por que foi escolhido

- **Sem lógica na View:** a tela apenas observa o estado e dispara ações - nunca decide nada.
- **ViewModel testável:** como não depende de `BuildContext` nem de widgets, pode ser testado com testes unitários puros.
- **Separação clara:** a lógica de "o que mostrar" fica no ViewModel; a lógica de "como mostrar" fica na View.

### Implementação com Riverpod

Neste projeto o ViewModel é uma classe Dart pura. O `Notifier` do Riverpod atua como adaptador que expõe o estado do ViewModel de forma reativa:

```dart
// ViewModel - lógica pura, sem Flutter
class ActivityViewModel {
  Future<void> createActivity(ActivityEntity activity) async { ... }
}

// Notifier - ponte entre ViewModel e a UI
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

Essa separação garante que o ViewModel possa ser testado sem simular o ambiente reativo do Riverpod.

---

## Como as três se combinam

```text
Feature-First  → onde o código fica (pastas)
Clean Arch     → como as camadas se comunicam (regras)
MVVM           → como a UI e lógica se conectam (padrão)
```

Dentro de cada feature, a Clean Architecture define as camadas (`domain/`, `data/`, `presentation/`). Dentro de `presentation/`, o MVVM define como Screen, ViewModel e Notifier se relacionam.

---

## Camadas por Feature

### Domain

Camada central. Contém apenas código **Dart puro** - zero dependência de Flutter ou pacotes externos.

| Pasta            | Conteúdo                                                |
| ------------------ | ------------------------------------------------------- |
| `entities/`      | Representam a verdade do negócio (ex: `Activity`)       |
| `repositories/`  | Contratos (interfaces abstratas) de acesso a dados      |
| `value_objects/` | Tipos com validação embutida (ex: `ActivityFilter`)     |

**Regra:** nenhum arquivo do Domain importa da camada Data ou Presentation.

### Data

Responsável por prover e persistir os dados.

| Pasta           | Conteúdo                                           |
| ----------------- | -------------------------------------------------- |
| `models/`       | DTOs com lógica de mapeamento (`fromMap`, `toMap`) |
| `datasources/`  | Acesso direto à fonte de dados (SQLite, Firebase)  |
| `repositories/` | Implementações dos contratos definidos no Domain   |

Os **Models** fazem a conversão entre o formato do banco/API e as **Entities** do Domain. A camada de Presentation nunca usa Models - só Entities.

### Presentation

Camada de interface e interação com o usuário.

| Pasta          | Conteúdo                                                       |
| --------------- | ------------------------------------------------------------------ |
| `screens/`     | Widgets de tela que constroem a UI e observam o estado         |
| `view_models/` | Lógica pura de apresentação, sem `BuildContext`                |
| `providers/`   | Notifiers do Riverpod que expõem estado reativamente           |
| `widgets/`     | Componentes visuais específicos da feature                     |
| `actions/`     | Fluxos de UI com múltiplas etapas (ex: delete com confirmação) |

Nem toda feature tem todas as camadas ou pastas - só as que têm conteúdo. Ver [Features Existentes](#features-existentes).

---

## Regras de Dependência

```text
Presentation ──→ Domain ←── Data
```

1. **Domain não depende de ninguém.** É o núcleo protegido.
2. **Presentation depende do Domain** (contratos), nunca da Data (implementações).
3. **Data depende do Domain** para implementar os contratos.
4. **A DI (`di/`)** resolve qual implementação concreta injetar em runtime.

Violações dessas regras introduzem acoplamento que dificulta testes e substituição de implementações.

---

## Fluxo de Dados

```text
View (Screen)
  ↓ dispara ação (ex: botão salvar)
Provider (Notifier)
  ↓ delega para
ViewModel
  ↓ chama contrato
Repository (Domain - interface)
  ↓ implementado por
RepositoryImpl (Data)
  ↓ usa
DataSource / Service (SQLite, Firebase)
```

O fluxo inverso (dados chegando à UI) é reativo via Riverpod: o Notifier notifica a View quando o estado muda.

---

## Gerenciamento de Estado com Riverpod

O **Riverpod** é a solução de gerenciamento de estado e injeção de dependência do projeto.

### Por que Riverpod

- **Compile-safe:** erros de provider são detectados em tempo de compilação.
- **Sem `BuildContext`:** providers podem ser acessados fora da árvore de widgets.
- **DI integrada:** o mesmo sistema serve para estado reativo e injeção de dependências.
- **Testável:** providers podem ser sobrescritos em testes sem configuração extra (ver [provider_graph_smoke_test.dart](../test/provider_graph_smoke_test.dart), que sobrescreve todas as dependências externas de uma vez).

### Tipos de providers utilizados

| Provider                | Uso                                                          |
| ------------------------- | ---------------------------------------------------------------- |
| `Provider`              | Dependências imutáveis (repositórios, serviços, datasources) |
| `AsyncNotifierProvider` | Estado assíncrono com ciclo de vida (listas, banco/Firestore) |
| `NotifierProvider`      | Estado síncrono com lógica (filtros, tema, formulários)      |
| `FutureProvider`        | Leituras assíncronas pontuais ou derivadas, incluindo `.family` |

### Estrutura de providers por feature

```text
features/activities/
├── di/
│   └── activity_providers.dart   ← providers de DI (repositório, datasource)
└── presentation/
    └── providers/
        ├── activity_notifier.dart         ← estado principal da lista
        ├── activity_filter_notifier.dart  ← estado do filtro
        └── activity_stats_notifier.dart   ← estado das estatísticas
```

A separação entre `di/` e `presentation/providers/` mantém os providers de infraestrutura (DI) isolados dos providers de UI (estado).

---

## Árvore de Pastas

```text
lib/
├── main.dart                        # Ponto de entrada da aplicação
├── firebase_options.dart            # Configuração gerada do Firebase
└── src/
    ├── academic_planner_app.dart    # Widget raiz (MaterialApp + tema + router)
    │
    ├── core/                        # Infraestrutura global e transversal — ver Camada Core
    │
    ├── features/                    # Módulos de negócio isolados
    │   └── <feature>/               # Ver Features Existentes
    │       ├── data/
    │       │   ├── datasources/     # Acesso direto ao banco/API
    │       │   ├── models/          # DTOs com fromMap/toMap
    │       │   ├── repositories/    # Implementação dos contratos do Domain
    │       │   └── seeds/           # Seeds de dev específicas da feature (opcional)
    │       ├── di/                  # Providers de DI específicos da feature
    │       ├── domain/
    │       │   ├── entities/        # Entidades puras do domínio
    │       │   ├── repositories/    # Contratos (interfaces abstratas)
    │       │   └── value_objects/   # Tipos com validação embutida
    │       └── presentation/
    │           ├── actions/         # Fluxos de UI com múltiplas etapas
    │           ├── providers/       # Notifiers de estado
    │           ├── screens/         # Telas e seus widgets internos
    │           ├── view_models/     # Lógica de apresentação pura
    │           └── widgets/         # Componentes visuais da feature
    │
    └── shared/                      # Recursos globais reutilizáveis — ver Camada Shared
```

---

## Camada Core

A pasta `core/` concentra código **transversal** compartilhado por todas as features. Não é uma feature - é infraestrutura da aplicação.

```text
core/
├── constants/                   # Dados estáticos e catálogo do curso
│   ├── disciplines/             # Dados de disciplinas por período
│   ├── day_names.dart
│   ├── schedules.dart
│   └── teachers.dart
│
├── database/                    # Persistência SQLite
│   ├── app_database.dart        # Configuração central do banco
│   ├── migrations/              # Migrações versionadas do schema (migration_v1.dart, ...)
│   └── tables/                  # Definições de tabelas
│
├── di/                          # Providers globais de injeção de dependência
│   ├── app_version_provider.dart
│   ├── database_provider.dart
│   ├── firebase_providers.dart
│   ├── shared_preferences_provider.dart
│   └── theme_provider.dart
│
├── domain/entities/             # Entidades compartilhadas entre features (Pagination, Discipline, ScheduleEntry)
│
├── errors/                      # Padrão Result<T>/Failure para tratamento funcional de erros
│
├── extensions/                  # Extensões de tipos Dart/Flutter
│
├── logging/app_logger.dart          # Logging centralizado (ver abaixo)
│
├── notifiers/app_version_notifier.dart
│
├── routes/                      # Sistema de navegação (GoRouter) — ver Sistema de Navegação
│   └── root_navigation.dart     # Widget raiz de navegação com bottom nav
│
├── seeds/                       # Infraestrutura base de seeds (ver Seeds)
│
├── services/                    # Serviços de infraestrutura reutilizáveis
│   └── shared_preferences_keys.dart # Chaves de persistência local
│
├── theme/                       # Configuração de tema claro/escuro e persistência
│   └── app_colors.dart          # Paleta de cores globais
│
└── validators/validators.dart   # Validadores reutilizáveis de formulário
```

**`core/errors/`** - implementação do padrão `Result<T>`:

```dart
Result<List<Activity>> result = await repository.getAll();

switch (result) {
  case Success(:final value) => state = value,
  case Failure(:final failure) => handleError(failure),
}
```

**`core/database/`** - SQLite com sistema de migrações versionado:

```dart
class MigrationV2 implements Migration {
  @override
  Future<void> up(Database db) async {
    await db.execute(NoteTable.createTableQuery);
  }
}
```

**`core/logging/app_logger.dart`** - único ponto de log: todo arquivo que loga cria seu próprio `AppLogger('feature.ClassName')` e chama ele. `package:logger` é detalhe de implementação usado só dentro desse arquivo, para a saída bonita no console — nenhum outro arquivo o importa.

---

## Camada Shared

Componentes sem conhecimento de domínio de negócio. Qualquer feature pode usar.

```text
shared/
├── models/    # Models compartilhados entre features
├── screens/   # Telas sem feature dona (about, splash, not_found, pdf_viewer)
├── utils/     # Funções puras sem UI
└── widgets/   # Design System - componentes genéricos (buttons, dialogs, forms, inputs, states, ...)
```

- **`shared/widgets/`**: Design System - botões, inputs, diálogos, estados vazios, tab bars.
- **`shared/utils/`**: Funções puras sem UI.
- **`shared/models/`**: Models reutilizados entre múltiplas features.
- **`shared/screens/`**: Telas que não pertencem a nenhuma feature de negócio (`about`, `splash`, `not_found`, `pdf_viewer`). Ficam fora de `features/` pra não simular um domínio que não existe; as subpastas `widgets/` aqui seguem a mesma convenção de decomposição local de tela usada em `features/<feature>/presentation/screens/<tela>/widgets/`.

---

## Features Existentes

| Feature          | Descrição                                                         | Camadas                                |
| ------------------ | ------------------------------------------------------------------- | ----------------------------------------- |
| `activities`     | CRUD de atividades acadêmicas com filtros e estatísticas          | `data`, `domain`, `presentation`, `di` |
| `auth`           | Autenticação com Firebase (login, registro, recuperação de senha) | `data`, `domain`, `presentation`, `di` |
| `calendar`       | Visão de agenda com calendário e atividades por data              | `presentation`, `di`                   |
| `categories`     | Gerenciamento de categorias de atividades                         | `data`, `domain`, `presentation`, `di` |
| `course_details` | Detalhes do curso do usuário                                      | `presentation`                         |
| `disciplines`    | Gerenciamento de disciplinas e seleção por período                | `data`, `domain`, `presentation`, `di` |
| `home`           | Dashboard com resumo geral                                        | `presentation`                         |
| `notes`          | CRUD de anotações com editor rich text                            | `data`, `domain`, `presentation`, `di` |
| `schedule`       | Grade de horários das disciplinas                                 | `data`, `presentation`                 |
| `settings`       | Configurações do usuário (tema, exclusão de conta)                | `presentation`                         |
| `tags`           | Gerenciamento de tags de atividades                               | `data`, `domain`, `presentation`, `di` |
| `teacher`        | Informações sobre professores das disciplinas                     | `data`, `presentation`                 |
| `users`          | Perfil do usuário e gerenciamento de conta                        | `data`, `domain`, `presentation`, `di` |

Telas sem feature dona (`about`, `splash`, `not_found`, `pdf_viewer`) vivem em `shared/screens/` - ver [Camada Shared](#camada-shared).

---

## Organização de Widgets

Dois níveis de reutilização:

### `shared/widgets/` - Design System

Componentes genéricos sem conhecimento de domínio. Usados por qualquer feature.

```dart
AppButton(
  label: 'Salvar',
  onPressed: () => viewModel.save(),
)
```

### `features/<feature>/presentation/widgets/` - Componentes Semânticos

Widgets ligados ao domínio da feature. Podem referenciar entidades e lógica específicas.

```dart
ActivityCardWidget(
  activity: activity,
  onTap: () => AppRoutes.goToActivityDetails(context, activityId: activity.id),
)
```

### Regra de decisão

| Cenário                                           | Onde colocar                                                      |
| ---------------------------------------------------- | ----------------------------------------------------------------- |
| Usado por 2+ features                             | `shared/widgets/`                                                 |
| Usa entidades ou lógica de uma feature específica | `features/<feature>/presentation/widgets/`                        |
| É genérico mas criado para uma feature            | `features/<feature>/presentation/widgets/` (pode promover depois) |

---

## Seeds

Seeds vivem em dois lugares: infraestrutura base em `core/seeds/` e dados específicos em `features/<feature>/data/seeds/`.

Seeds **nunca executam em produção** (bloqueado por `kDebugMode`) e são **inativas por padrão no debug** também. Dupla proteção:

```dart
// core/seeds/seed_initializer.dart
const _seedEnabled = bool.fromEnvironment('SEED_ENABLED', defaultValue: false);

Future<void> runDevSeeds(Database db) async {
  if (!kDebugMode || !_seedEnabled) return;
  // ...
}
```

| Caso de uso                             | Comando                                       |
| ------------------------------------------ | ------------------------------------------------ |
| Rodar app com seeds no primeiro launch  | `flutter run --dart-define=SEED_ENABLED=true` |
| Rodar seeds standalone (sem emulador)   | `dart run scripts/seed.dart`                  |
| Dev normal / release                    | seeds nunca executam                          |

---

## Sistema de Navegação

A navegação foi projetada para ser **desacoplada, tipada e centralizada**. A UI nunca navega diretamente com strings ou URLs - usa métodos semânticos que encapsulam todos os detalhes de roteamento.

```text
UI → AppRoutes → GoRouter → Screen
```

Esse fluxo garante que uma mudança de rota (nome, path, parâmetros) impacte apenas os arquivos de navegação, não as telas.

### Por que GoRouter

- Navegação declarativa e centralizada (rotas definidas em um único lugar)
- Integração com Navigator 2.0 e suporte nativo a Deep Linking
- Suporte a path parameters e query parameters
- Navegação por nome com `pushNamed`/`goNamed` - sem strings literais espalhadas
- Tratamento de erros integrado (tela 404)
- Escalável para aplicações grandes

### Estrutura de Arquivos

```text
core/routes/
├── app_router.dart    # Configuração central do GoRouter e árvore de rotas
├── app_routes.dart    # Métodos semânticos de navegação (camada de abstração)
├── route_names.dart   # Identificadores únicos das rotas
└── route_paths.dart   # Caminhos (URLs) das rotas
```

`route_names.dart` e `route_paths.dart` centralizam identificadores e URLs, evitando strings literais espalhadas pelo código:

```dart
// route_names.dart
static const disciplineDetails = 'discipline_details';

// route_paths.dart
static const disciplineDetails = '/discipline-details/:disciplineId';
```

`app_router.dart` configura o `GoRouter` com a árvore de rotas e tratamento de erros. `home`, `myDisciplines`, `activities` e `settings` são abas de uma `StatefulShellRoute` (a bottom navigation bar), não acessadas via `AppRoutes`.

`app_routes.dart` é a camada de abstração que encapsula toda navegação. **A UI só chama métodos daqui:**

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

**Benefícios:** parâmetros tipados (o compilador pega erros antes do runtime), um único ponto para alterar o comportamento de uma navegação, e a UI nunca conhece nomes de rotas, paths ou como passar parâmetros.

### Referência de Rotas

| Nome                  | Path                                | Método em AppRoutes     | Parâmetros                                    |
| ----------------------- | -------------------------------------- | -------------------------- | ------------------------------------------------ |
| `home`                | `/home`                             | aba do bottom nav        | -                                              |
| `myDisciplines`       | `/my-disciplines`                   | aba do bottom nav        | -                                              |
| `activities`          | `/activities`                       | aba do bottom nav / `goToActivities` | -                                     |
| `settings`            | `/settings`                         | aba do bottom nav        | -                                              |
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
| `login`               | `/login`                            | `goToLogin`               | `replace: bool` (padrão `false`)               |
| `mySchedule`          | `/my-schedule`                      | `goToMySchedule`          | -                                              |
| `noteDetails`         | `/note-details/:noteId`             | `goToNoteDetails`         | `noteId: String` (path)                        |
| `noteForm`            | `/note-form`                        | `goToNoteForm`            | `disciplineId: int` (query), `noteId: String?` (query) |
| `pdfViewer`           | `/pdf-viewer`                       | `goToPdfViewer`           | `url: String`, `title: String` (query)         |
| `register`            | `/register`                         | `goToRegister`            | `replace: bool` (padrão `false`)               |
| `schedule`            | `/schedule`                         | `goToSchedule`            | `period: int?` (query)                         |
| `splash`              | `/splash`                           | rota inicial              | -                                              |
| `tags`                | `/tags`                             | `goToTags`                | -                                              |
| `teacherDetails`      | `/teacher-details/:teacherId`       | `goToTeacherDetails`      | `teacherId: int` (path)                        |
| `userManagement`      | `/user-management`                  | `goToUserManagement`      | -                                              |

### Push vs Go

| Método        | Comportamento                                          | Quando usar                               |
| --------------- | ---------------------------------------------------------- | -------------------------------------------- |
| `pushNamed()` | Empilha nova rota sobre a atual (back button funciona) | Detalhes, formulários, fluxos secundários |
| `goNamed()`   | Substitui completamente a rota atual                   | Login, splash, logout, reset de fluxo     |

### Como Adicionar uma Nova Rota

1. Adicione o nome em `route_names.dart` e o path em `route_paths.dart`.
2. Registre o `GoRoute` em `app_router.dart`.
3. Adicione um método `goTo...` em `app_routes.dart`.
4. Chame na UI: `AppRoutes.goToMyNewScreen(context);`.

---

## Tecnologias

### Stack Principal

| Tecnologia                      | Versão      | Papel no projeto            |
| ---------------------------------- | ------------- | ------------------------------ |
| [Flutter](https://flutter.dev/) | 3.44.9      | Framework de UI multiplataforma |
| [Dart](https://dart.dev/)       | SDK ^3.12.2 | Linguagem de programação    |

### Estado e DI

| Pacote                                                         | Versão | Papel no projeto                                       |
| ----------------------------------------------------------------- | -------- | ---------------------------------------------------------- |
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | 3.4.3  | Gerenciamento de estado reativo e injeção de dependência |
| [riverpod](https://pub.dev/packages/riverpod)                 | 3.4.3  | Núcleo do Riverpod (sem Flutter) - usado na camada Domain |

**Por que Riverpod:** solução compile-safe que unifica gerenciamento de estado e DI. Providers podem ser acessados sem `BuildContext`, sobrescritos em testes e compostos sem boilerplate. Ver [Gerenciamento de Estado com Riverpod](#gerenciamento-de-estado-com-riverpod).

### Persistência

| Pacote                                                           | Versão | Papel no projeto                             |
| ------------------------------------------------------------------- | -------- | ----------------------------------------------- |
| [sqflite](https://pub.dev/packages/sqflite)                       | 2.4.4  | Banco de dados SQLite local                  |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 2.5.5  | Persistência simples de preferências (tema, flags) |

**Por que SQLite:** dados relacionais complexos (atividades, anotações, disciplinas) exigem queries, joins e migrações versionadas - SQLite via sqflite é a escolha natural para Flutter offline-first.

### Autenticação e Backend

| Pacote                                                     | Versão | Papel no projeto                            |
| --------------------------------------------------------------- | -------- | ---------------------------------------------- |
| [firebase_core](https://pub.dev/packages/firebase_core)     | 4.15.0 | Inicialização do Firebase                    |
| [firebase_auth](https://pub.dev/packages/firebase_auth)     | 6.7.0  | Autenticação de usuários                     |
| [google_sign_in](https://pub.dev/packages/google_sign_in)   | 7.2.0  | Login com conta Google (via Firebase Auth)   |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore) | 6.10.0 | Banco de dados em nuvem para dados de usuário |

O projeto adota uma **arquitetura de persistência híbrida**: dados locais (atividades, anotações) ficam no SQLite; dados de usuário e autenticação ficam no Firebase. Isso garante funcionamento offline para as funcionalidades principais.

**Configuração necessária no Firebase:** o login com Google só funciona depois que o provider é habilitado em Authentication → Sign-in method e a impressão digital SHA-1 do app é registrada no projeto.

### Navegação

| Pacote                                             | Versão | Papel no projeto                    |
| ------------------------------------------------------ | -------- | --------------------------------------- |
| [go_router](https://pub.dev/packages/go_router) | 18.0.1 | Roteamento declarativo com Deep Linking |

Ver [Sistema de Navegação](#sistema-de-navegação) acima.

### UI e Design

| Pacote                                                                               | Versão | Papel no projeto            |
| ----------------------------------------------------------------------------------------- | -------- | ------------------------------- |
| [google_fonts](https://pub.dev/packages/google_fonts)                                 | 8.2.1  | Tipografia (Google Fonts)   |
| [syncfusion_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar)   | 34.2.9 | Componente de calendário avançado |
| [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) | 34.2.9 | Visualizador de PDF embutido |
| [flutter_quill](https://pub.dev/packages/flutter_quill)                               | 11.6.0 | Editor de texto rico para anotações |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)                           | 1.0.9  | Ícones estilo iOS           |

### Utilitários

| Pacote                                                                       | Versão | Papel no projeto                                    |
| ---------------------------------------------------------------------------------- | -------- | -------------------------------------------------------- |
| [intl](https://pub.dev/packages/intl)                                         | 0.20.2 | Formatação de data, número e internacionalização    |
| [uuid](https://pub.dev/packages/uuid)                                         | 4.6.0  | Geração de identificadores únicos                   |
| [url_launcher](https://pub.dev/packages/url_launcher)                         | 6.3.2  | Abertura de URLs externas                            |
| [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) | 5.1.1  | Exportação de imagens para a galeria                 |
| [package_info_plus](https://pub.dev/packages/package_info_plus)               | 10.2.1 | Leitura de informações do pacote (versão do app)     |
| [fluttertoast](https://pub.dev/packages/fluttertoast)                         | 10.0.0 | Notificações toast nativas                           |
| [logger](https://pub.dev/packages/logger)                                     | 2.8.0  | Saída bonita no console, encapsulada pelo `AppLogger` — nenhum outro arquivo o importa diretamente |

### Dev e Ferramentas

| Pacote                                                                   | Versão | Papel no projeto                                       |
| ------------------------------------------------------------------------------ | -------- | ------------------------------------------------------------ |
| [very_good_analysis](https://pub.dev/packages/very_good_analysis)         | 10.3.0 | Conjunto rígido de regras de lint                       |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | 0.14.4 | Geração do ícone do app para todas as plataformas       |
| [flutter_localizations](https://flutter.dev/)                             | SDK    | Suporte a localização (toolbar do editor Quill, datas)  |
| [mocktail](https://pub.dev/packages/mocktail)                             | 1.0.5  | Mocking em testes unitários e de widget                 |
| [fake_cloud_firestore](https://pub.dev/packages/fake_cloud_firestore)     | 4.3.0  | Fake em memória do Firestore para testes                 |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)         | 2.4.3  | Driver SQLite FFI para testes e para rodar seeds no desktop |

### Sobre as Versões

As versões listadas são as **versões resolvidas do `pubspec.lock`** - versões exatas em uso, não os intervalos do `pubspec.yaml`. Para atualizar:

```bash
# Ver dependências desatualizadas
fvm flutter pub outdated

# Atualizar dentro dos intervalos definidos
fvm flutter pub upgrade

# Atualizar para novas versões major (atenção a breaking changes)
fvm flutter pub upgrade --major-versions
```
