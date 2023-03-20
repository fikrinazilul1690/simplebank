makeFileDir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

postgres:
	docker run --name postgres -e POSTGRES_USER=root -e POSTGRES_PASSWORD=acer1690 -p 5432:5432 -d postgres

createdb:
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres dropdb simple_bank

migrateup:
	migrate -path db/migrations -database "postgresql://root:acer1690@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migrations -database "postgresql://root:acer1690@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc_init:
	docker run --rm -v $(makeFileDir):/src -u $$(id -u):$$(id -g) -w /src kjconroy/sqlc init

sqlc_generate:
	docker run --rm -v $(makeFileDir):/src -u $$(id -u):$$(id -g) -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc_init sqlc_generate test