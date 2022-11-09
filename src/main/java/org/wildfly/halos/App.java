package org.wildfly.halos;

import java.security.NoSuchAlgorithmException;
import java.security.Security;

import javax.net.ssl.SSLContext;

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

    static ModelControllerClient createClient() throws NoSuchAlgorithmException {
        SSLContext sslContext = SSLContext.getDefault();
        ModelControllerClientConfiguration configuration = new ModelControllerClientConfiguration.Builder()
                .setProtocol("remote+https")
                .setHostName("localhost")
                .setPort(9993)
                .setSslContext(sslContext)
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
