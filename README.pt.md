<div align="center">
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Riverpod-08479E?style=for-the-badge&logo=riverpod&logoColor=white" alt="Riverpod">
<img src="https://img.shields.io/badge/Architecture-MVVM%20%2B%20Clean-green?style=for-the-badge" alt="Architecture">
</div>

<br>

<p align="center">
<strong>Language:</strong>
<a href="README.en.md">English</a> | <strong>Português</strong>
</p>

<h1 align="center">Planejador Acadêmico</h1>

<p align="center">
  Gestão Educacional Inteligente baseada em arquitetura desacoplada e persistência local segura.
  <br>
  <a href="#arquitetura-do-projeto"><strong>Explore a documentação »</strong></a>
  <br>
  <br>
  <a href="https://github.com/dariomatias-dev/academic-planner/issues">Reportar Bug</a> · 
  <a href="https://github.com/dariomatias-dev/academic-planner/issues">Solicitar Funcionalidade</a>
</p>

## Sumário

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias](#tecnologias)
- [Arquitetura do Projeto](#arquitetura-do-projeto)
- [Primeiros Passos](#primeiros-passos)
- [Autor](#autor)

---

## Sobre o Projeto

O Planejador Acadêmico é um sistema de planejamento acadêmico desenvolvido para transformar a rotina estudantil. O foco central do aplicativo é reduzir a carga cognitiva do usuário, permitindo que a atenção seja mantida nas tarefas que realmente importam. Através de uma interface direta e processamento de dados local, o projeto oferece uma ferramenta de gestão eficaz para o controle de disciplinas, atividades e anotações.

---

## Tecnologias

Este projeto foi desenvolvido utilizando as seguintes tecnologias principais:

- **[Flutter](https://flutter.dev/)** – Framework UI para desenvolvimento multiplataforma.
- **[Dart](https://dart.dev/)** – Linguagem de programação otimizada para o cliente.
- **[Riverpod](https://riverpod.dev/)** – Gerenciamento de estado reativo e injeção de dependência.
- **[sqflite](https://pub.dev/packages/sqflite)** – Plugin SQLite para Flutter, utilizado para persistência local de dados.
- **[GoRouter](https://pub.dev/packages/go_router)** – Sistema de navegação declarativo para Flutter.

---

## Arquitetura do Projeto

Uma infraestrutura robusta para gestão educacional, fundamentada nos princípios de **Clean Architecture** e **MVVM**, com gerenciamento de estado reativo via **Riverpod**.

### 1. Visão Geral

O **Planejador Acadêmico** utiliza uma arquitetura híbrida que combina a separação de interesses da **Clean Architecture** com a reatividade do padrão **MVVM**. O projeto é organizado sob a filosofia **Feature-First**, onde cada módulo de negócio é isolado, promovendo escalabilidade e facilidade de manutenção.

**Objetivos Estratégicos:**

- **Isolamento de Domínio:** Regras de negócio independentes de UI e Banco de Dados.
- **Reatividade Controlada:** Estado gerido de forma previsível com Riverpod.
- **Persistência Local:** Gestão robusta de dados offline com SQLite.

### 2. Estrutura de Pastas

A árvore abaixo detalha a organização completa do diretório `lib/src/`, servindo como mapa para todas as camadas do sistema:

```text
lib/
└── src/
    ├── core/                            # Funcionalidades globais e transversais
    │   ├── constants/                   # Valores imutáveis
    │   ├── database/                    # Persistência SQLite
    │   │   ├── migrations/              # Migrações do esquema do banco de dados
    │   │   ├── tables/                  # Definições de tabelas
    │   │   └── app_database.dart        # Configuração central do banco de dados
    │   ├── di/                          # Injeção de Dependência
    │   ├── extensions/                  # Extensões de classes (Dart/Flutter)
    │   ├── result/                      # Padrão de retorno funcional
    │   │   ├── failure.dart             # Definição dos tipos de erro (Failure)
    │   │   └── result.dart              # Wrapper para sucesso (Success) e falha (Failure)
    │   ├── routes/                      # Configuração e abstração de navegação (GoRouter)
    │   │   ├── app_router.dart          # Definição das rotas e árvore de navegação
    │   │   ├── app_routes.dart          # Métodos utilitários para navegação
    │   │   ├── route_names.dart         # Identificadores únicos das rotas
    │   │   └── route_paths.dart         # Caminhos (URLs) das rotas
    │   ├── services/                    # Serviços de infraestrutura
    │   ├── theme/                       # Design System e Tematização
    │   │   ├── app_theme.dart           # Configuração dos temas (claro/escuro)
    │   │   └── theme_notifier.dart      # Gerenciamento de estado, controle e persistência do modo de tema
    │   ├── app_colors.dart              # Definição de cores globais
    │   ├── root_navigation.dart         # Widget raiz de navegação
    │   ├── shared_preferences_keys.dart # Chaves de armazenamento local
    │   └── validators.dart              # Validações reutilizáveis
    │
    ├── features/                        # Módulos independentes por funcionalidade
    │   └── <feature>/                   # Ex: activities, auth, users
    │       ├── data/                    # Implementação e acesso a dados
    │       │   ├── models/              # DTOs e serialização
    │       │   ├── services/            # Data sources (API, DB, etc.)
    │       │   └── repositories/        # Implementação dos contratos do domínio
    │       ├── domain/                  # Regras de negócio puras
    │       │   ├── entities/            # Entidades do domínio
    │       │   └── repositories/        # Contratos (interfaces)
    │       └── presentation/            # Camada de UI
    │           ├── screens/             # Telas da interface do usuário
    │           ├── viewmodels/          # Estado e lógica de apresentação da UI
    │           ├── providers/           # Provedores para gerenciamento de estado
    │           └── widgets/             # Widgets específicos da funcionalidade
    │
    └── shared/                          # Recursos globais reutilizáveis
        ├── utils/                       # Funções utilitárias e helpers (sem UI)
        └── widgets/                     # Widgets globais reutilizáveis (buttons, dialogs, etc.)
```

#### 3. Camadas da Arquitetura (por Feature)

**3.1 Domain**

A camada central e mais protegida. Contém apenas código Dart puro.

- **Entities:** Representam a verdade do negócio (ex: `Activity`).
- **Repositories (Abstract):** Definem contratos de acesso a dados, sem expor detalhes de implementação.

**3.2 Data**

Responsável por prover e persistir os dados da aplicação.

- **Models:** Representações das entidades com lógica de mapeamento (`fromMap`, `toMap`).
- **Services:** Acesso direto a fontes de dados (SQLite, APIs, etc.).
- **Repositories (Impl):** Implementam os contratos definidos no Domain, decidindo a origem dos dados.

**3.3 Presentation**

Camada responsável pela interface e interação com o usuário.

- **Screens:** Constroem a UI e observam o estado.
- **ViewModels:** Gerenciam o estado da tela e executam ações de negócio. **Regra:** não dependem de `BuildContext`.
- **Providers:** Expõem estado e ações de forma reativa (Riverpod).
- **Widgets:** Componentes visuais reutilizáveis específicos da feature.

#### 4. Gerenciamento de Estado com Riverpod

O **Riverpod** é utilizado como a ponte entre o `ViewModel` e a `View`:

- O **ViewModel** gerencia a lógica pura.
- O **Notifier** atua como um adaptador que expõe o estado de forma reativa.

Esta separação garante que o `ViewModel` possa ser testado unitariamente sem a necessidade de simular o ambiente reativo do Riverpod.

#### 5. Fluxo de Dados

O fluxo segue uma direção única para garantir previsibilidade:

```text
View (UI) → Provider (Notifier) → ViewModel (Ação) → Repository (Domain) → RepositoryImpl (Data) → Service (Database)
```

## 6. Regras de Dependência

Para manter o baixo acoplamento, o projeto segue:

1. **Dependências para dentro:**
   Camadas externas (**Presentation** e **Data**) dependem das internas.
   O **Domain é independente** e não depende de nenhuma outra camada.

2. **Abstração:**
   A **Presentation** depende de contratos definidos no **Domain**, não de implementações da **Data**.

3. **UI sem lógica de negócio:**
   A **View** apenas renderiza o estado e dispara eventos do usuário.
   Toda a lógica fica no **ViewModel**.

## 7. Camada Core

A pasta `core/` concentra tudo que é **compartilhado e transversal** à aplicação, servindo de base para todas as features:

- **`constants/`**: Dados estáticos e mocks utilizados globalmente.
- **`database/`**: Configuração do SQLite, incluindo tabelas e migrações.
- **`di/`**: Providers globais para injeção de dependência (ex: database, tema, navegação).
- **`extensions/`**: Extensões utilitárias para Dart/Flutter.
- **`result/`**: Implementação do padrão `Result`/`Failure` para tratamento funcional de erros.
- **`routes/`**: Sistema de navegação centralizado (GoRouter).
- **`services/`**: Serviços reutilizáveis de infraestrutura (ex: exportação de imagem, shared_preferences).
- **`theme/`**: Configuração de tema e controle de aparência.
- **Arquivos globais**:
  - `app_colors.dart`: Cores
  - `root_navigation.dart`: Controle de navegação raiz
  - `shared_preferences_keys.dart`: Chaves de persistência
  - `validators.dart`: Validadores

## Sistema de Navegação

A navegação foi projetada para oferecer desacoplamento, previsibilidade e escalabilidade, utilizando o **GoRouter** como solução central de roteamento.

A estrutura segue princípios da **Clean Architecture**, evitando que a interface conheça diretamente URLs, parâmetros ou detalhes técnicos da navegação.

---

### Objetivos da Estrutura

A arquitetura de navegação foi construída para:

- Centralizar o gerenciamento de rotas;
- Evitar strings espalhadas pela aplicação;
- Garantir navegação tipada e previsível;
- Facilitar manutenção e refatoração;
- Permitir deep links e URLs parametrizadas;
- Separar responsabilidades da navegação.

---

### Escolha do GoRouter

O projeto utiliza o **GoRouter** como solução oficial de navegação declarativa para Flutter.

#### Motivos da escolha

- Navegação declarativa e centralizada;
- Integração com Navigator 2.0;
- Suporte nativo a Web e Deep Linking;
- Suporte a parâmetros de rota e query params;
- Melhor organização para aplicações escaláveis;
- Navegação baseada em nomes (`pushNamed`, `goNamed`).

Exemplo:

```dart
context.pushNamed(RouteNames.login);
```

Ao utilizar nomes semânticos ao invés de strings literais, a aplicação reduz erros e melhora a manutenção.

---

### Estrutura de Navegação

```text
routes/
├── app_router.dart
├── app_routes.dart
├── route_names.dart
└── route_paths.dart
```

Cada arquivo possui uma responsabilidade específica.

| Arquivo            | Responsabilidade                                                                                          |
| ------------------ | --------------------------------------------------------------------------------------------------------- |
| `app_router.dart`  | Configuração central do `GoRouter`, árvore de rotas, telas, parâmetros, tratamento de erro e rota inicial |
| `app_routes.dart`  | Camada de abstração responsável por encapsular toda navegação da aplicação                                |
| `route_names.dart` | Identificadores semânticos das rotas                                                                      |
| `route_paths.dart` | Caminhos reais (URLs) das rotas                                                                           |

---

### app_router.dart

Responsável pela configuração central do `GoRouter`.

#### Exemplo

```dart
static final router = GoRouter(
  initialLocation: RoutePaths.splash,
);
```

#### Registro de rotas

```dart
static final router = GoRouter(
  initialLocation: RoutePaths.splash,
  routes: <GoRoute>[
    GoRoute(
      name: RouteNames.login,
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
```

#### Tratamento de erro

```dart
static final router = GoRouter(
  initialLocation: RoutePaths.splash,
  errorBuilder: (context, state) {
    return NotFoundScreen();
  },
);
```

---

### route_names.dart e route_paths.dart

As rotas foram separadas entre identificadores semânticos e caminhos reais.

#### route_names.dart

Centraliza os nomes utilizados pela navegação:

```dart
static const login = 'login';
```

Uso:

```dart
context.pushNamed(RouteNames.login);
```

#### route_paths.dart

Centraliza os caminhos reais da aplicação:

```dart
static const login = '/login';
```

Exemplo de rota parametrizada:

```dart
static const disciplineDetails =
    '/discipline-details/:disciplineId';
```

#### Benefícios da separação

- Centralização;
- Segurança contra erros de digitação;
- URLs padronizadas;
- Facilidade de refatoração;
- Suporte a Deep Linking.

---

### app_routes.dart

Camada de abstração responsável por encapsular toda navegação da aplicação.

A interface não navega diretamente utilizando `context.pushNamed()` ou `context.goNamed()`. Em vez disso, utiliza métodos semânticos centralizados.

#### Exemplo

```dart
AppRoutes.goToDisciplineDetails(
  context,
  disciplineId: 10,
);
```

#### Benefícios

- Desacoplamento completo entre a interface e a lógica de navegação;
- Padronização do fluxo de navegação em toda a aplicação;
- Maior segurança através de parâmetros tipados, evitando valores inválidos e garantindo obrigatoriedade quando necessário;
- Redução de inconsistências e erros de navegação;
- Reutilização mais eficiente das rotas e argumentos compartilhados;
- Experiência de desenvolvimento mais consistente e produtiva.

---

### Path Parameters e Query Parameters

#### Path Parameters

Utilizados quando o parâmetro representa a identidade da rota.

Exemplo:

```text
/discipline-details/5
```

Definição:

```dart
'/discipline-details/:disciplineId'
```

Leitura:

```dart
state.pathParameters['disciplineId']
```

---

#### Query Parameters

Utilizados para estados opcionais ou complementares.

Exemplo:

```text
/activity-form?disciplineId=10
```

Leitura:

```dart
state.uri.queryParameters['disciplineId']
```

#### Estratégia adotada

| Tipo             | Uso                          |
| ---------------- | ---------------------------- |
| Path Parameters  | Identidade principal da rota |
| Query Parameters | Estados opcionais            |

---

### Push vs Go

O projeto utiliza dois comportamentos distintos de navegação:

| Método        | Comportamento                        | Uso                                           |
| ------------- | ------------------------------------ | --------------------------------------------- |
| `pushNamed()` | Empilha uma nova rota sobre a atual  | detalhes, formulários e fluxos secundários    |
| `goNamed()`   | Substitui completamente a rota atual | autenticação, splash, logout e reset de fluxo |

Exemplos:

```dart
context.pushNamed(RouteNames.about);

context.goNamed(RouteNames.login);
```

---

### Fluxo de Navegação

```text
UI → AppRoutes → GoRouter → Screen
```

## 9. Organização de Widgets

Os componentes visuais são organizados em dois níveis de reutilização:

- **`shared/widgets/`**: Componentes do **Design System** (ex: botões, loaders, inputs).
  São genéricos e não possuem conhecimento de regras de negócio.

- **`features/<feature>/presentation/widgets/`**: Componentes **semânticos da feature** (ex: `GradeListTile`).
  Estão ligados ao domínio da funcionalidade e podem refletir regras específicas da mesma.

---

## Primeiros Passos

### Instalação

1. Clone o repositório:

```bash
git clone https://github.com/dariomatias-dev/academic-planner.git
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Execute o aplicativo:

```bash
flutter run
```

---

## Autor

Desenvolvido por **Dário Matias**:

- Portfolio: [https://dariomatias-dev.com](https://dariomatias-dev.com);
- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev);
- Email: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com);
- Instagram: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev);
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev).
