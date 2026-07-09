package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

public final class ZigCodegenPlugin extends TargetCodegenPlugin {
    public static final String PLUGIN_ID = "superhuman-docs-zig-codegen";

    public ZigCodegenPlugin() {
        super(PLUGIN_ID, new ZigSdkGenerator());
    }
}
