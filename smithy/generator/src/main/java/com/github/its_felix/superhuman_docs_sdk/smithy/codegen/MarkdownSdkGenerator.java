package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import software.amazon.smithy.build.PluginContext;
import software.amazon.smithy.model.shapes.ServiceShape;
import software.amazon.smithy.model.shapes.ShapeId;
import software.amazon.smithy.model.traits.DocumentationTrait;

final class MarkdownSdkGenerator implements TargetSdkGenerator {
    @Override
    public void generate(PluginContext context, SuperhumanDocsSettings settings) {
        ServiceShape service = SdkCodegen.service(context.getModel(), settings);
        List<String> lines = new ArrayList<>();
        lines.add("# " + service.getId().getName());
        lines.add("");
        service.getTrait(DocumentationTrait.class).ifPresent(documentation -> {
            lines.add(documentation.getValue());
            lines.add("");
        });
        lines.add("- Smithy ID: `" + service.getId() + "`");
        lines.add("- Version: `" + service.getVersion() + "`");
        lines.add("- Operations: `" + service.getAllOperations().size() + "`");
        lines.add("");
        lines.add("## Operations");
        service.getAllOperations().stream()
                .sorted(Comparator.comparing(ShapeId::toString))
                .forEach(id -> lines.add("- `" + id + "`"));
        lines.add("");
        context.getFileManifest().writeFile("sdk/markdown/service.md", String.join("\n", lines));
    }
}
