<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.35.0-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-SDK%20^3.10.4-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Riverpod-3.3.1-08479E?style=for-the-badge" alt="Riverpod">
<img src="https://img.shields.io/badge/Arquitetura-MVVM%20%2B%20Clean%20%2B%20Feature--First-green?style=for-the-badge" alt="Arquitetura">

</div>

<br>

<p align="center">
<strong>Idioma:</strong>
<a href="README.md">English</a> | <strong>Português</strong>
</p>

<h1 align="center">Planejador Acadêmico</h1>

<p align="center">
  Projeto de referência para arquitetura <strong>MVVM + Clean Architecture + Feature-First</strong> em Flutter.
  <br><br>
  <a href="https://github.com/dariomatias-dev/academic-planner/issues">Reportar Bug</a> ·
  <a href="https://github.com/dariomatias-dev/academic-planner/issues">Solicitar Funcionalidade</a>
</p>

---

## Sumário

- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Arquitetura](#arquitetura)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Tecnologias Principais](#tecnologias-principais)
- [Primeiros Passos](#primeiros-passos)
- [Documentação](#documentação)
- [Autor](#autor)

---

## Sobre o Projeto

O Planejador Acadêmico é um aplicativo de gestão de rotina estudantil que serve como **projeto de referência arquitetural**. O objetivo principal não é apenas a funcionalidade em si, é demonstrar como estruturar uma aplicação Flutter de médio/grande porte utilizando:

- **Feature-First**: organização de código por domínio de negócio
- **Clean Architecture**: separação de responsabilidades em camadas com regras de dependência explícitas
- **MVVM**: desacoplamento entre UI e lógica de apresentação

Cada decisão arquitetural está documentada com justificativa. O projeto é intencional: não há atalhos que comprometam a estrutura para ganhar velocidade de desenvolvimento.

---

## Funcionalidades

| Funcionalidade    | Descrição                                                                                     |
| ----------------- | --------------------------------------------------------------------------------------------- |
| Atividades        | Criação, edição e exclusão de atividades acadêmicas com filtros por status, data e disciplina |
| Disciplinas       | Gerenciamento de disciplinas por período com detalhes de horário e professor                  |
| Agenda            | Visão de calendário com atividades agrupadas por data                                         |
| Anotações         | Editor rich text para criação de notas vinculadas a disciplinas                               |
| Grade de Horários | Visualização da grade semanal de aulas                                                        |
| Categorias e Tags | Organização de atividades por categorias e tags personalizadas                                |
| Autenticação      | Login, cadastro e recuperação de senha via Firebase Auth                                      |
| Configurações     | Alternância de tema claro/escuro com persistência local                                       |
| Sobre             | Informações do app com versão e link para o código-fonte                                      |

---

## Arquitetura

O projeto combina três abordagens complementares:

```
Feature-First  ->  como o código é organizado em pastas
Clean Arch     ->  como as camadas se comunicam (regras de dependência)
MVVM           ->  como a UI se conecta à lógica de negócio
```

### Por que essas três?

**Feature-First** resolve o problema de organização: em vez de agrupar arquivos por tipo técnico (todos os models juntos, todas as telas juntas), agrupa por domínio de negócio. Cada feature é um módulo isolado - alterar `activities` não exige abrir pastas de outras funcionalidades.

**Clean Architecture** resolve o problema de dependências: define regras explícitas sobre qual camada pode depender de qual. O Domain (regras de negócio) é Dart puro, sem dependências externas. A UI nunca acessa o banco de dados diretamente.

**MVVM** resolve o problema de acoplamento na UI: a tela nunca contém lógica. O ViewModel gerencia o estado da tela sem depender de `BuildContext` - é testável isoladamente.

Dentro de cada feature:

```text
features/activities/
├── domain/          # Entidades e contratos (Dart puro, zero dependências)
├── data/            # Models, datasources e implementações dos repositórios
├── presentation/    # Screens, ViewModels, Providers e Widgets
└── di/              # Injeção de dependência da feature
```

Fluxo de dados:

```
Screen -> Provider -> ViewModel -> Repository (contrato) -> RepositoryImpl -> DataSource
```

> Documentação completa com exemplos de código: [docs/pt/arquitetura.md](docs/pt/arquitetura.md)

---

## Estrutura de Pastas

```text
lib/src/
├── core/        # Infraestrutura global (banco, rotas, tema, DI, logging)
├── data/        # Seeds de desenvolvimento
├── features/    # 17 módulos de negócio isolados
└── shared/      # Design System e utilitários globais
```

Features existentes: `about`, `activities`, `auth`, `calendar`, `categories`, `course_details`, `disciplines`, `home`, `notes`, `not_found`, `pdf_viewer`, `schedule`, `settings`, `splash`, `tags`, `teacher`, `users`.

> Árvore completa comentada com detalhamento de cada pasta: [docs/pt/estrutura.md](docs/pt/estrutura.md)

---

## Tecnologias Principais

| Tecnologia       | Versão  | Papel                        |
| ---------------- | ------- | ---------------------------- |
| Flutter          | 3.35.0  | Framework UI                 |
| Dart SDK         | ^3.10.4 | Linguagem                    |
| flutter_riverpod | 3.3.1   | Gerenciamento de estado e DI |
| go_router        | 17.1.0  | Navegação declarativa        |
| sqflite          | 2.4.2   | Persistência local (SQLite)  |
| firebase_auth    | 6.4.0   | Autenticação                 |
| cloud_firestore  | 6.3.0   | Backend em nuvem             |
| flutter_quill    | 11.5.0  | Editor rich text             |

> Lista completa com versões exatas e justificativa de cada escolha: [docs/pt/tecnologias.md](docs/pt/tecnologias.md)

---

## Primeiros Passos

### Pré-requisitos

- Flutter 3.35.0+
- Dart SDK ^3.10.4
- Projeto Firebase configurado (para autenticação e Firestore)

### Instalação

```bash
# Clone o repositório
git clone https://github.com/dariomatias-dev/academic_planner_app.git

# Instale as dependências
flutter pub get

# Execute o aplicativo
flutter run
```

---

## Documentação

A documentação está organizada em arquivos separados por tema para facilitar a navegação:

| Documento                                    | O que você encontra                                                                                                                         |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| [Arquitetura](docs/pt/arquitetura.md)        | Explicação detalhada de MVVM, Clean Architecture e Feature-First, com exemplos de código do próprio projeto e justificativa de cada escolha |
| [Estrutura do Projeto](docs/pt/estrutura.md) | Árvore de pastas completa e comentada, detalhamento de cada seção e tabela com todas as features existentes                                 |
| [Navegação](docs/pt/navegacao.md)            | Como o sistema de rotas funciona com GoRouter, referência completa de rotas e guia para adicionar novas                                     |
| [Tecnologias](docs/pt/tecnologias.md)        | Todas as dependências com versões exatas (do `pubspec.lock`) e motivo de cada escolha                                                       |

---

## Autor

Desenvolvido por **Dário Matias**:

- Portfolio: [https://dariomatias-dev.com](https://dariomatias-dev.com)
- GitHub: [https://github.com/dariomatias-dev](https://github.com/dariomatias-dev)
- Email: [matiasdario75@gmail.com](mailto:matiasdario75@gmail.com)
- Instagram: [https://instagram.com/dariomatias_dev](https://instagram.com/dariomatias_dev)
- LinkedIn: [https://linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
