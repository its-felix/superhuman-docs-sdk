package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

public final class RustAsyncCodegenPlugin extends TargetCodegenPlugin {
    public static final String PLUGIN_ID = "superhuman-docs-rust-async-codegen";

    public RustAsyncCodegenPlugin() {
        super(PLUGIN_ID, new RustSdkGenerator(
                true,
                "sdk/rust-async/src/generated/operations.rs"));
    }
}
