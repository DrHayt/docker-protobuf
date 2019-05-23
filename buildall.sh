#!/bin/sh -x
export GOPATH=/go

find $GOPATH/src/golang.sgpdev.com/conduit/models -type f -name \*.pb.go | xargs rm

find sgt 	-type f -name \*.proto | xargs -n 1 protoc --go_out=$GOPATH/src --autocacher_out=$GOPATH/src
find services	-type f -name \*.proto | xargs -n 1 protoc --go_out=plugins=grpc:$GOPATH/src --autocacher_out=$GOPATH/src
#find services	-type f -name \*.proto | xargs -n 1 protoc --go_out=plugins=autocacher:$GOPATH/src

cd /go/src/golang.sgpdev.com/conduit/models 
go generate ./...
