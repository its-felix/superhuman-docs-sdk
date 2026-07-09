package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.shapes.OperationShape;
import software.amazon.smithy.model.shapes.ServiceShape;
import software.amazon.smithy.model.shapes.ShapeId;

final class SdkCodegen {
    private SdkCodegen() {}

    static ServiceShape service(Model model, SuperhumanDocsSettings settings) {
        return settings.service()
                .map(ShapeId::from)
                .map(id -> model.expectShape(id, ServiceShape.class))
                .orElseGet(() -> model.getServiceShapes().stream()
                        .min(Comparator.comparing(shape -> shape.getId().toString()))
                        .orElseThrow(() -> new IllegalStateException("No service shape found in Smithy model")));
    }

    static List<OperationShape> operationsInServiceOrder(Model model, ServiceShape service) {
        List<OperationShape> result = new ArrayList<>();
        for (ShapeId id : service.getAllOperations()) {
            result.add(model.expectShape(id, OperationShape.class));
        }
        return result;
    }
}
