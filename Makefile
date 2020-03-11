# default target
build: condensat-logger condensat-tech-website condensat-monitor condensat-monitor-stack monitor-webapp bank-api bank-webapp kyc-worker kyc-webhook

login:
	@echo "$$DOCKER_PASSWORD" | docker login -u condensat --password-stdin registry.condensat.space

condensat-logger:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=logger/cmd/grabber/main.go -t registry.condensat.space/condensat-logger
	@docker push registry.condensat.space/condensat-logger

bank-webapp-base:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=bank/web/cmd/main.go -t registry.condensat.space/bank-webapp-base
	@docker push registry.condensat.space/bank-webapp-base

condensat-monitor:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=monitor/cmd/monitor/main.go  -t registry.condensat.space/condensat-monitor
	@docker push registry.condensat.space/condensat-monitor


condensat-tech-website:
	@docker build . -f images/tech/Dockerfile --build-arg=BANK_WEBAPP_DOCKER_DIR=images/tech/website -t registry.condensat.space/condensat-tech-website
	@docker push registry.condensat.space/condensat-tech-website

monitor-webapp: bank-webapp-base
	@docker build . -f images/monitor/webapp/Dockerfile --build-arg=BANK_WEBAPP_DOCKER_DIR=images/monitor/webapp -t registry.condensat.space/monitor-webapp
	@docker push registry.condensat.space/monitor-webapp

condensat-monitor-stack:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=monitor/cmd/stack/main.go  -t registry.condensat.space/condensat-monitor-stack
	@docker push registry.condensat.space/condensat-monitor-stack

bank-api:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=bank/api/cmd/bank-api/main.go -t registry.condensat.space/bank-api
	@docker push registry.condensat.space/bank-api

bank-webapp: bank-webapp-base
	@docker build . -f images/bank/webapp/Dockerfile --build-arg=BANK_WEBAPP_DOCKER_DIR=images/bank/webapp -t registry.condensat.space/bank-webapp
	@docker push registry.condensat.space/bank-webapp

kyc-worker:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=kyc/cmd/worker/main.go -t registry.condensat.space/kyc-worker
	@docker push registry.condensat.space/kyc-worker

kyc-webhook:
	@docker build . -f images/bank/Dockerfile --build-arg=BANK_APP_SRC=kyc/cmd/webhook/main.go -t registry.condensat.space/kyc-webhook
	@docker push registry.condensat.space/kyc-webhook


clean:
	@echo docker rmi $(docker rmi registry.condensat.space/bank-logger registry.condensat.space/bank-api)
	@echo docker prune $(echo y | docker system prune --all)

.PHONY: login build condensat-logger condensat-tech-website bank-webapp-base condensat-monitor monitor-webapp condensat-monitor-stack bank-api bank-webapp kyc-worker kyc-webhook

.SILENT:clean
