package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

public final class RustCodegenPlugin extends TargetCodegenPlugin {
    public static final String PLUGIN_ID = "superhuman-docs-rust-codegen";

    public RustCodegenPlugin() {
        super(PLUGIN_ID, new RustSdkGenerator());
    }
}
