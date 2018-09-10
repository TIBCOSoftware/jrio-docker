#!/bin/sh

if [ -d /mnt/jrio-overlay ]; then
	echo "Applying overlay from /mnt/jrio-overlay"
	cp -rf /mnt/jrio-overlay/. $JETTY_BASE
fi

TMPDIR=/tmp/jrio
mkdir -p $TMPDIR

JRIO_PORT_ARGS="-Djetty.http.port=8080"

java -jar /jrio/jetty/start.jar jetty.base=/jrio/base --start $JRIO_PORT_ARGS -Djava.io.tmpdir=$TMPDIR -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
