#!/bin/sh
# ponytail: sin migraciones versionadas (alembic/versions/ está en .gitignore
# a propósito, cada grupo genera la suya), así que el entrypoint se encarga
# de crearla si no existe. Es la misma secuencia manual del README, automatizada.
set -e

mkdir -p alembic/versions

if [ -z "$(ls -A alembic/versions 2>/dev/null)" ]; then
  echo "No hay migraciones todavía, generando la inicial..."
  alembic revision --autogenerate -m "Initial migration"
fi

echo "Aplicando migraciones..."
alembic upgrade head

echo "Verificando cuenta admin (create_admin.py es idempotente)..."
python create_admin.py

echo "Iniciando servidor..."
exec uvicorn main:app --host 0.0.0.0 --port 8000
