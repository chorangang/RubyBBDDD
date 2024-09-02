FROM postgres:16.0

# init.sqlをコンテナのdocker-entrypoint-initdb.dディレクトリにコピー
COPY infra/pg/init.sql /docker-entrypoint-initdb.d/

