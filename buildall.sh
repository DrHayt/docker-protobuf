#!/bin/sh -x
export GOPATH=/go

BASEDIR="/go/src/golang.sgpdev.com/conduit"
THEDIR="$BASEDIR/models"

find $GOPATH/src/golang.sgpdev.com/conduit/models -type f -name \*.pb.go | xargs rm

find sgt 	-type f -name \*.proto | xargs -n 1 protoc --go_out=$GOPATH/src --autocacher_out=$GOPATH/src
find services	-type f -name \*.proto | xargs -n 1 protoc --go_out=plugins=grpc:$GOPATH/src
find services	-type f -name \*.proto | xargs -n 1 protoc --autocacher_out=$GOPATH/src
find services	-type f -name \*.proto | xargs -n 1 protoc --client_out=$GOPATH/src
find services	-type f -name \*.proto | xargs -n 1 protoc --proxy_out=$GOPATH/src

if [ -d $THEDIR ];then
    cd $BASEDIR && dep ensure --vendor-only
    cd $THEDIR && go generate ./...
else 
	echo "Requested directory $THEDIR DNE"
fi
