package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import software.amazon.smithy.build.FileManifest;
import software.amazon.smithy.build.MockManifest;
import software.amazon.smithy.build.ProjectionResult;
import software.amazon.smithy.build.SmithyBuild;
import software.amazon.smithy.build.SmithyBuildPlugin;
import software.amazon.smithy.build.SmithyBuildResult;
import software.amazon.smithy.build.model.ProjectionConfig;
import software.amazon.smithy.build.model.SmithyBuildConfig;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.node.ObjectNode;

import org.junit.jupiter.api.Test;

final class SuperhumanDocsCodegenPluginTest {
    @Test
    void discoversAndRunsSmithyBuildPlugin() throws IOException {
        SmithyBuildResult result = runBuild(Map.of(SuperhumanDocsCodegenPlugin.PLUGIN_ID, settings()));

        assertFalse(result.anyBroken(), "Smithy build should complete without broken projections");
        ProjectionResult source = result.getProjectionResult("source").orElseThrow();
        FileManifest manifest = source.getPluginManifest(SuperhumanDocsCodegenPlugin.PLUGIN_ID).orElseThrow();
        MockManifest mockManifest = (MockManifest) manifest;

        assertTrue(manifest.hasFile("sdk/python/src/superhuman_docs/_generated.py"));
        assertTrue(manifest.hasFile("sdk/go/types_gen.go"));
        assertTrue(manifest.hasFile("sdk/go/operations_gen.go"));
        assertTrue(manifest.hasFile("sdk/zig/src/generated/operations.zig"));
        assertTrue(mockManifest.expectFileString("sdk/python/src/superhuman_docs/_generated.py").contains("ListDocs"));
        assertTrue(mockManifest.expectFileString("sdk/go/operations_gen.go").contains("func (c *Client) ListDocs"));
        assertTrue(mockManifest.expectFileString("sdk/zig/src/generated/operations.zig").contains("pub fn buildListDocs"));
    }

    @Test
    void canRunSingleTargetPlugin() throws IOException {
        SmithyBuildResult result = runBuild(Map.of(PythonCodegenPlugin.PLUGIN_ID, settings()));

        assertFalse(result.anyBroken(), "Smithy build should complete without broken projections");
        ProjectionResult source = result.getProjectionResult("source").orElseThrow();
        FileManifest manifest = source.getPluginManifest(PythonCodegenPlugin.PLUGIN_ID).orElseThrow();
        MockManifest mockManifest = (MockManifest) manifest;

        assertTrue(manifest.hasFile("sdk/python/src/superhuman_docs/_generated.py"));
        assertTrue(mockManifest.expectFileString("sdk/python/src/superhuman_docs/_generated.py").contains("ListDocs"));
        assertFalse(manifest.hasFile("sdk/go/types_gen.go"));
        assertFalse(manifest.hasFile("sdk/zig/src/generated/operations.zig"));
    }

    @Test
    void discoversTargetPlugins() {
        var factory = SmithyBuildPlugin.createServiceFactory();

        assertNotNull(factory.apply(MarkdownCodegenPlugin.PLUGIN_ID).orElse(null));
        assertNotNull(factory.apply(PythonCodegenPlugin.PLUGIN_ID).orElse(null));
        assertNotNull(factory.apply(GoCodegenPlugin.PLUGIN_ID).orElse(null));
        assertNotNull(factory.apply(ZigCodegenPlugin.PLUGIN_ID).orElse(null));
    }

    private static SmithyBuildResult runBuild(Map<String, ObjectNode> plugins) throws IOException {
        Model model = loadRepositoryModel();
        ProjectionConfig projection = ProjectionConfig.builder()
                .plugins(plugins)
                .build();
        SmithyBuildConfig config = SmithyBuildConfig.builder()
                .version("1.0")
                .projections(Map.of("source", projection))
                .build();

        return new SmithyBuild()
                .config(config)
                .model(model)
                .pluginFactory(SmithyBuildPlugin.createServiceFactory())
                .fileManifestFactory(MockManifest::new)
                .build();
    }

    private static ObjectNode settings() {
        return ObjectNode.builder()
                .withMember("service", "com.superhuman.docs.v1#SuperhumanDocsApi")
                .withMember("edition", "test")
                .build();
    }

    private static Model loadRepositoryModel() throws IOException {
        Path modelDirectory = Path.of(System.getProperty("user.dir")).resolve("../model").normalize();
        List<Path> smithyFiles;
        try (var stream = Files.list(modelDirectory)) {
            smithyFiles = stream
                    .filter(path -> path.getFileName().toString().endsWith(".smithy"))
                    .sorted()
                    .toList();
        }

        var assembler = Model.assembler();
        for (Path smithyFile : smithyFiles) {
            assembler.addImport(smithyFile);
        }
        return assembler.assemble().unwrap();
    }
}
