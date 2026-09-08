FROM python:3.11-slim

WORKDIR /app

# Capa de dependencias primero: cambia poco, así el caché de Docker no se
# invalida cada vez que cambia el código de la app.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd --create-home --uid 1000 appuser \
    && chmod +x docker-entrypoint.sh \
    && chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

# Prueba automatizada que corre en bucle en producción: usa la librería
# estándar de Python para no depender de curl en la imagen.
HEALTHCHECK --interval=10s --timeout=5s --start-period=20s --retries=5 \
    CMD python -c "import urllib.request as u; u.urlopen('http://127.0.0.1:8000/docs', timeout=3)" || exit 1

ENTRYPOINT ["./docker-entrypoint.sh"]
