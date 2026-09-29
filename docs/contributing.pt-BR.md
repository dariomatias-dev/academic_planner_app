<p align="center">
<a href="contributing.md">English</a> · <strong>Português (BR)</strong> · <a href="contributing.es.md">Español</a>
</p>

# Contribuindo

## Configuração

A versão do Flutter SDK é fixada via [fvm](https://fvm.app/) (`.fvmrc`). Depois de clonar:

```bash
fvm flutter pub get
git config core.hooksPath .githooks
```

O segundo comando ativa dois hooks do git:
- `commit-msg` rejeita commits que não seguem [Conventional Commits](#convenções-de-commit-e-branch).
- `pre-push` roda [o gate local](#o-gate-local) antes de cada push.

## Antes de abrir um pull request

- [ ] O código segue a estrutura e as regras de camadas do projeto — ver [Arquitetura](architecture.pt-BR.md) e [CLAUDE.md](../CLAUDE.md#where-code-goes).
- [ ] `fvm dart format .` foi executado.
- [ ] `fvm flutter analyze` não reporta problemas (lints do `very_good_analysis`).
- [ ] Comportamento novo ou alterado tem cobertura de teste; `test/` espelha `lib/` — ver [CLAUDE.md](../CLAUDE.md#tests).
- [ ] README, este documento ou outra doc foram atualizados se a mudança os afeta — ver [CLAUDE.md](../CLAUDE.md#side-effects).
- [ ] A mensagem de commit segue [Conventional Commits](#convenções-de-commit-e-branch).
- [ ] Uma mudança lógica por PR; mantenha pequeno e revisável.

## O gate local

```bash
scripts/verify.sh --all
```

Espelha o que o CI verifica: geração de código, formatação, análise, testes e o piso de cobertura, para o app e (quando tem mudanças, ou com `--all`) para `packages/app_ui`. Ver a [tabela de Scripts](../README.pt-BR.md#scripts) para os outros modos disponíveis.

## O que o CI verifica

| Job                | O que faz                                                                                                            | Bloqueia o merge? |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `analyze-and-test` | `build_runner build` (falha se os arquivos `*.g.dart` gerados diferirem dos versionados), `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test --coverage`, depois checa o piso de cobertura de 80% (`scripts/check_coverage.sh`) | Sim                |
| `app-ui`           | Formatação, análise e testes (com piso de cobertura de 80% quando o pacote tiver código) do pacote do design system local em `packages/app_ui`, enviados ao Codecov com a flag `app_ui` | Sim |
| `osv-scan`         | Varre o `pubspec.lock` com o [OSV-Scanner](https://github.com/google/osv-scanner) em busca de dependências com vulnerabilidades conhecidas | Não (`continue-on-error: true`) |
| `integration`      | Roda cada suíte `integration_test/*_test.dart` em um emulador Android API 35 (KVM), uma por vez e com o app encerrado à força entre elas (`scripts/integration.sh`). Roda depois que `analyze-and-test` passa | Não (novo; passará a bloquear quando estiver estável) |
| `build_apk`        | Gera o APK de release (`flutter build apk --release`) e sobe como artefato do workflow, mantido por 14 dias. Roda depois que `analyze-and-test` passa | Não (depende de `analyze-and-test`, que bloqueia) |

Roda em todo push e pull request pra `main`, e também pode ser disparado manualmente (`workflow_dispatch`). A versão do Flutter é lida de `.fvmrc`, então sempre casa com o que está fixado localmente. Execuções superadas na mesma branch são canceladas automaticamente.

## Reproduzindo o CI localmente

`scripts/verify.sh --all` roda as mesmas verificações, na mesma ordem, do job `analyze-and-test`. Uma execução local verde é um sinal forte, não uma garantia - o CI instala seu próprio toolchain do zero e pode revelar problemas que um ambiente local "aquecido" esconde.

## Trabalhando com um agente de IA

Este repositório carrega configuração de agente para uso com Claude Code:
- [CLAUDE.md](../CLAUDE.md) — comandos, onde o código vai, convenções de teste, escopo de commit e o protocolo de trabalho por etapa.
- `.claude/settings.json` e `.claude/hooks/` — hooks que formatam ao escrever e rodam o gate local antes de finalizar uma resposta.

Mudar o acordo de trabalho ou os hooks é uma mudança normal neste repositório, revisada como qualquer outra — abra um PR.

## Atualizações de dependências

O [Renovate](https://docs.renovatebot.com/) abre PRs pra dependências desatualizadas, configurado em `renovate.json`. GitHub Actions e pacotes Firebase (`firebase_*`, `cloud_firestore`) são agrupados cada um num único PR; o resto ganha PR próprio. O `intl` é excluído — ele precisa casar exatamente com a versão que o `flutter_localizations` fixa pro Flutter SDK atual, então é atualizado [junto com o Flutter](#configuração), nunca sozinho.

Um PR do Renovate é triado como qualquer outro: só mergeia depois que [o gate local](#o-gate-local) e o CI ficarem verdes.

## Fluxo de versão

Releases são automatizadas pelo [release-please](https://github.com/googleapis/release-please), guiado inteiramente pelos Conventional Commits em `main`:

1. Todo push pra `main` roda o workflow `release-please`, que mantém um "release PR" atualizado — título, bump de versão e entradas do `CHANGELOG.md` são derivados dos commits mergeados desde a última release (`feat` → minor, `fix` → patch, um rodapé `!`/`BREAKING CHANGE` → major).
2. Fazer merge desse PR aumenta a versão em `pubspec.yaml`, atualiza o `CHANGELOG.md`, e cria uma GitHub Release com uma tag correspondente.
3. Publicar a release dispara o workflow `release`, que builda o APK de release e o anexa nessa release como `academic_planner-<tag>.apk`.

Nada da versão é editado à mão — o `pubspec.yaml` e o `CHANGELOG.md` são arquivos gerenciados pelo release-please.

## Assinatura de release

Builds de release caem na chave de debug a menos que `android/key.properties` exista (ver `android/app/build.gradle.kts`). Pra assinar uma build de release localmente:

1. Gere uma keystore:
   ```bash
   keytool -genkey -v -keystore ~/academic-planner-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias academic-planner
   ```
2. Crie `android/key.properties` (gitignorado — nunca commite ele nem o `.jks`):
   ```properties
   storePassword=<senha>
   keyPassword=<senha>
   keyAlias=academic-planner
   storeFile=/caminho/absoluto/para/academic-planner-release.jks
   ```
3. `fvm flutter build apk --release` agora assina com essa keystore.

## Convenções de commit e branch

Este projeto segue [Conventional Commits](https://www.conventionalcommits.org):

```
<type>(<scope>): <subject>
```

- **type**: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `perf`, `build`, `ci`, `revert`
- **scope**: opcional, minúsculo, ex: `activities`, `schedule`, `seeds`
- **subject**: modo imperativo, sem ponto final, ≤72 caracteres

Exemplos:

```
feat(activities): add recurring activity support
fix(schedule): prevent overlapping class entries
refactor(seeds): encapsulate repository creation in ActivitySeed
```

O corpo (opcional) explica *por quê*, não *o quê* — o diff já mostra o que mudou.

Nomes de branch: `<type>/<descrição-curta>` (ex: `feat/recurring-activities`, `fix/schedule-overlap`).

`main` é protegida: sem push direto, merges só via pull request. Só squash ou rebase merge - sem merge commits, pra manter o histórico linear e cada entrada um Conventional Commit válido. Para este repositório (mantenedor único), self-merge após o CI passar é permitido; a proteção de branch ainda exige o fluxo de PR e os checks passando.

