package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.util.List;
import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.model.shapes.ResourceShape;
import software.amazon.smithy.model.shapes.ServiceShape;

final class RustSdkGenerator implements TargetSdkGenerator {
    @Override
    public void generate(PluginContext context, SuperhumanDocsSettings settings) {
        ServiceShape service = SdkCodegen.service(context.getModel(), settings);
        List<SdkCodegen.OperationBinding> bindings = SdkCodegen.operationBindings(context.getModel(), service);
        List<ResourceShape> resources = SdkCodegen.resourcesInServiceOrder(context.getModel(), service);
        List<ResourceShape> topLevelResources = SdkCodegen.topLevelResourcesInServiceOrder(context.getModel(), service);
        context.getFileManifest().writeFile(
                "sdk/rust/src/generated/operations.rs",
                RustRenderer.render(
                        context.getModel(), service.getId().getNamespace(), bindings, resources, topLevelResources));
    }
}
