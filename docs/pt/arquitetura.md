<div align="center">

# Arquitetura do Projeto

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
- [Camada Core](#camada-core)
- [Gerenciamento de Estado com Riverpod](#gerenciamento-de-estado-com-riverpod)

---

## Visão Geral

O projeto combina três abordagens complementares para organizar o código de forma escalável, testável e fácil de manter:

| Abordagem              | Responsabilidade                                 |
| ---------------------- | ------------------------------------------------ |
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
| ------------------------------------------ | ----------------------------------------------- |
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
data/data_source/activity_local_datasource.dart  → acesso ao SQLite
```

A Presentation conhece apenas `ActivityRepository` (contrato). Quem fornece a implementação é o sistema de DI - a UI não sabe se os dados vêm de SQLite, API ou memória.

---

## MVVM

> O padrão MVVM é a abordagem recomendada pelo próprio Flutter para organização de aplicações. Veja: [Flutter App Architecture Guide](https://docs.flutter.dev/app-architecture/guide).

### O que é

MVVM (Model-View-ViewModel) é um padrão de **apresentação** que separa:

| Camada            | Responsabilidade                                            |
| ----------------- | ----------------------------------------------------------- |
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
| ---------------- | ------------------------------------------------------- |
| `entities/`      | Representam a verdade do negócio (ex: `ActivityEntity`) |
| `repositories/`  | Contratos (interfaces abstratas) de acesso a dados      |
| `value_objects/` | Tipos com validação embutida (ex: `ActivityFilter`)     |

**Regra:** nenhum arquivo do Domain importa da camada Data ou Presentation.

### Data

Responsável por prover e persistir os dados.

| Pasta           | Conteúdo                                           |
| --------------- | -------------------------------------------------- |
| `models/`       | DTOs com lógica de mapeamento (`fromMap`, `toMap`) |
| `data_source/`  | Acesso direto à fonte de dados (SQLite, Firebase)  |
| `repositories/` | Implementações dos contratos definidos no Domain   |

Os **Models** fazem a conversão entre o formato do banco/API e as **Entities** do Domain. A camada de Presentation nunca usa Models - só Entities.

### Presentation

Camada de interface e interação com o usuário.

| Pasta          | Conteúdo                                                       |
| -------------- | -------------------------------------------------------------- |
| `screens/`     | Widgets de tela que constroem a UI e observam o estado         |
| `view_models/` | Lógica pura de apresentação, sem `BuildContext`                |
| `providers/`   | Notifiers do Riverpod que expõem estado reativamente           |
| `widgets/`     | Componentes visuais específicos da feature                     |
| `actions/`     | Fluxos de UI com múltiplas etapas (ex: delete com confirmação) |

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

## Camada Core

A pasta `core/` concentra código **transversal** compartilhado por todas as features. Não é uma feature - é infraestrutura da aplicação.

| Pasta         | Responsabilidade                                                  |
| ------------- | ----------------------------------------------------------------- |
| `constants/`  | Dados estáticos e mocks globais                                   |
| `database/`   | Configuração do SQLite, tabelas e migrações                       |
| `di/`         | Providers globais de DI (database, tema, navegação, Firebase)     |
| `domain/`     | Entidades compartilhadas entre features (ex: `Pagination`)        |
| `extensions/` | Extensões utilitárias para tipos Dart/Flutter                     |
| `logging/`    | Serviço de logging centralizado                                   |
| `notifiers/`  | Notifiers globais (versão do app, navegação)                      |
| `result/`     | Padrão `Result<T>` e `Failure` para tratamento funcional de erros |
| `routes/`     | Sistema de navegação centralizado (GoRouter)                      |
| `services/`   | Serviços de infraestrutura reutilizáveis                          |
| `theme/`      | Configuração de tema claro/escuro e persistência                  |

---

## Gerenciamento de Estado com Riverpod

O **Riverpod** é a solução de gerenciamento de estado e injeção de dependência do projeto.

### Por que Riverpod

- **Compile-safe:** erros de provider são detectados em tempo de compilação.
- **Sem `BuildContext`:** providers podem ser acessados fora da árvore de widgets.
- **DI integrada:** o mesmo sistema serve para estado reativo e injeção de dependências.
- **Testável:** providers podem ser sobrescritos em testes sem configuração extra.

### Tipos de providers utilizados

| Provider                | Uso                                                          |
| ----------------------- | ------------------------------------------------------------ |
| `Provider`              | Dependências imutáveis (repositórios, serviços)              |
| `AsyncNotifierProvider` | Estado assíncrono com ciclo de vida (listas, dados do banco) |
| `NotifierProvider`      | Estado síncrono com lógica (filtros, formulários)            |
| `StreamProvider`        | Dados reativos em tempo real (Firebase)                      |

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
