FROM golang:1.21.1-alpine3.18 as builder

WORKDIR /usr/bin/app

COPY . .

RUN go build -v -o /usr/local/bin/app ./...

FROM alpine:3.8

COPY --from=builder /usr/bin/app /usr/bin

EXPOSE 3000

CMD ["app"]
