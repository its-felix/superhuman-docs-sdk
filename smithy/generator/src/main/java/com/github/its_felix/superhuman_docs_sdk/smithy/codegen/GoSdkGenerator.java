package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.model.shapes.ServiceShape;

final class GoSdkGenerator implements TargetSdkGenerator {
    @Override
    public void generate(PluginContext context, SuperhumanDocsSettings settings) {
        ServiceShape service = SdkCodegen.service(context.getModel(), settings);
        context.getFileManifest().writeFile(
                "sdk/go/types_gen.go",
                GoRenderer.renderTypes(context.getModel(), service.getId().getNamespace()));
        context.getFileManifest().writeFile(
                "sdk/go/operations_gen.go",
                GoRenderer.renderOperations(context.getModel()));
    }
}
