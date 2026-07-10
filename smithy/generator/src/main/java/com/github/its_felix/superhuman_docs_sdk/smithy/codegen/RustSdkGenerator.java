package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.util.List;
import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.model.shapes.OperationShape;
import software.amazon.smithy.model.shapes.ServiceShape;

final class RustSdkGenerator implements TargetSdkGenerator {
    @Override
    public void generate(PluginContext context, SuperhumanDocsSettings settings) {
        ServiceShape service = SdkCodegen.service(context.getModel(), settings);
        List<OperationShape> operations = SdkCodegen.operationsInServiceOrder(context.getModel(), service);
        context.getFileManifest().writeFile(
                "sdk/rust/src/generated/operations.rs",
                RustRenderer.render(context.getModel(), operations));
    }
}
