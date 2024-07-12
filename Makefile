M = $(shell printf "\033[34;1m▶\033[0m")

.PHONY: help
help: ## Prints this help message
	@grep -E '^[a-zA-Z_-]+:.?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

######################
### MAIN FUNCTIONS ###
######################

.PHONY: start
start: ## Start the backstage docker container
	$(info $(M) Starting an instance of backstage at : backstage.local.io)
	@docker-compose -f ./docker/docker-compose.yml up -d

.PHONY: stop
stop: ## Stopping running backstage instances
	$(info $(M) Stopping backstage instance)
	@docker-compose -f ./docker/docker-compose.yml down

.DEFAULT_GOAL := help