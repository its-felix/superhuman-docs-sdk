package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.shapes.ResourceShape;
import software.amazon.smithy.model.shapes.ServiceShape;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.DocumentationTrait;

final class MarkdownSdkGenerator implements TargetSdkGenerator {
    @Override
    public void generate(PluginContext context, SuperhumanDocsSettings settings) {
        Model model = context.getModel();
        ServiceShape service = SdkCodegen.service(model, settings);
        List<SdkCodegen.OperationBinding> bindings = SdkCodegen.operationBindings(model, service);
        List<ResourceShape> resources = SdkCodegen.resourcesInServiceOrder(model, service);
        Map<ShapeId, ResourceShape> parents = SdkCodegen.resourceParents(model, service);
        List<String> lines = new ArrayList<>();
        lines.add("# " + service.getId().getName());
        lines.add("");
        service.getTrait(DocumentationTrait.class).ifPresent(documentation -> {
            lines.add(documentation.getValue());
            lines.add("");
        });
        lines.add("- Smithy ID: `" + service.getId() + "`");
        lines.add("- Version: `" + service.getVersion() + "`");
        lines.add("- Operations: `" + bindings.size() + "`");
        lines.add("- Direct service operations: `" + bindings.stream()
                .filter(SdkCodegen.OperationBinding::isServiceOperation).count() + "`");
        lines.add("- Resources: `" + resources.size() + "`");
        lines.add("");
        lines.add("## Direct service operations");
        bindings.stream()
                .filter(SdkCodegen.OperationBinding::isServiceOperation)
                .forEach(binding -> lines.add("- `" + binding.operation().getId() + "`"));
        lines.add("");
        lines.add("## Resource hierarchy");
        for (ResourceShape resource : resources) {
            int depth = resourceDepth(resource, parents);
            String indent = "  ".repeat(depth);
            lines.add(indent + "- `" + resource.getId() + "`");
            for (SdkCodegen.OperationBinding binding : bindings) {
                if (resource.equals(binding.resource())) {
                    lines.add(indent + "  - `" + binding.methodName() + "`: `"
                            + binding.operation().getId() + "`");
                }
            }
        }
        lines.add("");
        context.getFileManifest().writeFile("sdk/markdown/service.md", String.join("\n", lines));
    }

    private static int resourceDepth(ResourceShape resource, Map<ShapeId, ResourceShape> parents) {
        int depth = 0;
        ResourceShape current = resource;
        while (parents.containsKey(current.getId())) {
            depth++;
            current = parents.get(current.getId());
        }
        return depth;
    }
}
