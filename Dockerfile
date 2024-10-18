FROM golang:alpine3.20 AS base

ARG service_name
WORKDIR /${service_name}

COPY go.mod .
RUN go mod download && go mod verify
COPY . .

RUN GOOS=linux GOARCH=amd64 go build -o ${service_name}
# ------------------------------------------------------------------------
FROM alpine:3.15

ARG service_name
ENV SERVICE_NAME=./${service_name}
WORKDIR /${service_name}

COPY --from=base /${service_name}/${service_name} .

EXPOSE 8080
CMD ["sh", "-c", "${SERVICE_NAME}"]
