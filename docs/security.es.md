<p align="center">
<a href="security.md">English</a> · <a href="security.pt-BR.md">Português (BR)</a> · <strong>Español</strong>
</p>

# Política de Seguridad

## Versiones soportadas

Este proyecto tiene una única branch activa (`main`); solo el último release está soportado. No hay una matriz de soporte más allá de eso.

## Reportar una vulnerabilidad

Usa el [reporte privado de vulnerabilidades](https://github.com/dariomatias-dev/academic-planner/security/advisories/new) de GitHub para este repositorio, en lugar de abrir un issue público. Si eso no está disponible, escribe a [dariomatias.dev@gmail.com](mailto:dariomatias.dev@gmail.com).

Incluye, si es posible:
- Una descripción del problema y su impacto.
- Pasos para reproducirlo.
- La versión de la app o el commit probado.

## Expectativas de respuesta

Este es un proyecto solo, mantenido como hobby, sin SLA. No hay un tiempo de respuesta garantizado. Los reportes serán reconocidos y quien los reportó será acreditado una vez que se publique una corrección, con la mejor disposición posible.

## Alcance

Dentro del alcance: vulnerabilidades en el código de este repositorio - la app Flutter, su manejo de datos locales (SQLite) y su uso de Firebase (Authentication, Firestore) del lado del cliente (ej: reglas de Firestore inseguras, almacenamiento local inseguro de credenciales, fallas en el flujo de autenticación).

Fuera del alcance: vulnerabilidades en Firebase, Google Play o cualquier otro servicio de terceros del que dependa esta app - repórtalas a sus respectivos dueños. El proyecto no tiene componente de servidor propio, así que las clases de vulnerabilidad del lado del servidor (inyección SQL contra un backend del proyecto, RCE del lado del servidor, etc.) no aplican.

