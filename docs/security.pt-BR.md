<p align="center">
<a href="security.md">English</a> · <strong>Português (BR)</strong> · <a href="security.es.md">Español</a>
</p>

# Política de Segurança

## Versões suportadas

Este projeto tem uma única branch ativa (`main`); só a última release é suportada. Não há matriz de suporte além disso.

## Reportando uma vulnerabilidade

Use o [relato privado de vulnerabilidades](https://github.com/dariomatias-dev/academic-planner/security/advisories/new) do GitHub para este repositório, em vez de abrir uma issue pública. Se isso não estiver disponível, envie um e-mail para [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com).

Inclua, se possível:
- Uma descrição do problema e seu impacto.
- Passos para reproduzi-lo.
- A versão do app ou commit testado.

## Expectativa de resposta

Este é um projeto solo, mantido como hobby, sem SLA. Não há prazo de resposta garantido. Relatos serão reconhecidos e quem reportou será creditado quando uma correção for lançada, em regime de melhor esforço.

## Escopo

No escopo: vulnerabilidades no código deste repositório - o app Flutter, seu tratamento de dados locais (SQLite) e seu uso do Firebase (Authentication, Firestore) do lado cliente (ex: regras do Firestore inseguras, armazenamento local inseguro de credenciais, falhas no fluxo de autenticação).

Fora do escopo: vulnerabilidades no Firebase, Google Play ou qualquer outro serviço de terceiros do qual este app depende - reporte-as aos respectivos donos. O projeto não tem componente de servidor próprio, então classes de vulnerabilidade server-side (injeção SQL contra um backend do projeto, RCE server-side, etc.) não se aplicam.

