package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

public final class GoCodegenPlugin extends TargetCodegenPlugin {
    public static final String PLUGIN_ID = "superhuman-docs-go-codegen";

    public GoCodegenPlugin() {
        super(PLUGIN_ID, new GoSdkGenerator());
    }
}
