# default target
build: bank-logger bank-api bank-webapp

login:
	@echo "$$DOCKER_PASSWORD" | docker login -u condensat --password-stdin registry.condensat.space

bank-logger:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=logger/cmd/grabber/main.go -t registry.condensat.space/bank-logger
	@docker push registry.condensat.space/bank-logger

bank-api:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=bank/api/cmd/bank-api/main.go -t registry.condensat.space/bank-api
	@docker push registry.condensat.space/bank-api

bank-webapp-base:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=bank/web/cmd/main.go -t registry.condensat.space/bank-webapp-base
	@docker push registry.condensat.space/bank-webapp-base

bank-webapp: bank-webapp-base
	@docker build . -f images/bank/webapp/Dockerfile --build-arg=BANK_WEBAPP_DOCKER_DIR=images/bank/webapp -t registry.condensat.space/bank-webapp
	@docker push registry.condensat.space/bank-webapp

clean:
	@echo docker rmi $(docker rmi registry.condensat.space/bank-logger registry.condensat.space/bank-api)
	@echo docker prune $(echo y | docker system prune --all)

.PHONY: login build bank-logger bank-api bank-webapp

.SILENT:clean
