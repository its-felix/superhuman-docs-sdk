package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.util.Optional;
import software.amazon.smithy.model.node.ObjectNode;

public final class SuperhumanDocsSettings {
    private String service;
    private String closure;
    private String edition;

    public static SuperhumanDocsSettings from(ObjectNode node) {
        SuperhumanDocsSettings settings = new SuperhumanDocsSettings();
        node.getStringMember("service", settings::service);
        node.getStringMember("closure", settings::closure);
        node.getStringMember("edition", settings::edition);
        return settings;
    }

    public Optional<String> service() {
        return Optional.ofNullable(service);
    }

    public void service(String service) {
        this.service = service;
    }

    public Optional<String> closure() {
        return Optional.ofNullable(closure);
    }

    public void closure(String closure) {
        this.closure = closure;
    }

    public Optional<String> edition() {
        return Optional.ofNullable(edition);
    }

    public void edition(String edition) {
        this.edition = edition;
    }
}
