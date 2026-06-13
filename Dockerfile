ARG GO_VERSION=1.22
ARG ALPINE_VERSION=3.19
ARG BUSYBOX_VERSION=1.38

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS build

WORKDIR /src

COPY go.mod go.sum* ./

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=cache,target=/root/.cache/go-build/ \
    go mod download -x

COPY . .

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=cache,target=/root/.cache/go-build/ \
    CGO_ENABLED=0 go build -o /usr/local/bin/yaml2html .

RUN /usr/local/bin/yaml2html

FROM busybox:${BUSYBOX_VERSION}-musl AS serve

RUN adduser -D staticuser
USER staticuser

WORKDIR /home/staticuser

COPY --from=build /src/index.html ./html/index.html

EXPOSE 8080

CMD ["httpd", "-f", "-p", "8080", "-h", "/home/staticuser/html"]
