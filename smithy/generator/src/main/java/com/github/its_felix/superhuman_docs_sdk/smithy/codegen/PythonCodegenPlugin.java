package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

public final class PythonCodegenPlugin extends TargetCodegenPlugin {
    public static final String PLUGIN_ID = "superhuman-docs-python-codegen";

    public PythonCodegenPlugin() {
        super(PLUGIN_ID, new PythonSdkGenerator());
    }
}
