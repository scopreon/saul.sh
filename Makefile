.PHONY: lint fmt test add-pre-commit uv-export dev-certs

lint:
	uv run ruff check .
	uv run mypy .

format:
	uv run ruff format .
	uv run ruff check --fix .
	
test:
	uv run pytest -q

add-pre-commit:
	uv run pre-commit install

uv-export:
	uv export --format requirements.txt > ./requirements.txt
  
dev-certs/server.key:
	mkdir -p dev-certs
	openssl genpkey -algorithm RSA -out $@

dev-certs/server.crt: dev-certs/server.key
	yes '' | openssl req -new -x509 -key $< -out $@ -days 365

up-test: dev-certs/server.key dev-certs/server.crt
	docker compose -f docker-compose.yaml -f docker-compose.test.yaml up