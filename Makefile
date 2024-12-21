M = $(shell printf "\033[34;1m▶\033[0m")
APP_NAME = backstage

.PHONY: help
help: ## Prints this help message
	@grep -E '^[a-zA-Z_-]+:.?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

######################
### MAIN FUNCTIONS ###
######################

.PHONY: add_localhost
add_localhost: ## Add local host into /etc/hosts file (need root permission)
	@ echo "# >>> ${APP_NAME} for workspace" >> /etc/hosts
	@ echo "127.0.0.1\t${APP_NAME}.local.io" >> /etc/hosts
	@ echo "# <<< ${APP_NAME} for workspace" >> /etc/hosts
	$(info $(M) Local host added for ${APP_NAME} application in your hosts file)

.PHONY: remove_localhost
remove_localhost: ## Remove local host from /etc/hosts file (need root permission)
	@ sed -e '$(shell grep --line-number "# >>> ${APP_NAME} for workspace" /etc/hosts | cut -d ':' -f 1),$(shell grep --line-number "# <<< ${APP_NAME} for workspace" /etc/hosts | cut -d ':' -f 1)d' /etc/hosts  > /etc/hosts.tmp
	@ cp /etc/hosts.tmp /etc/hosts && rm -f /etc/hosts.tmp
	$(info $(M) Local host removed for ${APP_NAME} application in your hosts file)

.PHONY: build
build: ## Build the backstage docker image
	$(info $(M) Starting the build of the backstage docker image)
	@npx @backstage/create-app@latest --path ./data
	@(cd data && yarn install --immutable && yarn tsc && yarn build:backend)
	@docker build -t backstage-local -f ./Dockerfile ./data

.PHONY: start
start: ## Start the backstage docker container
	$(info $(M) Starting an instance of backstage at : backstage.local.io)
	@docker-compose -f ./docker/docker-compose.yml up -d

.PHONY: stop
stop: ## Stopping running backstage instances
	$(info $(M) Stopping backstage instance)
	@docker-compose -f ./docker/docker-compose.yml down

.DEFAULT_GOAL := help