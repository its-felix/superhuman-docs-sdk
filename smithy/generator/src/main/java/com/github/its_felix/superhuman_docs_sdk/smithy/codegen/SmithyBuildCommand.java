package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import software.amazon.smithy.build.SmithyBuild;
import software.amazon.smithy.build.SmithyBuildPlugin;
import software.amazon.smithy.model.Model;

public final class SmithyBuildCommand {
    private SmithyBuildCommand() {}

    public static void main(String[] args) throws IOException {
        Path smithyDirectory = args.length > 0 ? Path.of(args[0]) : Path.of("smithy");
        Set<String> plugins = Arrays.stream(args).skip(1).collect(Collectors.toSet());
        List<Path> sources;
        try (var stream = Files.list(smithyDirectory.resolve("model"))) {
            sources = stream
                    .filter(path -> path.getFileName().toString().endsWith(".smithy"))
                    .sorted()
                    .toList();
        }
        var assembler = Model.assembler();
        sources.forEach(assembler::addImport);

        ClassLoader classLoader = SmithyBuildCommand.class.getClassLoader();
        SmithyBuild build = SmithyBuild.create(classLoader)
                .config(smithyDirectory.resolve("smithy-build.json"))
                .importBasePath(smithyDirectory)
                .registerSources(sources.toArray(Path[]::new))
                .model(assembler.assemble().unwrap())
                .outputDirectory(smithyDirectory.resolve("build").resolve("smithy"))
                .pluginFactory(SmithyBuildPlugin.createServiceFactory(classLoader));
        if (!plugins.isEmpty()) {
            build.pluginFilter(plugins::contains);
        }
        build.build();
    }
}
