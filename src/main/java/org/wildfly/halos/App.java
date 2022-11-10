package org.wildfly.halos;

import java.net.URI;
import java.nio.file.Paths;
import java.security.Security;

import org.jboss.as.controller.client.ModelControllerClient;
import org.jboss.as.controller.client.ModelControllerClientConfiguration;
import org.jboss.dmr.ModelNode;
import org.wildfly.security.auth.client.WildFlyElytronClientDefaultSSLContextProvider;

public class App {

    public static void main(String[] args) {
        Security.insertProviderAt(new WildFlyElytronClientDefaultSSLContextProvider(), 1);

        try (ModelControllerClient client = createClient()) {
            ModelNode operation = createOperation();
            ModelNode result = client.execute(operation);
            System.out.println(result.get("result").toString());
        } catch (Exception e) {
            System.err.printf("Unable to execute operation: %s", e.getMessage());
        }
    }

    static ModelControllerClient createClient() {
        ModelControllerClientConfiguration configuration = new ModelControllerClientConfiguration.Builder()
                .setAuthenticationConfigUri(URI.create("file://" + Paths.get("src/main/resources/META-INF/wildfly-config.xml").toAbsolutePath()))
                .setProtocol("remote+https")
                .setHostName("localhost")
                .setPort(9993)
                .setConnectionTimeout(100000000)
                .build();
        return ModelControllerClient.Factory.create(configuration);
    }

    static ModelNode createOperation() {
        ModelNode operation = new ModelNode();
        operation.get("operation").set("read-resource");
        operation.get("attributes-only").set(true);
        operation.get("include-runtime").set(true);
        operation.get("address").setEmptyList();
        return operation;
    }
}
