<br>
<div align="center">
<img src="https://img.shields.io/badge/Flutter-3.44.9-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter: 3.44.9">
<img src="https://img.shields.io/badge/Dart-SDK%20^3.12.2-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart: SDK ^3.12.2">
<img src="https://img.shields.io/badge/Riverpod-3.4.3-08479E?style=for-the-badge" alt="Riverpod: 3.4.3">
<img src="https://img.shields.io/badge/Arquitetura-MVVM%20%2B%20Clean%20%2B%20Feature--First-green?style=for-the-badge" alt="Arquitetura: MVVM + Clean + Feature-First">
<img src="https://github.com/dariomatias-dev/academic-planner/actions/workflows/ci.yaml/badge.svg?branch=main&style=for-the-badge" alt="CI: status">
<img src="https://codecov.io/gh/dariomatias-dev/academic-planner/branch/main/graph/badge.svg?flag=app" alt="Cobertura: codecov">
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" alt="Licença: MIT">
</div>
<br>

<p align="center">
<a href="README.md">English</a> · <strong>Português (BR)</strong> · <a href="README.es.md">Español</a>
</p>

<h1 align="center">Planejador Acadêmico</h1>

<p align="center">
Projeto de referência para arquitetura <strong>MVVM + Clean Architecture + Feature-First</strong> em Flutter.
<br>
<a href="#sobre-o-projeto"><strong>Explore a documentação »</strong></a>
<br>
<br>
<a href="https://github.com/dariomatias-dev/academic-planner/issues">Reportar Bug</a>
·
<a href="https://github.com/dariomatias-dev/academic-planner/issues">Solicitar Funcionalidade</a>
</p>

## Sumário

- [Sobre o Projeto](#sobre-o-projeto)
- [Prévia](#prévia)
- [Funcionalidades](#funcionalidades)
- [Stack Tecnológica](#stack-tecnológica)
- [Arquitetura](#arquitetura)
- [Primeiros Passos](#primeiros-passos)
- [Scripts](#scripts)
- [Testes](#testes)
- [Documentação](#documentação)
- [Contribuindo](#contribuindo)
- [Segurança](#segurança)
- [Licença](#licença)
- [Autor](#autor)

## Sobre o Projeto

O Planejador Acadêmico é um aplicativo de gestão de rotina estudantil que serve como **projeto de referência arquitetural**. O objetivo principal não é apenas a funcionalidade em si, é demonstrar como estruturar uma aplicação Flutter de médio/grande porte utilizando:

- **Feature-First**: organização de código por domínio de negócio
- **Clean Architecture**: separação de responsabilidades em camadas com regras de dependência explícitas
- **MVVM**: desacoplamento entre UI e lógica de apresentação

Cada decisão arquitetural está documentada com justificativa. O projeto é intencional: não há atalhos que comprometam a estrutura para ganhar velocidade de desenvolvimento.

## Prévia

<div align="center">
<img src="screenshots/01_home.png" width="200" alt="Início"/>
<img src="screenshots/02_agenda.png" width="200" alt="Agenda"/>
<img src="screenshots/03_activities.png" width="200" alt="Atividades"/>
<img src="screenshots/04_activity_details.png" width="200" alt="Detalhes da atividade"/>
<img src="screenshots/05_my_disciplines.png" width="200" alt="Minhas disciplinas"/>
<img src="screenshots/06_discipline_details.png" width="200" alt="Detalhes da disciplina"/>
<img src="screenshots/07_settings.png" width="200" alt="Configurações"/>
<img src="screenshots/08_categories.png" width="200" alt="Categorias"/>
<img src="screenshots/09_tags.png" width="200" alt="Tags"/>
<img src="screenshots/10_about.png" width="200" alt="Sobre"/>
</div>

## Funcionalidades

| Funcionalidade    | Descrição                                                                                     |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| Atividades        | Criação, edição e exclusão de atividades acadêmicas com filtros por status, data e disciplina |
| Disciplinas       | Gerenciamento de disciplinas por período com detalhes de horário e professor                  |
| Agenda            | Visão de calendário com atividades agrupadas por data                                         |
| Anotações         | Editor rich text para criação de notas vinculadas a disciplinas                               |
| Grade de Horários | Visualização da grade semanal de aulas                                                        |
| Categorias e Tags | Organização de atividades por categorias e tags personalizadas                                |
| Autenticação      | Login, cadastro e recuperação de senha via Firebase Auth                                      |
| Configurações     | Alternância de tema claro/escuro com persistência local                                       |
| Sobre             | Informações do app com versão e link para o código-fonte                                      |

## Stack Tecnológica

| Papel                   | Tecnologia                                               |
| -------------------------- | ------------------------------------------------------------ |
| Framework               | Flutter 3.44.9, Dart SDK ^3.12.2                        |
| Estado e DI             | flutter_riverpod                                        |
| Persistência local      | sqflite (SQLite), shared_preferences                    |
| Backend e Autenticação  | firebase_auth, google_sign_in, cloud_firestore           |
| Navegação               | go_router                                                |
| UI rica                 | flutter_quill, syncfusion_flutter_calendar, google_fonts |

> Cada dependência com sua versão exata resolvida e papel: [docs/architecture.pt-BR.md](docs/architecture.pt-BR.md#tecnologias)

## Arquitetura

Feature-First + Clean Architecture + MVVM. Cada feature em `lib/src/features/<feature>/` tem suas próprias camadas `domain/` (Dart puro, zero dependências), `data/`, `presentation/` e `di/`, e nenhuma feature importa a `presentation/` de outra:

```
Screen -> Provider -> ViewModel -> Repository (contrato) -> RepositoryImpl -> DataSource
```

> Explicação completa com exemplos de código, a árvore de pastas comentada e o sistema de navegação com GoRouter: [docs/architecture.pt-BR.md](docs/architecture.pt-BR.md)

## Primeiros Passos

### Pré-requisitos

- Flutter 3.44.9+ (fixado via [fvm](https://fvm.app/), ver `.fvmrc`)
- Dart SDK ^3.12.2
- Projeto Firebase configurado (para autenticação e Firestore)

### Configuração do Firebase

O projeto usa Firebase Authentication (e-mail/senha e Google) e Cloud Firestore para dados de usuário. Com o projeto Firebase criado e conectado (ver Pré-requisitos), as configurações a seguir devem ser feitas no Console do Firebase:

**1. Habilitar os provedores de login**

Acesse **Authentication → Sign-in method** e habilite os provedores **E-mail/senha** e **Google**.

**2. Cadastrar a fingerprint SHA-1 do app (obrigatório para o login com Google no Android)**

O provedor Google valida o app pela fingerprint do certificado de assinatura. Sem essa fingerprint registrada, o login com Google falha com um erro genérico, ainda que o provedor esteja configurado como habilitado.

1. Obtenha a fingerprint SHA-1 da keystore de debug:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
2. Em **Project Settings → seu app Android → Add fingerprint**, insira o valor de `SHA1`.
3. Faça o download do `google-services.json` atualizado e substitua `android/app/google-services.json`.
4. Execute `fvm flutter clean && fvm flutter pub get`.

> Antes de publicar o aplicativo, repita este procedimento com a SHA-1 da keystore de **release**; a fingerprint de debug cobre apenas builds locais.

**Justificativa:** até que uma fingerprint SHA-1 seja registrada, o array `oauth_client` do `google-services.json` permanece vazio, e toda tentativa de login com Google resulta em `UnknownFailure`.

### Instalação

```bash
# Clone o repositório
git clone https://github.com/dariomatias-dev/academic-planner.git
cd academic-planner

# Instale as dependências
fvm flutter pub get

# Execute o aplicativo
fvm flutter run
```

### Seeds de Desenvolvimento

Seeds populam o banco com dados de exemplo para desenvolvimento. Inativas por padrão, nunca executam em builds de release.

```bash
# Rodar o app com seeds no primeiro launch (somente debug)
fvm flutter run --dart-define=SEED_ENABLED=true

# Rodar seeds como script standalone (sem emulador)
dart run scripts/seed.dart
```

## Scripts

Scripts utilitários ficam em `scripts/`.

| Script       | Comando                             | Descrição                                                                                                                                                    |
| ------------ | ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `seed`       | `dart run scripts/seed.dart`        | Popula o banco com dados de exemplo para desenvolvimento local (ver [Seeds de Desenvolvimento](#seeds-de-desenvolvimento)).                                 |
| `screenshot` | `scripts/screenshot.sh [device-id]` | Percorre as principais telas do app em um dispositivo ou emulador conectado e salva uma captura de cada uma em `screenshots/`, usadas no README. Rode `fvm flutter devices` para listar os ids de dispositivos disponíveis. |
| `check_coverage` | `scripts/check_coverage.sh <lcov-file> <minimum-percent>` | Falha se a cobertura de linhas de um relatório lcov estiver abaixo do mínimo informado, excluindo arquivos gerados (`*.g.dart`). |
| `verify` | `scripts/verify.sh [--all] [--skip-tests]` | Gate de verificação local que espelha o CI: geração de código, format, analyze, test e o piso de cobertura. Por padrão escopado às mudanças pendentes; `--all` verifica o repositório inteiro e é pulado se nada mudou desde a última execução bem-sucedida (ver [The local gate](docs/contributing.pt-BR.md#o-gate-local)). |
| `workspace_hash` | `scripts/workspace_hash.sh` | Imprime um hash que representa o estado atual do workspace (último commit mais mudanças pendentes), usado pelo `verify.sh` para detectar execuções redundantes. |

## Testes

```bash
fvm flutter test              # testes unitários e de widget
fvm flutter test --coverage   # com relatório de cobertura lcov
```

`test/` espelha `lib/` caminho a caminho. [test/provider_graph_smoke_test.dart](test/provider_graph_smoke_test.dart) resolve todos os providers do Riverpod do app com overrides mínimos, pra pegar erros de wiring que o teste de um provider isolado não pegaria. `integration_test/` cobre fluxos ponta a ponta e gera as capturas de tela acima via `scripts/screenshot.sh`.

```bash
scripts/verify.sh --all
```

roda as mesmas verificações do CI — format, analyze, test — e um piso de cobertura de linhas de 80%.

## Documentação

A documentação está organizada em arquivos separados por tema para facilitar a navegação:

| Documento                                | O que você encontra                                                                                                                                                                                              |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Arquitetura](docs/architecture.pt-BR.md) | MVVM, Clean Architecture e Feature-First com exemplos de código e justificativa; a árvore de pastas completa; o sistema de navegação com GoRouter e referência completa de rotas; e cada dependência com versão exata e papel |

## Contribuindo

Contribuições são bem-vindas. Veja [docs/contributing.pt-BR.md](docs/contributing.pt-BR.md) para o setup local, o checklist pré-PR e as convenções de mensagens de commit e branching deste projeto:

```bash
scripts/verify.sh --all
```

## Segurança

Encontrou uma vulnerabilidade? Não abra uma issue pública — veja [docs/security.pt-BR.md](docs/security.pt-BR.md) para como reportá-la em particular.

## Licença

Distribuído sob a Licença MIT. Veja [LICENSE](LICENSE) para o texto completo.

## Autor

Desenvolvido por **Dário Matias**:

- **Portfólio**: [dariomatias-dev](https://dariomatias-dev.com)
- **GitHub**: [dariomatias-dev](https://github.com/dariomatias-dev)
- **Email**: [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com)
- **Instagram**: [@dariomatias_dev](https://instagram.com/dariomatias_dev)
- **LinkedIn**: [linkedin.com/in/dariomatias-dev](https://linkedin.com/in/dariomatias-dev)
