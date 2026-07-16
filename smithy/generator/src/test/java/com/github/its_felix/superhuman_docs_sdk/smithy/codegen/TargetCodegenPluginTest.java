package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertEquals;
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
import software.amazon.smithy.model.shapes.OperationShape;
import software.amazon.smithy.model.shapes.ResourceShape;
import software.amazon.smithy.model.shapes.ServiceShape;
import software.amazon.smithy.model.shapes.ShapeId;

import org.junit.jupiter.api.Test;

final class TargetCodegenPluginTest {
    @Test
    void discoversAndRunsAllTargetPlugins() throws IOException {
        SmithyBuildResult result = runBuild(Map.of(
                MarkdownCodegenPlugin.PLUGIN_ID, settings(),
                PythonCodegenPlugin.PLUGIN_ID, settings(),
                GoCodegenPlugin.PLUGIN_ID, settings(),
                RustCodegenPlugin.PLUGIN_ID, settings(),
                ZigCodegenPlugin.PLUGIN_ID, settings()));

        assertFalse(result.anyBroken(), "Smithy build should complete without broken projections");
        ProjectionResult source = result.getProjectionResult("source").orElseThrow();
        MockManifest markdownManifest = (MockManifest) source
                .getPluginManifest(MarkdownCodegenPlugin.PLUGIN_ID).orElseThrow();
        MockManifest pythonManifest = (MockManifest) source
                .getPluginManifest(PythonCodegenPlugin.PLUGIN_ID).orElseThrow();
        MockManifest goManifest = (MockManifest) source
                .getPluginManifest(GoCodegenPlugin.PLUGIN_ID).orElseThrow();
        MockManifest rustManifest = (MockManifest) source
                .getPluginManifest(RustCodegenPlugin.PLUGIN_ID).orElseThrow();
        MockManifest zigManifest = (MockManifest) source
                .getPluginManifest(ZigCodegenPlugin.PLUGIN_ID).orElseThrow();

        String markdown = markdownManifest.expectFileString("sdk/markdown/service.md");
        assertTrue(markdown.contains("- Operations: `124`"));
        assertTrue(markdown.contains("## Resource hierarchy"));
        assertTrue(markdown.contains("com.superhuman.docs.v1#RowResource"));

        String python = pythonManifest.expectFileString("sdk/python/src/superhuman_docs/_generated.py");
        assertTrue(python.contains("ListDocs"));
        assertTrue(python.contains("class TablesResourceClient"));
        assertEquals(1, countOccurrences(python, "    def rows(self) -> RowsResourceClient:"));
        assertTrue(pythonManifest.expectFileString("sdk/python/src/superhuman_docs/_models.py")
                .contains("class ColumnFormatType(str, Enum)"));

        String goOperations = goManifest.expectFileString("sdk/go/operations_gen.go");
        String goTypes = goManifest.expectFileString("sdk/go/types_gen.go");
        assertTrue(goOperations.contains("func (r *TablesResourceClient) List"));
        assertTrue(goOperations.contains("func (r *TablesResourceClient) Rows"));
        assertFalse(goOperations.contains("func (c *Client) ListDocs"));
        assertFalse(goOperations.contains("func (c *Client) Rows"));
        assertTrue(goTypes.contains("type ColumnFormatType string"));
        assertTrue(goTypes.contains("ColumnFormatTypeDateTime"));

        String rust = rustManifest.expectFileString("sdk/rust/src/generated/operations.rs");
        assertTrue(rust.contains("pub enum ColumnFormatType"));
        assertTrue(rust.contains("pub fn tables(&self)"));
        assertTrue(rust.contains("pub fn list(&self, input: ListRowsInput)"));
        assertTrue(rust.contains("self.client.execute(request)"));
        assertFalse(rust.contains("pub fn build_"));
        assertEquals(1, countOccurrences(rust, "    pub fn rows(&self)"));

        String zig = zigManifest.expectFileString("sdk/zig/src/generated/operations.zig");
        assertTrue(zig.contains("pub const ColumnFormatType = enum"));
        assertTrue(zig.contains("pub const TablesResourceClient = struct"));
        assertTrue(zig.contains("pub fn list(self: TablesResourceClient"));
        assertTrue(zig.contains("pub fn whoami(self: *Client"));
        assertTrue(zig.contains("runtime.sendRequest(request)"));
        assertFalse(zig.contains("pub fn build"));
        assertEquals(1, countOccurrences(zig, "    pub fn rows(self:"));
    }

    @Test
    void canRunSingleTargetPlugin() throws IOException {
        SmithyBuildResult result = runBuild(Map.of(PythonCodegenPlugin.PLUGIN_ID, settings()));

        assertFalse(result.anyBroken(), "Smithy build should complete without broken projections");
        ProjectionResult source = result.getProjectionResult("source").orElseThrow();
        FileManifest manifest = source.getPluginManifest(PythonCodegenPlugin.PLUGIN_ID).orElseThrow();
        MockManifest mockManifest = (MockManifest) manifest;

        assertTrue(manifest.hasFile("sdk/python/src/superhuman_docs/_generated.py"));
        assertTrue(manifest.hasFile("sdk/python/src/superhuman_docs/_models.py"));
        assertTrue(mockManifest.expectFileString("sdk/python/src/superhuman_docs/_generated.py").contains("ListDocs"));
        assertFalse(manifest.hasFile("sdk/go/types_gen.go"));
        assertFalse(manifest.hasFile("sdk/rust/src/generated/operations.rs"));
        assertFalse(manifest.hasFile("sdk/zig/src/generated/operations.zig"));
    }

    @Test
    void discoversTargetPlugins() {
        var factory = SmithyBuildPlugin.createServiceFactory();

        assertNotNull(factory.apply(MarkdownCodegenPlugin.PLUGIN_ID).orElse(null));
        assertNotNull(factory.apply(PythonCodegenPlugin.PLUGIN_ID).orElse(null));
        assertNotNull(factory.apply(GoCodegenPlugin.PLUGIN_ID).orElse(null));
        assertNotNull(factory.apply(RustCodegenPlugin.PLUGIN_ID).orElse(null));
        assertNotNull(factory.apply(ZigCodegenPlugin.PLUGIN_ID).orElse(null));
    }

    @Test
    void modelUsesResourceTaxonomy() throws IOException {
        Model model = loadRepositoryModel();
        ServiceShape service = model.expectShape(
                ShapeId.from("com.superhuman.docs.v1#SuperhumanDocsApi"), ServiceShape.class);
        assertEquals(
                List.of("ResolveBrowserLink", "Whoami"),
                service.getOperations().stream().map(ShapeId::getName).sorted().toList());

        ResourceShape pages = model.expectShape(
                ShapeId.from("com.superhuman.docs.v1#PageResource"), ResourceShape.class);
        assertTrue(pages.getCreate().isPresent());
        assertTrue(pages.getRead().isPresent());
        assertTrue(pages.getDelete().isPresent());
        assertTrue(pages.getList().isPresent());

        ResourceShape tables = model.expectShape(
                ShapeId.from("com.superhuman.docs.v1#TableResource"), ResourceShape.class);
        assertTrue(service.getResources().contains(tables.getId()));
        assertTrue(tables.getResources().contains(ShapeId.from("com.superhuman.docs.v1#RowResource")));
        assertTrue(tables.getResources().contains(ShapeId.from("com.superhuman.docs.v1#ColumnResource")));

        for (OperationShape operation : model.getOperationShapes()) {
            assertTrue(operation.getInput().isPresent(), operation.getId() + " must have an input");
            assertTrue(operation.getOutput().isPresent(), operation.getId() + " must have an output");
        }
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

    private static int countOccurrences(String value, String needle) {
        int count = 0;
        int offset = 0;
        while ((offset = value.indexOf(needle, offset)) >= 0) {
            count++;
            offset += needle.length();
        }
        return count;
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
