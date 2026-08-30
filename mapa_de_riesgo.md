# Mapa de riesgo del proyecto

**Grupo:** G15
**Integrantes:** Santiago Sánchez Esquivel
**Fecha:** 27 de agosto de 2026


## Ronda 1: hallazgos en el código

Escala de la tercera columna: **directo** (apareció en la primera búsqueda),
**con vueltas** (hubo que abrir varios archivos antes), **no lo encontramos**.

| # | Pregunta | Archivo y línea | ¿Cuánto costó? | Lo que llama la atención |
|---|---|---|---|---|
| 1 | ¿Dónde se verifica la contraseña al iniciar sesión? | `app/core/security.py:24`  | indirecto | El error de "contraseña incorrecta" y "usuario no existe" devuelven el mismo mensaje (`auth.py:22-26`), pero no dicen cuál de los dos pasó, bueno para seguridad|
| 2 | ¿Cuánto dura un token de sesión antes de expirar? | `app/core/config.py:6` | indirecto | `ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 8` = 8 días. Es bastante tiempo para un token |
| 3 | ¿Dónde guarda el navegador el token, y qué hace la aplicación ante un `401`? | `services/api.ts:14` guarda en `localStorage`; `api.ts:24-27` maneja el `401` | indirecto | Ante un `401`, el interceptor borra `token`/`user` de `localStorage` y redirige a `/login` |
| 4 | ¿Qué código HTTP devuelve la API si el token es inválido? ¿Y si es válido pero el usuario ya no existe? | `app/api/dependencies.py:32-35` (403) y `:37-38` (404), en `get_current_user` | indirecto | Token inválido/expirado devuelve **403** ("Forbidden"), pero debería ser **401** |
| 5 | ¿Dónde se decide si alguien es administrador? | `app/api/dependencies.py:48-55`  | indirecto |  `get_current_active_admin`, revisa `current_user.is_admin` |
| 6 | ¿Qué endpoints se pueden llamar sin estar autenticado? | `auth.py:15` (`POST /api/auth/login`) y `users.py:29` (`POST /api/users/register`) | directo | Son los únicos dos sin `current_user` |
| 7 | ¿Qué impide que dos personas modifiquen el mismo entrenamiento a la vez? |  | indirecto | **No lo encontramos.** |

## Ronda 2: riesgo por módulo

Impacto y probabilidad van de 1 a 5. El riesgo es el producto de ambos, y sirve para ordenar los módulos, no para medir cuánto probar.

| Módulo | Impacto (1-5) | Probabilidad (1-5) | Riesgo | ¿Por qué? |
|---|---|---|---|---|
| Autenticación y tokens | 5 | 3 | 15 | Si falla, nadie entra (o peor, alguien entra sin ser quien dice) |
| Registro de entrenamientos | 4 | 3 | 12 | Es el corazón de la app: si un usuario no puede guardar su entrenamiento, se pierde el propósito completo|
| Base de datos de ejercicios | 2 | 2 | 4 | CRUD simple, solo lo toca el admin. Si falla, molesta pero no bloquea a un usuario que ya tiene ejercicios cargados |
| Plantillas de entrenamiento | 3 | 3 | 9 | Si la conversión de plantilla a entrenamiento falla, un usuario nuevo pierde el atajo para empezar rápido y puede quedar con datos incompletos |
| Panel de administración | 4 | 2 | 8 | Si un endpoint de admin queda mal protegido, un usuario normal podría gestionar usuarios o ejercicios ajenos. Probabilidad baja porque ya usa `get_current_active_admin`, pero el impacto sería alto |
| Historial y estadísticas | 2 | 2 | 4 | Solo lectura: si falla, un usuario no ve su progreso, pero no pierde ni daña datos |
| Interfaz responsive | 1 | 2 | 2 | Si se ve mal en el celular molesta, pero no impide usar la app desde el navegador del computador |

## Ronda 3: si tuviéramos una sola tarde

Tres cosas, en orden de prioridad, con una frase de justificación cada una.

1. **Autenticación (login/registro)** Porque es la puerta de entrada: si no funciona, nadie llega a usar el resto de la app
2. **Registro de entrenamientos** Porque es la funcionalidad que más valor aporta: es la razón de ser de la app, poder registrar y guardar un entrenamiento
3. **Plantillas de entrenamiento** Porque es lo que le permite al usuario hacerlo rápido, sin armar todo desde cero cada vez
