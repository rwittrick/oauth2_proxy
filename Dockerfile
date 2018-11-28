FROM golang:latest as build

ENV CGO_ENABLED=0
RUN go get github.com/rwittrick/oauth2_proxy
#
FROM alpine:3.8
# Install CA certificates
RUN apk add --no-cache --virtual=build-dependencies ca-certificates
COPY --from=build /go/bin/oauth2_proxy ./bin
EXPOSE 8080 4180
RUN chown 1000 ./bin/oauth2_proxy && \
    chmod u+x ./bin/oauth2_proxy
USER 1000
ENTRYPOINT [ "./bin/oauth2_proxy" ]
CMD ["--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180"]
