<div align="center">

# Tecnologias

</div>

## Sumário

- [Stack Principal](#stack-principal)
- [Estado e DI](#estado-e-di)
- [Persistência](#persistência)
- [Autenticação e Backend](#autenticação-e-backend)
- [Navegação](#navegação)
- [UI e Design](#ui-e-design)
- [Utilitários](#utilitários)
- [Dev e Ferramentas](#dev-e-ferramentas)

---

## Stack Principal

| Tecnologia                      | Versão      | Papel no projeto             |
| ------------------------------- | ----------- | ---------------------------- |
| [Flutter](https://flutter.dev/) | 3.35.0      | Framework UI multiplataforma |
| [Dart](https://dart.dev/)       | SDK ^3.10.4 | Linguagem de programação     |

---

## Estado e DI

| Pacote                                                        | Versão | Papel no projeto                                         |
| ------------------------------------------------------------- | ------ | -------------------------------------------------------- |
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | 3.3.1  | Gerenciamento de estado reativo e injeção de dependência |
| [riverpod](https://pub.dev/packages/riverpod)                 | 3.2.1  | Core do Riverpod (sem Flutter) - usado no Domain         |

**Por que Riverpod:** solução compile-safe que unifica gerenciamento de estado e DI. Providers podem ser acessados sem `BuildContext`, testados com sobrescritas e compostos sem boilerplate. Ver [arquitetura.md - Gerenciamento de Estado](arquitetura.md#gerenciamento-de-estado-com-riverpod).

---

## Persistência

| Pacote                                                            | Versão | Papel no projeto                                   |
| ----------------------------------------------------------------- | ------ | -------------------------------------------------- |
| [sqflite](https://pub.dev/packages/sqflite)                       | 2.4.2  | Banco de dados SQLite local                        |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 2.5.5  | Persistência de preferências simples (tema, flags) |

**Por que SQLite:** dados relacionais complexos (atividades, notas, disciplinas) precisam de queries, junções e migrações versionadas - SQLite via sqflite é a escolha natural para Flutter offline-first.

---

## Autenticação e Backend

| Pacote                                                      | Versão | Papel no projeto                              |
| ----------------------------------------------------------- | ------ | --------------------------------------------- |
| [firebase_core](https://pub.dev/packages/firebase_core)     | 4.7.0  | Inicialização do Firebase                     |
| [firebase_auth](https://pub.dev/packages/firebase_auth)     | 6.4.0  | Autenticação de usuários                      |
| [cloud_firestore](https://pub.dev/packages/cloud_firestore) | 6.3.0  | Banco de dados em nuvem para dados de usuário |

O projeto adota uma arquitetura **híbrida de persistência**: dados locais (atividades, notas) ficam no SQLite; dados de usuário e autenticação ficam no Firebase. Isso garante funcionamento offline para as funcionalidades principais.

---

## Navegação

| Pacote                                          | Versão | Papel no projeto                        |
| ----------------------------------------------- | ------ | --------------------------------------- |
| [go_router](https://pub.dev/packages/go_router) | 17.1.0 | Roteamento declarativo com Deep Linking |

Ver [navegacao.md](navegacao.md) para documentação completa do sistema de navegação.

---

## UI e Design

| Pacote                                                                                | Versão  | Papel no projeto                  |
| ------------------------------------------------------------------------------------- | ------- | --------------------------------- |
| [google_fonts](https://pub.dev/packages/google_fonts)                                 | 8.0.2   | Tipografia (fontes do Google)     |
| [syncfusion_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar)   | 33.1.46 | Componente de calendário avançado |
| [syncfusion_flutter_pdfviewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) | 33.1.44 | Visualizador de PDF integrado     |
| [carousel_slider](https://pub.dev/packages/carousel_slider)                           | 5.1.2   | Carrossel de imagens/cards        |
| [flutter_quill](https://pub.dev/packages/flutter_quill)                               | 11.5.0  | Editor rich text para anotações   |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)                           | 1.0.8   | Ícones no estilo iOS              |

---

## Utilitários

| Pacote                                                                        | Versão | Papel no projeto                                   |
| ----------------------------------------------------------------------------- | ------ | -------------------------------------------------- |
| [intl](https://pub.dev/packages/intl)                                         | 0.20.2 | Formatação de datas, números e internacionalização |
| [uuid](https://pub.dev/packages/uuid)                                         | 4.5.3  | Geração de identificadores únicos                  |
| [url_launcher](https://pub.dev/packages/url_launcher)                         | 6.3.2  | Abertura de URLs externas                          |
| [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus) | 4.0.1  | Exportação de imagens para a galeria               |
| [package_info_plus](https://pub.dev/packages/package_info_plus)               | 9.0.1  | Leitura de informações do pacote (versão do app)   |
| [fluttertoast](https://pub.dev/packages/fluttertoast)                         | 9.0.0  | Notificações toast nativas                         |
| [logger](https://pub.dev/packages/logger)                                     | 2.7.0  | Logging estruturado com níveis                     |

---

## Dev e Ferramentas

| Pacote                                                                            | Versão  | Papel no projeto                                                  |
| --------------------------------------------------------------------------------- | ------- | ----------------------------------------------------------------- |
| [flutter_lints](https://pub.dev/packages/flutter_lints)                           | 6.0.0   | Regras de lint recomendadas para Flutter                          |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)         | 0.14.4  | Geração de ícones do app para todas as plataformas                |
| [flutter_localizations](https://flutter.dev/)                                     | SDK     | Suporte a localização e internacionalização                       |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)                 | 2.3.7+1 | Driver SQLite via FFI para rodar scripts de seed no desktop       |

---

## Sobre as Versões

As versões listadas são as **resolvidas no `pubspec.lock`** - versões exatas em uso, não os ranges do `pubspec.yaml`. Para atualizar:

```bash
# Ver dependências desatualizadas
flutter pub outdated

# Atualizar dentro dos ranges definidos
flutter pub upgrade

# Atualizar para novas versões major (atenção a breaking changes)
flutter pub upgrade --major-versions
```
