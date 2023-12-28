SHELL := /bin/bash

help: ## List all commands
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9 -_]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Update/Build docker services
	./compose.sh pull --parallel
	./compose.sh build --pull --parallel

logs: ## Display and follow docker logs
	./compose.sh logs --tail=500 --follow

up: build ## Start docker containers
	./compose.sh up -d
	$(MAKE) logs

ps: ## List containers
	./compose.sh ps

down: ## Stop all containers
	./compose.sh down

restart: down up ## Restart by call "down" and "up"

shell-app: ## go into a interactive bash shell in App container
	./compose.sh exec app /bin/bash

run-shell-app: ## Build and start the App container and go into shell
	./compose.sh build --pull --parallel app
	./compose.sh run --entrypoint '/bin/bash' app

.PHONY: help build up shell-app run-shell-app
