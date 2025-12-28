PGHOST := localhost
PGUSER := postgres
SOURCE_DB := sandbox
DUMP_FILE := dump.pgdump

PSQL := psql -h $(PGHOST) -U $(PGUSER)
PG_DUMP := pg_dump -h $(PGHOST) -U $(PGUSER) -Fc
PG_RESTORE := pg_restore -h $(PGHOST) -U $(PGUSER)
DC := docker compose
DC_INIT := docker compose -f docker-compose.yml -f docker-compose.init.yml

.PHONY: help init up down dump restore drop-restore template drop-template drop-all

help:
	@echo "Usage:"
	@echo "  make init          - Initialize DB with fast mode, then restart with normal mode"
	@echo "  make up            - Start PostgreSQL (normal mode)"
	@echo "  make down          - Stop PostgreSQL and remove volumes"
	@echo "  make dump          - Dump $(SOURCE_DB) to $(DUMP_FILE)"
	@echo "  make restore       - Restore $(DUMP_FILE) to $(SOURCE_DB)_restored"
	@echo "  make drop-restore  - Drop $(SOURCE_DB)_restored"
	@echo "  make template      - Create $(SOURCE_DB)_template from $(SOURCE_DB)"
	@echo "  make drop-template - Drop $(SOURCE_DB)_template"
	@echo "  make drop-all      - Drop all created databases"

init:
	$(DC) down -v
	$(DC_INIT) up -d --wait
	$(DC) down
	$(DC) up -d --wait

up:
	$(DC) up -d --wait

down:
	$(DC) down -v

dump:
	$(PG_DUMP) -d $(SOURCE_DB) > $(DUMP_FILE)

restore:
	$(PSQL) -c "CREATE DATABASE $(SOURCE_DB)_restored;"
	time $(PG_RESTORE) -d $(SOURCE_DB)_restored $(DUMP_FILE)

drop-restore:
	$(PSQL) -c "DROP DATABASE IF EXISTS $(SOURCE_DB)_restored;"

template:
	time $(PSQL) -c "CREATE DATABASE $(SOURCE_DB)_template TEMPLATE $(SOURCE_DB);"

drop-template:
	$(PSQL) -c "DROP DATABASE IF EXISTS $(SOURCE_DB)_template;"

drop-all: drop-restore drop-template