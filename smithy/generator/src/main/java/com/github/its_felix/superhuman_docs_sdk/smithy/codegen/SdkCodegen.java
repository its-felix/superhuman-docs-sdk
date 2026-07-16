package com.github.its_felix.superhuman_docs_sdk.smithy.codegen;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import software.amazon.smithy.model.Model;
import software.amazon.smithy.model.shapes.OperationShape;
import software.amazon.smithy.model.shapes.ResourceShape;
import software.amazon.smithy.model.shapes.ServiceShape;
import software.amazon.smithy.model.shapes.Shape;
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
        return operationBindings(model, service).stream().map(OperationBinding::operation).toList();
    }

    static List<Shape> dataShapesInNamespace(Model model, String namespace) {
        return model.shapes()
                .filter(shape -> shape.getId().getNamespace().equals(namespace))
                .filter(shape -> !shape.isOperationShape()
                        && !shape.isServiceShape()
                        && !shape.isResourceShape()
                        && !shape.isMemberShape())
                .sorted(Comparator.comparing(shape -> shape.getId().getName()))
                .toList();
    }

    static List<ResourceShape> resourcesInServiceOrder(Model model, ServiceShape service) {
        List<ResourceShape> result = new ArrayList<>();
        Set<ShapeId> visited = new HashSet<>();
        for (ShapeId resourceId : service.getResources()) {
            collectResources(model, resourceId, result, visited);
        }
        return result;
    }

    static List<ResourceShape> topLevelResourcesInServiceOrder(Model model, ServiceShape service) {
        return service.getResources().stream()
                .map(id -> model.expectShape(id, ResourceShape.class))
                .toList();
    }

    static List<OperationBinding> operationBindings(Model model, ServiceShape service) {
        List<OperationBinding> result = new ArrayList<>();
        Set<ShapeId> visitedOperations = new HashSet<>();
        for (ShapeId id : service.getOperations()) {
            result.add(new OperationBinding(model.expectShape(id, OperationShape.class), null, id.getName()));
            visitedOperations.add(id);
        }
        for (ResourceShape resource : resourcesInServiceOrder(model, service)) {
            for (ShapeId operationId : resourceOperationsInLifecycleOrder(resource)) {
                if (visitedOperations.add(operationId)) {
                    result.add(new OperationBinding(
                            model.expectShape(operationId, OperationShape.class),
                            resource,
                            resourceMethodName(resource, operationId)));
                }
            }
        }
        return result;
    }

    private static List<ShapeId> resourceOperationsInLifecycleOrder(ResourceShape resource) {
        Set<ShapeId> result = new LinkedHashSet<>();
        resource.getPut().ifPresent(result::add);
        resource.getCreate().ifPresent(result::add);
        resource.getRead().ifPresent(result::add);
        resource.getUpdate().ifPresent(result::add);
        resource.getDelete().ifPresent(result::add);
        resource.getList().ifPresent(result::add);
        result.addAll(resource.getOperations());
        result.addAll(resource.getCollectionOperations());
        return List.copyOf(result);
    }

    static Map<ShapeId, ResourceShape> resourceParents(Model model, ServiceShape service) {
        Map<ShapeId, ResourceShape> result = new LinkedHashMap<>();
        for (ResourceShape parent : resourcesInServiceOrder(model, service)) {
            for (ShapeId child : parent.getResources()) {
                result.put(child, parent);
            }
        }
        return result;
    }

    static String resourceBaseName(ResourceShape resource) {
        String name = resource.getId().getName();
        return name.endsWith("Resource") ? name.substring(0, name.length() - "Resource".length()) : name;
    }

    static String resourceAccessorName(ResourceShape resource) {
        String name = resourceBaseName(resource);
        if (name.equals("Analytics")) {
            return name;
        }
        if (name.endsWith("Category")) {
            return name.substring(0, name.length() - 1) + "ies";
        }
        if (name.endsWith("s")) {
            return name;
        }
        return name + "s";
    }

    private static String resourceMethodName(ResourceShape resource, ShapeId operationId) {
        if (resource.getPut().filter(operationId::equals).isPresent()) return "Put";
        if (resource.getCreate().filter(operationId::equals).isPresent()) return "Create";
        if (resource.getRead().filter(operationId::equals).isPresent()) return "Read";
        if (resource.getUpdate().filter(operationId::equals).isPresent()) return "Update";
        if (resource.getDelete().filter(operationId::equals).isPresent()) return "Delete";
        if (resource.getList().filter(operationId::equals).isPresent()) return "List";
        return operationId.getName();
    }

    private static void collectResources(
            Model model,
            ShapeId resourceId,
            List<ResourceShape> result,
            Set<ShapeId> visited
    ) {
        if (!visited.add(resourceId)) {
            return;
        }
        ResourceShape resource = model.expectShape(resourceId, ResourceShape.class);
        result.add(resource);
        for (ShapeId childId : resource.getResources()) {
            collectResources(model, childId, result, visited);
        }
    }

    record OperationBinding(OperationShape operation, ResourceShape resource, String methodName) {
        boolean isServiceOperation() {
            return resource == null;
        }
    }
}
