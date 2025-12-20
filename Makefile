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

dev-certs:
	mkdir dev-certs
	openssl genpkey -algorithm RSA -out dev-certs/server.key
	yes '' | openssl req -new -x509 -key dev-certs/server.key -out dev-certs/server.crt -days 365
