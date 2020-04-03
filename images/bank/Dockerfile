FROM golang:1.13-alpine3.11 AS builder

RUN apk add --no-cache alpine-sdk

ARG GITLAB_BUILD_TOKEN=

RUN git config --global credential.helper store
RUN git config --global url."https://build:${GITLAB_BUILD_TOKEN}@code.condensat.tech/".insteadOf https://code.condensat.tech/
RUN go env -w GOPRIVATE=code.condensat.tech/*

WORKDIR /src/bank
ADD ./bank/go.* ./
RUN go mod download

ARG BANK_APP_SRC=

ADD ./bank ./
RUN mkdir /stage
RUN export CGO_ENABLED=1
RUN go build -tags netgo -ldflags="-s -w" -trimpath -o "/stage/app" "./${BANK_APP_SRC#bank/}"


FROM alpine:3.11
RUN apk add --no-cache ca-certificates

COPY --from=builder "/stage/app" /

CMD ["/app"]
ENTRYPOINT ["/app"]
