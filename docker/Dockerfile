FROM openjdk:8-jre-alpine

ENV LANG en_US.UTF-8

RUN addgroup -S -g 700 jrio && \
    adduser -S -D -H -u 700 -G jrio jrio

RUN apk add --update attr ttf-dejavu && rm -rf /var/cache/apk/*

ENV JRIO_ROOT /jrio
ENV JETTY_HOME /jrio/jetty
ENV JETTY_BASE /jrio/base

COPY docker/jrio.sh /

COPY jetty $JETTY_HOME/
COPY --chown=jrio:jrio jrio/start.d $JETTY_BASE/start.d/

COPY --chown=jrio:jrio jrio/webapps/ROOT $JETTY_BASE/webapps/ROOT/
COPY --chown=jrio:jrio jrio/webapps/jrio $JETTY_BASE/webapps/jrio/
COPY --chown=jrio:jrio docker/applicationContext-repository.xml $JETTY_BASE/webapps/jrio/WEB-INF/
COPY --chown=jrio:jrio jrio/webapps/jrio-client $JETTY_BASE/webapps/jrio-client/
COPY --chown=jrio:jrio jrio/webapps/jrio-docs $JETTY_BASE/webapps/jrio-docs/

COPY repository /mnt/jrio-repository/

USER jrio

EXPOSE 8080

ENTRYPOINT ["/jrio.sh"]
