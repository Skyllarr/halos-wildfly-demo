FROM jboss/base-jdk:11

LABEL maintainer="Harald Pehl <hpehl@redhat.com>"

COPY wildfly-27.0.0.Beta1.tar.gz /

USER root

RUN tar xf /wildfly-27.0.0.Beta1.tar.gz --directory=/ \
    && mv /wildfly-27.0.0.Beta1 /opt/jboss/wildfly \
    && rm /wildfly-27.0.0.Beta1.tar.gz

ADD server.* /opt/jboss/wildfly/standalone/configuration/
ADD standalone-full.xml /opt/jboss/wildfly/standalone/configuration/
ADD thread-racing.war /opt/jboss/wildfly/standalone/deployments/

RUN /opt/jboss/wildfly/bin/add-user.sh -u admin -p admin --silent
RUN chown -R jboss:0 /opt/jboss/wildfly \
    && chmod -R g+rw /opt/jboss/wildfly

USER jboss

ENV LAUNCH_JBOSS_IN_BACKGROUND true
EXPOSE 8080 9993
ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
CMD ["-c", "standalone-full.xml"]
