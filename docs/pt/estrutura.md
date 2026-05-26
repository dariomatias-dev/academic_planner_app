<div align="center">

# Estrutura do Projeto

</div>

## Sumário

- [Árvore de Pastas](#árvore-de-pastas)
- [Detalhamento por Seção](#detalhamento-por-seção)
- [Features Existentes](#features-existentes)
- [Organização de Widgets](#organização-de-widgets)
- [Seeds](#seeds)

---

## Árvore de Pastas

```text
lib/
├── main.dart                        # Ponto de entrada da aplicação
├── firebase_options.dart            # Configuração gerada do Firebase
└── src/
    ├── app_widget.dart              # Widget raiz (MaterialApp + tema + router)
    │
    ├── core/                        # Infraestrutura global e transversal
    │   ├── app_colors.dart          # Paleta de cores globais
    │   ├── root_navigation.dart     # Widget raiz de navegação com bottom nav
    │   ├── shared_preferences_keys.dart  # Chaves de persistência local
    │   ├── validators.dart          # Validadores reutilizáveis
    │   │
    │   ├── constants/               # Dados estáticos e mocks
    │   │   ├── disciplines/         # Dados de disciplinas por período (ADS)
    │   │   ├── day_names.dart       # Nomes dos dias da semana
    │   │   ├── mock_activities.dart # Atividades mock para desenvolvimento
    │   │   └── schedules.dart       # Horários padrão
    │   │
    │   ├── database/                # Persistência SQLite
    │   │   ├── app_database.dart    # Configuração central do banco
    │   │   ├── migrations/          # Migrações versionadas do schema
    │   │   │   ├── migration.dart   # Interface base de migração
    │   │   │   ├── migration_v1.dart
    │   │   │   └── migration_v2.dart
    │   │   └── tables/              # Definições de tabelas
    │   │       ├── activity_table.dart
    │   │       └── note_table.dart
    │   │
    │   ├── di/                      # Providers globais de injeção de dependência
    │   │   ├── app_version_provider.dart
    │   │   ├── database_provider.dart
    │   │   ├── firebase_providers.dart
    │   │   ├── navigation_provider.dart
    │   │   ├── shared_preferences_provider.dart
    │   │   └── theme_provider.dart
    │   │
    │   ├── domain/                  # Entidades compartilhadas entre features
    │   │   └── entities/
    │   │       └── pagination.dart
    │   │
    │   ├── extensions/              # Extensões de tipos Dart/Flutter
    │   │   ├── activity_status_extension.dart
    │   │   ├── announcement_type_extension.dart
    │   │   ├── list_extension.dart
    │   │   ├── theme_mode_extension.dart
    │   │   └── user_role_extension.dart
    │   │
    │   ├── logging/                 # Serviço de logging centralizado
    │   │   ├── logger_provider.dart
    │   │   ├── logger_service.dart       # Interface
    │   │   └── logger_service_impl.dart  # Implementação
    │   │
    │   ├── seeds/                   # Seeds de desenvolvimento (inativo por padrão)
    │   │   ├── seed.dart            # Interface base Seed
    │   │   ├── seed_runner.dart     # Executor sequencial de seeds
    │   │   └── seed_initializer.dart  # Ponto de entrada com dupla proteção
    │   │
    │   ├── notifiers/               # Notifiers globais de estado
    │   │   ├── app_version_notifier.dart
    │   │   └── navigation_notifier.dart
    │   │
    │   ├── result/                  # Tratamento funcional de erros
    │   │   ├── exception_mapper.dart
    │   │   ├── failure.dart         # Tipos de erro
    │   │   └── result.dart          # Wrapper Result<T>
    │   │
    │   ├── routes/                  # Sistema de navegação (GoRouter)
    │   │   ├── app_router.dart      # Árvore de rotas e configuração central
    │   │   ├── app_routes.dart      # Métodos semânticos de navegação
    │   │   ├── route_names.dart     # Identificadores únicos das rotas
    │   │   └── route_paths.dart     # Caminhos (URLs) das rotas
    │   │
    │   ├── services/                # Serviços de infraestrutura reutilizáveis
    │   │   ├── image_export_service.dart
    │   │   └── shared_preferences_service.dart
    │   │
    │   └── theme/                   # Tematização da aplicação
    │       ├── app_theme.dart       # Definição dos temas claro e escuro
    │       └── theme_notifier.dart  # Controle e persistência do tema
    │
    ├── features/                    # Módulos de negócio isolados
    │   └── <feature>/               # Ver seção "Features Existentes"
    │       ├── data/
    │       │   ├── data_source/     # Acesso direto ao banco/API
    │       │   ├── models/          # DTOs com fromMap/toMap
    │       │   ├── repositories/   # Implementação dos contratos do Domain
    │       │   └── seeds/           # Seeds de dev específicas da feature (opcional)
    │       ├── di/                  # Providers de DI específicos da feature
    │       ├── domain/
    │       │   ├── entities/        # Entidades puras do domínio
    │       │   ├── repositories/   # Contratos (interfaces abstratas)
    │       │   └── value_objects/  # Tipos com validação embutida
    │       └── presentation/
    │           ├── actions/         # Fluxos de UI com múltiplas etapas
    │           ├── providers/       # Notifiers de estado
    │           ├── screens/         # Telas e seus widgets internos
    │           ├── view_models/     # Lógica de apresentação pura
    │           └── widgets/         # Componentes visuais da feature
    │
    └── shared/                      # Recursos globais reutilizáveis
        ├── models/                  # Models compartilhados entre features
        ├── utils/                   # Funções utilitárias sem UI
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

## Detalhamento por Seção

### `core/`

Infraestrutura compartilhada por toda a aplicação. Nenhuma feature depende de outra feature - todas dependem do `core/` quando precisam de recursos globais.

**`core/result/`** - implementação do padrão `Result<T, Failure>`:

```dart
// Retorno tipado sem exceções soltas
Result<List<ActivityEntity>, Failure> result = await repository.getAll();

result.when(
  success: (activities) => state = activities,
  failure: (failure) => handleError(failure),
);
```

**`core/database/`** - SQLite com sistema de migrações versionado:

```dart
// Cada versão do schema tem sua própria classe de migração
class MigrationV2 implements Migration {
  @override
  Future<void> up(Database db) async {
    await db.execute('ALTER TABLE activities ADD COLUMN ...');
  }
}
```

### `shared/`

Componentes sem conhecimento de domínio de negócio. Qualquer feature pode usar.

- **`shared/widgets/`**: Design System - botões, inputs, diálogos, estados vazios, tab bars.
- **`shared/utils/`**: Funções puras sem UI.
- **`shared/models/`**: Models reutilizados entre múltiplas features.

### Seeds

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

| Caso de uso | Comando |
|---|---|
| Rodar app com seeds no primeiro launch | `flutter run --dart-define=SEED_ENABLED=true` |
| Rodar seeds standalone (sem emulador) | `dart run scripts/seed.dart` |
| Dev normal / release | seeds nunca executam |

---

## Features Existentes

| Feature          | Descrição                                                         | Camadas                                |
| ---------------- | ----------------------------------------------------------------- | -------------------------------------- |
| `about`          | Tela sobre o app e código-fonte                                   | `presentation`                         |
| `activities`     | CRUD de atividades acadêmicas com filtros e estatísticas          | `data`, `domain`, `presentation`, `di` |
| `auth`           | Autenticação com Firebase (login, registro, recuperação de senha) | `data`, `domain`, `presentation`, `di` |
| `calendar`       | Visão de agenda com calendário e atividades por data              | `presentation`, `di`                   |
| `categories`     | Gerenciamento de categorias de atividades                         | `data`, `domain`, `presentation`, `di` |
| `course_details` | Detalhes do curso do usuário                                      | `presentation`                         |
| `disciplines`    | Gerenciamento de disciplinas e seleção por período                | `data`, `domain`, `presentation`, `di` |
| `home`           | Dashboard com resumo geral                                        | `presentation`                         |
| `notes`          | CRUD de anotações com editor rich text                            | `data`, `domain`, `presentation`, `di` |
| `not_found`      | Tela 404 para rotas inválidas                                     | `presentation`                         |
| `pdf_viewer`     | Visualizador de PDFs integrado                                    | `presentation`                         |
| `schedule`       | Grade de horários das disciplinas                                 | `data`, `presentation`                 |
| `settings`       | Configurações do usuário (tema, exclusão de conta)                | `presentation`                         |
| `splash`         | Tela inicial com verificação de autenticação                      | `presentation`                         |
| `tags`           | Gerenciamento de tags de atividades                               | `data`, `domain`, `presentation`, `di` |
| `teacher`        | Informações sobre professores das disciplinas                     | `data`, `presentation`                 |
| `users`          | Perfil do usuário e gerenciamento de conta                        | `data`, `domain`, `presentation`, `di` |

---

## Organização de Widgets

Dois níveis de reutilização:

### `shared/widgets/` - Design System

Componentes genéricos sem conhecimento de domínio. Usados por qualquer feature.

```dart
// Exemplo: botão padrão do Design System
AppButton(
  label: 'Salvar',
  onPressed: () => viewModel.save(),
)
```

### `features/<feature>/presentation/widgets/` - Componentes Semânticos

Widgets ligados ao domínio da feature. Podem referenciar entidades e lógica específicas.

```dart
// Exemplo: card específico de atividade
ActivityCardWidget(
  activity: activity,
  onTap: () => AppRoutes.goToActivityDetails(context, id: activity.id),
)
```

### Regra de decisão

| Cenário                                           | Onde colocar                                                      |
| ------------------------------------------------- | ----------------------------------------------------------------- |
| Usado por 2+ features                             | `shared/widgets/`                                                 |
| Usa entidades ou lógica de uma feature específica | `features/<feature>/presentation/widgets/`                        |
| É genérico mas criado para uma feature            | `features/<feature>/presentation/widgets/` (pode promover depois) |
