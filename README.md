# WildFly Demo for halOS

This repository contains scripts, settings and a Dockerfile to build, run and test a WildFly image used for a halOS demo.

- Based on WildFly 27
- Contains the [thread-racing](https://github.com/wildfly/quickstart/blob/main/thread-racing/README.adoc) quickstart
- Two-way SSL for the management interface
- Image available at https://quay.io/repository/hpehl/wildfly-halos-demo

The repository contains a Java [app](src/main/java/org/wildfly/halos/App.java) that connects to the management interface secured by two-way SSL. To test it follow these steps:

1. `./start-demo.sh`
2. `mvn package`
3. `java -jar target/halos-console-0.0.1.jar`
