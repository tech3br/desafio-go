# ESTÁGIO DE BUILD
FROM golang:1.21.1-alpine3.18 as builder
WORKDIR /app 

# INSTALANDO APENAS A DEPENDENCIAS NECESSÁRIAS PARA BUILD
RUN apk --no-cache add ca-certificates

# COPIAR APENAS O ARQUIVOS PRIMEIRO PARA UM CACHE MELHOR
COPY go.mod go.sum* ./
RUN go mod download

# COPIAR TODO O CÓDIGO FONTE
COPY . .

# PONTO IMPORTANTE PARA OTIMIZAÇÃO
# FLAGS PARA GERAR UM BINÁRIO LEVE

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s -extldflags '-static'" -a -trimpath -o /app/binary .

# COMPRIMIR BINÁRIO
RUN apk add --no-cache upx && upx --best --lzma /app/binary


# ESTÁGIO FINAL - UTILIZANDO A MENOR IMAGEM POSSÍVEL
FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/binary /

ENTRYPOINT [ "/binary" ]

EXPOSE 3000

CMD ["app"]
