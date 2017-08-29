#!/bin/sh

function check_code() {
	EXCODE=$?
	if [ "$EXCODE" != "0" ]; then
		echo "build fail."
		exit $EXCODE
	fi
}

out="dist"
echo "build file to ./$out"

mkdir -p "$out/conf"

go get github.com/coreos/etcd
go get github.com/rogpeppe/fastuuid
go get go.uber.org/zap
go get golang.org/x/net
go get gopkg.in/mgo.v2

go build -o ./$out/cronnode ./bin/node/server.go
check_code
go build -o ./$out/cronweb ./bin/web/server.go
check_code

cp -r web/ui/dist "$out/ui"

sources=`find ./conf/files -name "*.json.sample"`
check_code
for source in $sources;do
	yes | echo $source|sed "s/.*\/\(.*\.json\).*/cp -f & .\/$out\/conf\/\1/"|bash
	check_code
done

echo "build success."
