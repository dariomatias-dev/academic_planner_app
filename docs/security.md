<p align="center">
<strong>English</strong> · <a href="security.pt-BR.md">Português (BR)</a> · <a href="security.es.md">Español</a>
</p>

# Security Policy

## Supported versions

This project has a single active branch (`main`); only the latest release is supported. There is no support matrix beyond that.

## Reporting a vulnerability

Please use GitHub's [private vulnerability reporting](https://github.com/dariomatias-dev/academic-planner/security/advisories/new) for this repository instead of opening a public issue. If that isn't available, email [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com).

Include, if possible:
- A description of the issue and its impact.
- Steps to reproduce it.
- The app version or commit you tested against.

## Response expectations

This is a solo, hobby-maintained project with no SLA. There is no guaranteed response time. Reports will be acknowledged and reporters credited once a fix ships, on a best-effort basis.

## Scope

In scope: vulnerabilities in this repository's own code — the Flutter app, its local data handling (SQLite), and its use of Firebase (Authentication, Firestore) from the client side (e.g. insecure Firestore rules, insecure local storage of credentials, auth flow flaws).

Out of scope: vulnerabilities in Firebase, Google Play, or any other third-party service this app depends on — report those to their respective owners. The project has no server component of its own, so server-side vulnerability classes (SQL injection against a project-owned backend, server-side RCE, etc.) don't apply.

