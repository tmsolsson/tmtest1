# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang:1.11.2-alpine

# Copy the local package files to the container's workspace.
ADD . /go/src/github.com/knative/docs/helloworld

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
  go install -ldflags '-w -extldflags "-static"' \
  /go/src/github.com/knative/docs/helloworld

FROM scratch
COPY --from=0 /go/bin/helloworld /go/bin/helloworld

CMD ["/go/bin/helloworld"]

# Document that the service listens on port 8080.
EXPOSE 8080

ARG buildnum
ENV TARGET="Build${buildnum}"
