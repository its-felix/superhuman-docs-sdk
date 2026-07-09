package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

public final class MarkdownCodegenPlugin extends TargetCodegenPlugin {
    public static final String PLUGIN_ID = "superhuman-docs-markdown-codegen";

    public MarkdownCodegenPlugin() {
        super(PLUGIN_ID, new MarkdownSdkGenerator());
    }
}
