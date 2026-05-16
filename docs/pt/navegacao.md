<div align="center">

# Sistema de Navegação

</div>

## Sumário

- [Visão Geral](#visão-geral)
- [Por que GoRouter](#por-que-gorouter)
- [Estrutura de Arquivos](#estrutura-de-arquivos)
- [Referência de Rotas](#referência-de-rotas)
- [Parâmetros de Rota](#parâmetros-de-rota)
- [Push vs Go](#push-vs-go)
- [Como Adicionar uma Nova Rota](#como-adicionar-uma-nova-rota)

---

## Visão Geral

A navegação foi projetada para ser **desacoplada, tipada e centralizada**. A UI nunca navega diretamente com strings ou URLs - usa métodos semânticos que encapsulam todos os detalhes de roteamento.

```text
UI → AppRoutes → GoRouter → Screen
```

Esse fluxo garante que uma mudança de rota (nome, path, parâmetros) impacte apenas os arquivos de navegação, não as telas.

---

## Por que GoRouter

O projeto usa **GoRouter** como solução oficial de navegação declarativa para Flutter.

**Motivos da escolha:**

- Navegação declarativa e centralizada (rotas definidas em um único lugar)
- Integração com Navigator 2.0 e suporte nativo a Deep Linking
- Suporte a path parameters e query parameters
- Navegação por nome com `pushNamed`/`goNamed` - sem strings literais espalhadas
- Tratamento de erros integrado (tela 404)
- Escalável para aplicações grandes

---

## Estrutura de Arquivos

```text
core/routes/
├── app_router.dart    # Configuração central do GoRouter e árvore de rotas
├── app_routes.dart    # Métodos semânticos de navegação (camada de abstração)
├── route_names.dart   # Identificadores únicos das rotas
└── route_paths.dart   # Caminhos (URLs) das rotas
```

### `route_names.dart` e `route_paths.dart`

Centralizam os identificadores e URLs. Evitam strings literais espalhadas pelo código.

```dart
// route_names.dart
static const disciplineDetails = 'discipline-details';

// route_paths.dart
static const disciplineDetails = '/discipline-details/:disciplineId';
```

### `app_router.dart`

Configura o `GoRouter` com a árvore de rotas, rota inicial e tratamento de erros:

```dart
static final router = GoRouter(
  initialLocation: RoutePaths.splash,
  errorBuilder: (context, state) => const NotFoundScreen(),
  routes: <RouteBase>[
    GoRoute(
      name: RouteNames.disciplineDetails,
      path: RoutePaths.disciplineDetails,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['disciplineId']!);
        return DisciplineDetailsScreen(disciplineId: id);
      },
    ),
    // ...
  ],
);
```

### `app_routes.dart`

Camada de abstração que encapsula toda navegação. **A UI só chama métodos daqui.**

```dart
static void goToDisciplineDetails(
  BuildContext context, {
  required int disciplineId,
}) {
  context.pushNamed(
    RouteNames.disciplineDetails,
    pathParameters: {'disciplineId': disciplineId.toString()},
  );
}
```

**Benefícios:**

- Parâmetros tipados - o compilador pega erros antes do runtime
- Um único ponto para alterar o comportamento de uma navegação
- A UI não conhece nomes de rotas, paths ou como passar parâmetros

---

## Referência de Rotas

| Nome                | Path                                | Método em AppRoutes     | Parâmetros                   |
| ------------------- | ----------------------------------- | ----------------------- | ---------------------------- |
| `splash`            | `/splash`                           | -                       | -                            |
| `login`             | `/login`                            | `goToLogin`             | -                            |
| `register`          | `/register`                         | `goToRegister`          | -                            |
| `forgotPassword`    | `/forgot-password`                  | `goToForgotPassword`    | -                            |
| `home`              | `/home`                             | `goToHome`              | -                            |
| `activities`        | `/activities`                       | `goToActivities`        | -                            |
| `activityDetails`   | `/activity-details/:activityId`     | `goToActivityDetails`   | `activityId: int`            |
| `activityForm`      | `/activity-form`                    | `goToActivityForm`      | `disciplineId: int?` (query) |
| `disciplines`       | `/disciplines`                      | `goToDisciplines`       | -                            |
| `disciplineDetails` | `/discipline-details/:disciplineId` | `goToDisciplineDetails` | `disciplineId: int`          |
| `calendar`          | `/calendar`                         | `goToCalendar`          | -                            |
| `notes`             | `/notes`                            | `goToNotes`             | -                            |
| `noteForm`          | `/note-form`                        | `goToNoteForm`          | `noteId: int?` (query)       |
| `settings`          | `/settings`                         | `goToSettings`          | -                            |
| `about`             | `/about`                            | `goToAbout`             | -                            |

---

## Parâmetros de Rota

### Path Parameters

Usados quando o parâmetro **identifica** o recurso - faz parte da URL.

```text
/discipline-details/5
```

**Definição:**

```dart
static const disciplineDetails = '/discipline-details/:disciplineId';
```

**Leitura:**

```dart
final id = state.pathParameters['disciplineId']!;
```

### Query Parameters

Usados para estados **opcionais ou complementares** - não identificam a rota.

```text
/activity-form?disciplineId=10
```

**Leitura:**

```dart
final disciplineId = state.uri.queryParameters['disciplineId'];
```

### Estratégia adotada

| Tipo            | Quando usar                                | Exemplo                          |
| --------------- | ------------------------------------------ | -------------------------------- |
| Path Parameter  | Identidade do recurso (sempre obrigatório) | `/activities/5`                  |
| Query Parameter | Contexto opcional (pode ser nulo)          | `/activity-form?disciplineId=10` |

---

## Push vs Go

O projeto usa dois comportamentos distintos de navegação:

| Método        | Comportamento                                          | Quando usar                               |
| ------------- | ------------------------------------------------------ | ----------------------------------------- |
| `pushNamed()` | Empilha nova rota sobre a atual (back button funciona) | Detalhes, formulários, fluxos secundários |
| `goNamed()`   | Substitui completamente a rota atual                   | Login, splash, logout, reset de fluxo     |

```dart
// Empilha - usuário pode voltar
AppRoutes.goToActivityDetails(context, activityId: 5);

// Substitui - sem volta (adequado para logout)
AppRoutes.goToLogin(context);
```

---

## Como Adicionar uma Nova Rota

1. **Adicione o nome** em `route_names.dart`:

```dart
static const myNewScreen = 'my-new-screen';
```

2. **Adicione o path** em `route_paths.dart`:

```dart
static const myNewScreen = '/my-new-screen';
// Com parâmetro: '/my-new-screen/:id'
```

3. **Registre a rota** em `app_router.dart`:

```dart
GoRoute(
  name: RouteNames.myNewScreen,
  path: RoutePaths.myNewScreen,
  builder: (context, state) => const MyNewScreen(),
),
```

4. **Crie o método de navegação** em `app_routes.dart`:

```dart
static void goToMyNewScreen(BuildContext context) {
  context.pushNamed(RouteNames.myNewScreen);
}
```

5. **Use na UI:**

```dart
AppRoutes.goToMyNewScreen(context);
```
