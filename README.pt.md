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
    ├── core/                         # Funcionalidades globais e transversais
    │   ├── constants/                # Valores imutáveis
    │   ├── database/                 # Persistência SQLite
    │   │   ├── migrations/           # Evolução do esquema do banco
    │   │   ├── tables/               # Definições de tabelas
    │   │   └── app_database.dart     # Configuração central do DB
    │   ├── di/                       # Injeção de Dependência
    │   ├── extensions/               # Extensões de classes (Dart/Flutter)
    │   ├── result/                   # Padrão de retorno funcional
    │   │   ├── failure.dart          # Tipagem de erros
    │   │   └── result.dart           # Wrapper Success/Failure
    │   ├── routes/                   # Gestão de Navegação (GoRouter)
    │   │   ├── app_router.dart
    │   │   ├── app_routes.dart
    │   │   ├── route_names.dart
    │   │   └── route_paths.dart
    │   ├── services/                 # Serviços de infraestrutura
    │   ├── theme/                    # Design System e Tematização
    │   │   ├── app_theme.dart
    │   │   └── theme_notifier.dart
    │   ├── app_colors.dart           # Cores
    │   ├── root_navigation.dart      # Widget raiz de controle
    │   ├── shared_preferences_keys.dart
    │   └── validators.dart           # Validações de negócio
    │
    ├── features/                     # Módulos independentes por funcionalidade
    │   └── <feature>/                # Ex: activity, auth, user
    │       ├── data/                 # Implementação e Acesso a Dados
    │       │   ├── models/           # DTOs e Serialização
    │       │   ├── services/         # Data Sources (Local/Remote)
    │       │   └── repositories/     # Implementação dos contratos
    │       ├── domain/               # Regras de Negócio Puras
    │       │   ├── entities/         # Objetos de domínio
    │       │   └── repositories/     # Contratos de repositório
    │       └── presentation/         # Camada de Usuário
    │           ├── screens/          # Widgets de tela
    │           ├── viewmodels/       # Componentes locais da feature
    │           └── widgets/          # Lógica de estado e UI
    │
    └── shared/                       # Recursos globais de UI e Lógica
        ├── utils/                    # Componentes atômicos (Botões, Cards)
        └── widgets/                  # Helpers agnósticos ao domínio
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

#### 8. Sistema de Rotas

Navegação baseada no **GoRouter**, organizada para evitar o acoplamento de caminhos em toda a interface:

- `route_paths.dart`: Define os caminhos literais (ex: `/disciplines`).
- `route_names.dart`: Define nomes semânticos para as rotas.
- `app_router.dart`: Configuração técnica do GoRouter.
- `app_routes.dart`: Métodos utilitários para navegação segura e desacoplada (ex: `AppRoutes.toDisciplines(context)`).

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
