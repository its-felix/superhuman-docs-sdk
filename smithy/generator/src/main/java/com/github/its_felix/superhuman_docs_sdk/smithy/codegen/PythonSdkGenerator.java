package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.util.List;
import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.model.shapes.OperationShape;
import software.amazon.smithy.model.shapes.ServiceShape;

final class PythonSdkGenerator implements TargetSdkGenerator {
    @Override
    public void generate(PluginContext context, SuperhumanDocsSettings settings) {
        ServiceShape service = SdkCodegen.service(context.getModel(), settings);
        List<OperationShape> operations = SdkCodegen.operationsInServiceOrder(context.getModel(), service);
        context.getFileManifest().writeFile(
                "sdk/python/src/superhuman_docs/_generated.py",
                PythonRenderer.render(context.getModel(), operations));
    }
}
