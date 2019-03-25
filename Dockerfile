FROM golang:latest as protoc_builder

ENV PROTOBUF_VERSION=3.6.1 \
	OUTDIR=/out \
	GOPATH=/go \
	PATH=/go/bin:$PATH
RUN apt-get update && \
	apt-get install unzip && \
	curl -L	https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip > protoc.zip && \
	unzip protoc.zip -d /usr && \
	rm protoc.zip

RUN mkdir -p $OUTDIR/usr/bin && \
	go get -u -v -ldflags '-w -s' \
        github.com/Masterminds/glide \
        github.com/golang/protobuf/protoc-gen-go \
        github.com/gogo/protobuf/protoc-gen-gofast \
        github.com/gogo/protobuf/protoc-gen-gogo \
        github.com/gogo/protobuf/protoc-gen-gogofast \
        github.com/gogo/protobuf/protoc-gen-gogofaster \
        github.com/gogo/protobuf/protoc-gen-gogoslick \
        github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
        github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
        github.com/johanbrandhorst/protobuf/protoc-gen-gopherjs \
        github.com/ckaznocha/protoc-gen-lint \
        github.com/mwitkow/go-proto-validators/protoc-gen-govalidators \
	github.com/matryer/moq \
	github.com/google/wire/cmd/wire \
        moul.io/protoc-gen-gotemplate

RUN mkdir -p /usr/include/google/api && \
        for f in annotations http; do \
            curl -L -o /usr/include/google/api/${f}.proto https://raw.githubusercontent.com/grpc-ecosystem/grpc-gateway/master/third_party/googleapis/google/api/${f}.proto; \
        done && \
    mkdir -p /usr/include/github.com/gogo/protobuf/gogoproto && \
        curl -L -o /usr/include/github.com/gogo/protobuf/gogoproto/gogo.proto https://raw.githubusercontent.com/gogo/protobuf/master/gogoproto/gogo.proto && \
    mkdir -p /usr/include/github.com/mwitkow/go-proto-validators && \
        curl -L -o /usr/include/github.com/mwitkow/go-proto-validators/validator.proto https://raw.githubusercontent.com/mwitkow/go-proto-validators/master/validator.proto

copy buildall.sh /usr/bin

ENTRYPOINT ["/usr/bin/buildall.sh"]
