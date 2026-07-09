package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.build.SmithyBuildPlugin;

abstract class TargetCodegenPlugin implements SmithyBuildPlugin {
    private final String name;
    private final TargetSdkGenerator generator;

    TargetCodegenPlugin(String name, TargetSdkGenerator generator) {
        this.name = name;
        this.generator = generator;
    }

    @Override
    public final String getName() {
        return name;
    }

    @Override
    public final void execute(PluginContext context) {
        generator.generate(context, SuperhumanDocsSettings.from(context.getSettings()));
    }
}
