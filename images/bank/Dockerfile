FROM amd64/golang:1.13-alpine3.11 AS builder

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
RUN export CGO_ENABLED=0

## dev build (fast)
RUN go build -tags netgo -o "/stage/app" "./${BANK_APP_SRC#bank/}"

## prod build (slow)
# RUN go build -tags netgo   "/stage/app" "./${BANK_APP_SRC#bank/}"

# Todo: Add version
# -ldflags "-X main.Version=version" # $(git describe)

FROM amd64/alpine:3.11
RUN apk add --no-cache ca-certificates

COPY --from=builder "/stage/app" /

CMD ["/app"]
ENTRYPOINT ["/app"]
