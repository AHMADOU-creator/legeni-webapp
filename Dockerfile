FROM python:3.12-slim AS base
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM base AS test
COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt
COPY . .
RUN flake8 app.py tests && pytest --cov=app --cov-fail-under=80 --junitxml=report.xml

FROM base AS final
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}
RUN useradd -r -u 1001 appuser
COPY --from=test /app/app.py .
USER appuser
EXPOSE 5000
HEALTHCHECK --interval=30s CMD python -c "import urllib.request;urllib.request.urlopen('http://localhost:5000/health')" || exit 1
CMD ["python", "app.py"]
