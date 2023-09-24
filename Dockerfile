FROM golang:1.21.1-alpine3.18

WORKDIR /usr/bin/app

COPY . .
RUN go build -v -o /usr/local/bin/app ./...

CMD ["app"]
