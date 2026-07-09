package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import software.amazon.smithy.build.PluginContext;

interface TargetSdkGenerator {
    void generate(PluginContext context, SuperhumanDocsSettings settings);
}
