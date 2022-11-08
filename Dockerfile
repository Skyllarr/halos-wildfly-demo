FROM jboss/base-jdk:11

LABEL maintainer="Harald Pehl <hpehl@redhat.com>"

ENV JBOSS_HOME /opt/jboss/wildfly
COPY wildfly-27.0.0.Beta1.tar.gz /

USER root

RUN tar xf /wildfly-27.0.0.Beta1.tar.gz --directory=/ \
    && mv /wildfly-27.0.0.Beta1 $JBOSS_HOME \
    && rm /wildfly-27.0.0.Beta1.tar.gz

ADD server.* ${JBOSS_HOME}/standalone/configuration/
ADD standalone-full.xml ${JBOSS_HOME}/standalone/configuration/
ADD thread-racing.war ${JBOSS_HOME}/standalone/deployments/

RUN chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

USER jboss

ENV LAUNCH_JBOSS_IN_BACKGROUND true
EXPOSE 8080 9993
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
CMD ["-c", "standalone-full.xml"]
