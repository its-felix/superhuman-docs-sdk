package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.build.SmithyBuildPlugin;

public final class SuperhumanDocsCodegenPlugin implements SmithyBuildPlugin {
    public static final String PLUGIN_ID = "superhuman-docs-client-codegen";
    private static final TargetSdkGenerator[] TARGETS = {
            new MarkdownSdkGenerator(),
            new PythonSdkGenerator(),
            new GoSdkGenerator(),
            new ZigSdkGenerator()
    };

    @Override
    public String getName() {
        return PLUGIN_ID;
    }

    @Override
    public void execute(PluginContext context) {
        SuperhumanDocsSettings settings = SuperhumanDocsSettings.from(context.getSettings());
        for (TargetSdkGenerator target : TARGETS) {
            target.generate(context, settings);
        }
    }
}
