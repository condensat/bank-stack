FROM golang:1.13-alpine3.11 AS builder

WORKDIR /src/bank
ADD ./bank/go.* ./
RUN go mod download

ARG BANK_APP_SRC=

ADD ./bank ./
RUN mkdir /stage
RUN go build -tags netgo -ldflags="-s -w" -trimpath -o "/stage/bank-app" "./${BANK_APP_SRC#bank/}"


FROM alpine:3.11 AS certs
RUN apk add --no-cache ca-certificates


FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder "/stage/bank-app" /

CMD ["/bank-app"]
ENTRYPOINT ["/bank-app"]
