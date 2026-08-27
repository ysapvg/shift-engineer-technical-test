# STAGE 1 : Build the Go binary
FROM golang:1.27-alpine AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-w -s -X main.version=1.0.0" -o go_test . 

# STAGE 2 : Create a minimal image using the scratch base image
FROM scratch
COPY --from=builder /src/go_test /src
ENTRYPOINT ["/src"]