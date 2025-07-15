FROM apache/superset:latest

USER root

RUN pip install --no-cache-dir \
    trino[sqlalchemy] \
    sqlalchemy-trino

USER superset