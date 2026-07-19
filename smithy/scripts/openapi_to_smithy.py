#!/usr/bin/env python3
"""Generate the initial Smithy model from the Superhuman Docs OpenAPI spec."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any


HTTP_METHODS = {"get", "put", "post", "delete", "patch", "head", "options"}
SHAPE_RENAMES = {
    "Acl2": "SharingMetadata",
    "AddPackMakerResponse2": "DeletePackMakerResponse",
    "AddGoLinkResult": "AddGoLinkResponse",
    "AddPermissionResult": "AddPermissionResponse",
    "ChangeRoleResult": "ChangeRoleResponse",
    "ControlType2": "ControlResourceType",
    "DeleteFolderResult": "DeleteFolderResponse",
    "DeletePermissionResult": "DeletePermissionResponse",
    "DocUpdate2": "DocUpdateResponse",
    "DocUpdateResult": "DocUpdateResponse",
    "PageContentDeleteResult": "PageContentDeleteResponse",
    "PageCreateResult": "PageCreateResponse",
    "PageDeleteResult": "PageDeleteResponse",
    "PageType2": "PageResourceType",
    "PageUpdateResult": "PageUpdateResponse",
    "PublishResult": "PublishResponse",
    "PushButtonResult": "PushButtonResponse",
    "RowDeleteResult": "RowDeleteResponse",
    "RowsDeleteResult": "RowsDeleteResponse",
    "RowsUpsertResult": "RowsUpsertResponse",
    "RowUpdateResult": "RowUpdateResponse",
    "TableType2": "TableResourceType",
    "UnpublishResult": "UnpublishResponse",
    "WebhookTriggerResult": "WebhookTriggerResponse",
}
DOMAIN_BY_TAG = {
    "Account": "docs",
    "Automations": "docs",
    "CustomDocDomains": "docs",
    "Docs": "docs",
    "Folders": "docs",
    "Go Links": "docs",
    "Miscellaneous": "docs",
    "Permissions": "docs",
    "Publishing": "docs",
    "Workspaces": "docs",
    "Pages": "pages",
    "Tables": "tables",
    "Columns": "tables",
    "Controls": "tables",
    "Formulas": "tables",
    "Rows": "rows",
    "Analytics": "analytics",
    "Packs": "packs",
}
DOMAIN_ORDER = ["docs", "pages", "tables", "rows", "packs", "analytics"]
SERVICE_OPERATIONS = ["Whoami", "ResolveBrowserLink"]
SERVICE_RESOURCES = [
    "CategoryResource",
    "DocResource",
    "TableResource",
    "FolderResource",
    "PackResource",
    "MarketplacePackListingResource",
    "UserPackInvitationResource",
    "WorkspaceResource",
    "OrganizationResource",
    "AnalyticsResource",
    "AgentInstanceResource",
    "MutationStatusResource",
    "CustomDocDomainProviderResource",
]
RESERVED = {
    "apply",
    "bigDecimal",
    "bigInteger",
    "blob",
    "boolean",
    "byte",
    "document",
    "double",
    "enum",
    "false",
    "float",
    "integer",
    "intEnum",
    "list",
    "long",
    "map",
    "metadata",
    "namespace",
    "operation",
    "resource",
    "service",
    "short",
    "string",
    "structure",
    "timestamp",
    "true",
    "union",
    "use",
}


def words(value: str) -> list[str]:
    value = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", value)
    return [part for part in re.split(r"[^A-Za-z0-9]+", value) if part]


def pascal(value: str, fallback: str = "Shape") -> str:
    parts = words(value)
    if not parts:
        parts = [fallback]
    name = "".join(part[:1].upper() + part[1:] for part in parts)
    if not re.match(r"[A-Za-z_]", name):
        name = fallback + name
    return name


def camel(value: str, fallback: str = "member") -> str:
    name = pascal(value, fallback)
    result = name[:1].lower() + name[1:]
    if result in RESERVED:
        result += "Value"
    return result


def enum_member(value: Any, fallback: str = "Value") -> str:
    raw = str(value)
    parts = words(raw)
    if not parts:
        parts = [fallback]
    name = "_".join(part.upper() for part in parts)
    if not re.match(r"[A-Za-z_]", name):
        name = fallback.upper() + "_" + name
    if name in {"TRUE", "FALSE"}:
        name += "_VALUE"
    return name


def q(value: str) -> str:
    return json.dumps(value, ensure_ascii=True)


def doc(value: str | None, indent: str = "") -> list[str]:
    if not value:
        return []
    cleaned = re.sub(r"\s+", " ", value).strip()
    if not cleaned:
        return []
    if len(cleaned) > 700:
        cleaned = cleaned[:697].rstrip() + "..."
    return [f"{indent}@documentation({q(cleaned)})"]


class Generator:
    def __init__(self, spec: dict[str, Any]) -> None:
        self.spec = spec
        operation_names = {
            pascal(op.get("operationId") or f"{method}_{path}", "Operation")
            for path, path_item in spec.get("paths", {}).items()
            for method, op in path_item.items()
            if method.lower() in HTTP_METHODS
        }
        self.schema_name_by_component = {}
        used_component_names: set[str] = set()
        for name, schema in spec.get("components", {}).get("schemas", {}).items():
            shape_name = pascal(schema.get("x-schema-name") or name)
            if shape_name.endswith("Request") and shape_name[:-7] in operation_names:
                shape_name = f"{shape_name[:-7]}Payload"
            base = shape_name
            index = 2
            while shape_name in used_component_names:
                shape_name = f"{base}{index}"
                index += 1
            used_component_names.add(shape_name)
            self.schema_name_by_component[name] = shape_name
        self.used_names: set[str] = set(self.schema_name_by_component.values())
        self.shape_kind: dict[str, str] = {}
        self.shapes: dict[str, str] = {}
        self.shape_files: dict[str, str] = {}
        self.inline_counts: dict[str, int] = {}
        self.current_file = "common"

    def unique_name(self, base: str) -> str:
        name = pascal(base)
        if name not in self.used_names:
            self.used_names.add(name)
            return name
        index = 2
        while f"{name}{index}" in self.used_names:
            index += 1
        name = f"{name}{index}"
        self.used_names.add(name)
        return name

    def inline_name(self, preferred: str) -> str:
        base = pascal(preferred)
        self.inline_counts[base] = self.inline_counts.get(base, 0) + 1
        suffix = self.inline_counts[base]
        return self.unique_name(base if suffix == 1 else f"{base}{suffix}")

    def ref_name(self, ref: str) -> str:
        return self.schema_name_by_component[ref.rsplit("/", 1)[-1]]

    def resolve_ref(self, ref: str) -> dict[str, Any]:
        if not ref.startswith("#/components/schemas/"):
            raise ValueError(f"unsupported ref: {ref}")
        return self.spec["components"]["schemas"][ref.rsplit("/", 1)[-1]]

    def schema_target(self, schema: dict[str, Any], preferred: str) -> str:
        if "$ref" in schema:
            name = self.ref_name(schema["$ref"])
            self.ensure_component(schema["$ref"].rsplit("/", 1)[-1])
            return name

        if "allOf" in schema and len(schema["allOf"]) == 2:
            refs = [part for part in schema["allOf"] if "$ref" in part]
            non_refs = [part for part in schema["allOf"] if "$ref" not in part]
            if len(refs) == 1 and not non_refs[0].get("properties"):
                return self.schema_target(refs[0], preferred)

        kind = schema.get("type")
        if schema.get("enum") is not None:
            name = self.inline_name(preferred)
            self.emit_enum(name, schema)
            return name
        if "oneOf" in schema or "anyOf" in schema:
            name = self.inline_name(preferred)
            self.emit_union(name, schema)
            return name
        if "allOf" in schema or kind == "object" or schema.get("properties"):
            name = self.inline_name(preferred)
            self.emit_structure(name, schema)
            return name
        if kind == "array":
            name = self.inline_name(preferred)
            self.emit_list(name, schema)
            return name
        return self.primitive_target(schema)

    def primitive_target(self, schema: dict[str, Any]) -> str:
        kind = schema.get("type")
        fmt = schema.get("format")
        if kind == "integer":
            return "Long" if fmt == "int64" else "Integer"
        if kind == "number":
            return "Double"
        if kind == "boolean":
            return "Boolean"
        if kind == "string":
            return "String"
        return "Document"

    def ensure_component(self, component: str) -> None:
        name = self.schema_name_by_component[component]
        if name in self.shapes:
            return
        schema = self.spec["components"]["schemas"][component]
        if schema.get("enum") is not None:
            self.emit_enum(name, schema)
        elif "oneOf" in schema or "anyOf" in schema:
            self.emit_union(name, schema)
        elif "allOf" in schema or schema.get("type") == "object" or schema.get("properties"):
            self.emit_structure(name, schema)
        elif schema.get("type") == "array":
            self.emit_list(name, schema)
        else:
            self.emit_scalar(name, schema)

    def collect_properties(
        self, schema: dict[str, Any], seen: set[str] | None = None
    ) -> tuple[dict[str, dict[str, Any]], set[str]]:
        seen = seen or set()
        properties: dict[str, dict[str, Any]] = {}
        required: set[str] = set(schema.get("required", []))
        if "$ref" in schema:
            ref = schema["$ref"]
            if ref in seen:
                return properties, required
            seen.add(ref)
            return self.collect_properties(self.resolve_ref(ref), seen)
        for part in schema.get("allOf", []):
            part_props, part_required = self.collect_properties(part, seen.copy())
            properties.update(part_props)
            required.update(part_required)
        properties.update(schema.get("properties", {}))
        return properties, required

    def emit_scalar(self, name: str, schema: dict[str, Any]) -> None:
        target = self.primitive_target(schema).lower()
        if target == "integer":
            head = "integer"
        elif target == "long":
            head = "long"
        elif target == "double":
            head = "double"
        elif target == "boolean":
            head = "boolean"
        elif target == "string":
            head = "string"
        else:
            head = "document"
        lines = doc(schema.get("description"))
        lines.append(f"{head} {name}")
        self.shape_kind[name] = head
        self.shapes[name] = "\n".join(lines)
        self.shape_files.setdefault(name, self.current_file)

    def emit_enum(self, name: str, schema: dict[str, Any]) -> None:
        used: set[str] = set()
        lines = doc(schema.get("description"))
        lines.append(f"enum {name} {{")
        for value in schema.get("enum", []):
            member = enum_member(value)
            base = member
            index = 2
            while member in used:
                member = f"{base}_{index}"
                index += 1
            used.add(member)
            lines.append(f"    @enumValue({q(str(value))})")
            lines.append(f"    {member}")
        lines.append("}")
        self.shape_kind[name] = "enum"
        self.shapes[name] = "\n".join(lines)
        self.shape_files.setdefault(name, self.current_file)

    def emit_list(self, name: str, schema: dict[str, Any]) -> None:
        member_target = self.schema_target(schema.get("items", {}), f"{name}Member")
        lines = doc(schema.get("description"))
        lines.extend([f"list {name} {{", f"    member: {member_target}", "}"])
        self.shape_kind[name] = "list"
        self.shapes[name] = "\n".join(lines)
        self.shape_files.setdefault(name, self.current_file)

    def emit_map(self, name: str, value_schema: dict[str, Any] | bool | None) -> None:
        value_target = "Document"
        if isinstance(value_schema, dict):
            value_target = self.schema_target(value_schema, f"{name}Value")
        lines = [f"map {name} {{", "    key: String", f"    value: {value_target}", "}"]
        self.shape_kind[name] = "map"
        self.shapes[name] = "\n".join(lines)
        self.shape_files.setdefault(name, self.current_file)

    def emit_union(self, name: str, schema: dict[str, Any]) -> None:
        variants = schema.get("oneOf") or schema.get("anyOf") or []
        lines = doc(schema.get("description"))
        lines.append(f"union {name} {{")
        used: set[str] = set()
        for index, variant in enumerate(variants, 1):
            target = self.schema_target(variant, f"{name}Variant{index}")
            if "$ref" in variant:
                member = camel(variant["$ref"].rsplit("/", 1)[-1])
            else:
                member = camel(f"variant{index}")
            base = member
            suffix = 2
            while member in used:
                member = f"{base}{suffix}"
                suffix += 1
            used.add(member)
            lines.append(f"    {member}: {target}")
        lines.append("}")
        self.shape_kind[name] = "union"
        self.shapes[name] = "\n".join(lines)
        self.shape_files.setdefault(name, self.current_file)

    def emit_structure(self, name: str, schema: dict[str, Any]) -> None:
        properties, required = self.collect_properties(schema)
        additional = schema.get("additionalProperties")
        if not properties and isinstance(additional, dict):
            self.emit_map(name, additional)
            return
        lines = doc(schema.get("description"))
        lines.append(f"structure {name} {{")
        used: set[str] = set()
        for prop, prop_schema in properties.items():
            member = camel(prop)
            base = member
            suffix = 2
            while member in used:
                member = f"{base}{suffix}"
                suffix += 1
            used.add(member)
            lines.extend(doc(prop_schema.get("description"), "    "))
            if prop in required:
                lines.append("    @required")
            if member != prop:
                lines.append(f"    @jsonName({q(prop)})")
            target = self.schema_target(prop_schema, f"{name}{pascal(prop)}")
            if prop == "packId" or (name == "Pack" and prop == "id"):
                target = "PackId"
            lines.append(f"    {member}: {target}")
            lines.append("")
        if lines[-1] == "":
            lines.pop()
        lines.append("}")
        self.shape_kind[name] = "structure"
        self.shapes[name] = "\n".join(lines)
        self.shape_files.setdefault(name, self.current_file)

    def emit_error(self, name: str, response: dict[str, Any], status_code: int) -> str:
        schema = (
            response.get("content", {})
            .get("application/json", {})
            .get("schema", {"type": "object"})
        )
        properties, required = self.collect_properties(schema)
        lines = doc(response.get("description") or schema.get("description"))
        lines.append('@error("client")')
        lines.append(f"@httpError({status_code})")
        lines.append(f"structure {name} {{")
        for prop, prop_schema in properties.items():
            member = camel(prop)
            lines.extend(doc(prop_schema.get("description"), "    "))
            if prop in required:
                lines.append("    @required")
            if member != prop:
                lines.append(f"    @jsonName({q(prop)})")
            target = self.schema_target(prop_schema, f"{name}{pascal(prop)}")
            lines.append(f"    {member}: {target}")
            lines.append("")
        if lines[-1] == "":
            lines.pop()
        lines.append("}")
        self.shape_kind[name] = "structure"
        self.shapes[name] = "\n".join(lines)
        self.shape_files[name] = "errors"
        return name

    def operation_response(
        self, op_name: str, responses: dict[str, Any], domain_file: str
    ) -> tuple[int, str | None]:
        success = sorted(
            int(code) for code in responses if code.isdigit() and 200 <= int(code) < 300
        )
        code = success[0] if success else 200
        response = responses.get(str(code), {})
        schema = (
            response.get("content", {})
            .get("application/json", {})
            .get("schema")
        )
        if not schema:
            output_name = self.unique_name(f"{op_name}Output")
            self.shapes[output_name] = f"structure {output_name} {{}}"
            self.shape_kind[output_name] = "structure"
            self.shape_files[output_name] = domain_file
            return code, output_name
        target = self.schema_target(schema, f"{op_name}Output")
        if self.shape_kind.get(target) == "structure":
            return code, target
        output_name = self.unique_name(f"{op_name}Output")
        self.shapes[output_name] = "\n".join(
            [
                f"structure {output_name} {{",
                "    @httpPayload",
                f"    body: {target}",
                "}",
            ]
        )
        self.shape_kind[output_name] = "structure"
        self.shape_files[output_name] = domain_file
        return code, output_name

    def build_operation(
        self,
        path: str,
        method: str,
        op: dict[str, Any],
        common_errors: dict[str, str],
    ) -> tuple[str, str, str]:
        op_name = pascal(op.get("operationId") or f"{method}_{path}", "Operation")
        tag = op.get("tags", [""])[0] if op.get("tags") else ""
        domain_file = DOMAIN_BY_TAG.get(tag, "docs")
        previous_file = self.current_file
        self.current_file = domain_file
        uri = path.replace("${docId}", "{docId}")
        members: list[tuple[str, list[str], str, bool]] = []
        used_members: set[str] = set()

        def add_member(raw_name: str, traits: list[str], target: str, required: bool) -> None:
            member = camel(raw_name)
            base = member
            suffix = 2
            while member in used_members:
                member = f"{base}{suffix}"
                suffix += 1
            used_members.add(member)
            members.append((member, traits, target, required))

        for parameter in op.get("parameters", []):
            if "$ref" in parameter:
                ref = parameter["$ref"].rsplit("/", 1)[-1]
                parameter = self.spec["components"]["parameters"][ref]
            pname = parameter["name"]
            loc = parameter["in"]
            pschema = parameter.get("schema", {})
            target = self.schema_target(pschema, f"{op_name}{pascal(pname)}")
            if pname == "packId":
                target = "PackId"
            elif pname == "packReleaseId":
                target = "String"
            traits: list[str] = []
            required = bool(parameter.get("required")) or loc == "path"
            if loc == "path":
                traits.append("@httpLabel")
            elif loc == "query":
                traits.append(f"@httpQuery({q(pname)})")
            elif loc == "header":
                traits.append(f"@httpHeader({q(pname)})")
            add_member(pname, traits, target, required)

        has_payload = False
        request_body = op.get("requestBody")
        if request_body:
            content = request_body.get("content", {})
            media = "application/json" if "application/json" in content else next(iter(content))
            schema = content[media].get("schema", {"type": "string"})
            target = self.schema_target(schema, f"{op_name}Request")
            add_member("payload", ["@httpPayload"], target, bool(request_body.get("required")))
            has_payload = True

        input_name = self.unique_name(f"{op_name}Input")
        lines = [f"structure {input_name} {{"]
        if members:
            for member, traits, target, required in members:
                for trait in traits:
                    lines.append(f"    {trait}")
                if required:
                    lines.append("    @required")
                lines.append(f"    {member}: {target}")
                lines.append("")
            if lines[-1] == "":
                lines.pop()
            lines.append("}")
        else:
            lines[-1] += "}"
        self.shapes[input_name] = "\n".join(lines)
        self.shape_kind[input_name] = "structure"
        self.shape_files[input_name] = domain_file

        code, output_name = self.operation_response(op_name, op.get("responses", {}), domain_file)
        errors: list[str] = []
        for status, response in op.get("responses", {}).items():
            if not status.isdigit() or int(status) < 400:
                continue
            if "$ref" in response:
                errors.append(common_errors[response["$ref"].rsplit("/", 1)[-1]])
        error_list = ", ".join(dict.fromkeys(errors))

        lines = doc(op.get("summary") or op.get("description"))
        if method == "get":
            lines.append("@readonly")
        if method in {"put", "delete"}:
            lines.append("@idempotent")
        if method == "delete" and has_payload:
            lines.append('@suppress(["HttpMethodSemantics.UnexpectedPayload"])')
        lines.append(f"@http(method: {q(method.upper())}, uri: {q(uri)}, code: {code})")
        lines.append(f"operation {op_name} {{")
        lines.append(f"    input: {input_name}")
        if output_name:
            lines.append(f"    output: {output_name}")
        if error_list:
            lines.append(f"    errors: [{error_list}]")
        lines.append("}")
        self.current_file = previous_file
        return op_name, "\n".join(lines), domain_file

    def normalize_doc_create_result(
        self, operations: list[tuple[str, str, str]]
    ) -> list[tuple[str, str, str]]:
        """Fold the create-doc response duplicate into the canonical Doc shape."""
        doc = self.shapes.get("Doc")
        doc2 = self.shapes.get("Doc2")
        if not doc or not doc2 or "requestId: String" not in doc2:
            return operations
        if "requestId: String" not in doc:
            before_close, close = doc.rstrip().rsplit("\n}", 1)
            self.shapes["Doc"] = "\n".join(
                [
                    before_close,
                    "",
                    '    @documentation("An arbitrary unique identifier for this request, included on doc creation responses.")',
                    "    requestId: String",
                    "}",
                ]
            )
        for duplicate in ("Doc2", "Doc2Type"):
            self.shapes.pop(duplicate, None)
            self.shape_kind.pop(duplicate, None)
            self.shape_files.pop(duplicate, None)
        return [
            (name, text.replace("    output: Doc2", "    output: Doc"), domain_file)
            for name, text, domain_file in operations
        ]

    def normalize_anonymous_unions(self) -> None:
        """Replace anonymous OpenAPI alternatives with semantic Smithy shapes.

        The public schema uses anonymous oneOf branches for several reusable value
        families. Translating those branches literally creates VariantN members and,
        for nested arrays, extra unions at every collection level. These curated
        expansions preserve the documented leaf alternatives while giving callers a
        flat, named choice for each final value shape.
        """

        def replace_group(
            root: str,
            generated: set[str],
            replacements: dict[str, tuple[str, list[str]]],
        ) -> None:
            if root not in self.shapes:
                return
            for name in generated:
                self.shapes.pop(name, None)
                self.shape_kind.pop(name, None)
                self.shape_files.pop(name, None)
            for name, (kind, lines) in replacements.items():
                self.shapes[name] = "\n".join(lines)
                self.shape_kind[name] = kind
                self.shape_files[name] = "common"

        replace_group(
            "CurrencyAmount",
            {"CurrencyAmount"},
            {
                "CurrencyAmount": (
                    "union",
                    [
                        '@documentation("A numeric monetary amount as a string or number.")',
                        "union CurrencyAmount {",
                        "    text: String",
                        "    number: Double",
                        "}",
                    ],
                )
            },
        )
        replace_group(
            "NumberOrNumberFormula",
            {"NumberOrNumberFormula"},
            {
                "NumberOrNumberFormula": (
                    "union",
                    [
                        '@documentation("A number or a string representing a formula that evaluates to a number.")',
                        "union NumberOrNumberFormula {",
                        "    number: Double",
                        "    formula: String",
                        "}",
                    ],
                )
            },
        )
        replace_group(
            "ScalarValue",
            {"ScalarValue"},
            {
                "ScalarValue": (
                    "union",
                    [
                        '@documentation("A Superhuman Docs result or entity expressed as a primitive type.")',
                        "union ScalarValue {",
                        "    text: String",
                        "    number: Double",
                        "    boolean: Boolean",
                        "}",
                    ],
                )
            },
        )
        replace_group(
            "Value",
            {
                "Value",
                "ValueVariant2",
                "ValueVariant2Member",
                "ValueVariant2MemberVariant2",
            },
            {
                "Value": (
                    "union",
                    [
                        '@documentation("A Superhuman Docs result or entity expressed as a primitive type, or array of primitive types.")',
                        "union Value {",
                        "    scalar: ScalarValue",
                        "    flatList: ScalarValueList",
                        "    nestedList: ScalarValueNestedList",
                        "}",
                    ],
                ),
                "ScalarValueList": (
                    "list",
                    ["list ScalarValueList {", "    member: ScalarValue", "}"],
                ),
                "ScalarValueNestedList": (
                    "list",
                    [
                        "list ScalarValueNestedList {",
                        "    member: ScalarValueList",
                        "}",
                    ],
                ),
            },
        )
        replace_group(
            "RichValue",
            {
                "RichValue",
                "RichValueVariant2",
                "RichValueVariant2Member",
                "RichValueVariant2MemberVariant2",
            },
            {
                "RichValue": (
                    "union",
                    [
                        '@documentation("A cell value that contains rich structured data.")',
                        "union RichValue {",
                        "    single: RichSingleValue",
                        "    flatList: RichSingleValueList",
                        "    nestedList: RichSingleValueNestedList",
                        "}",
                    ],
                ),
                "RichSingleValueList": (
                    "list",
                    [
                        "list RichSingleValueList {",
                        "    member: RichSingleValue",
                        "}",
                    ],
                ),
                "RichSingleValueNestedList": (
                    "list",
                    [
                        "list RichSingleValueNestedList {",
                        "    member: RichSingleValueList",
                        "}",
                    ],
                ),
            },
        )
        replace_group(
            "PageCreateContent",
            {
                "PageCreateContent",
                "PageCreateContentVariant1",
                "PageCreateContentVariant1Type",
                "PageCreateContentVariant2",
                "PageCreateContentVariant2Type",
                "PageCreateContentVariant3",
                "PageCreateContentVariant3Variant1",
                "PageCreateContentVariant3Variant1Mode",
                "PageCreateContentVariant3Variant1Type",
                "PageCreateContentVariant3Variant2",
                "PageCreateContentVariant3Variant2Mode",
                "PageCreateContentVariant3Variant2Type",
            },
            {
                "PageCreateContent": (
                    "union",
                    [
                        '@documentation("Content that can be added to a page at creation time, either text (or rich text) or a URL to create a full-page embed.")',
                        "union PageCreateContent {",
                        "    canvas: PageCreateCanvasContent",
                        "    embed: PageCreateEmbedContent",
                        "    pageSync: PageCreatePageSyncContent",
                        "    documentSync: PageCreateDocumentSyncContent",
                        "}",
                    ],
                ),
                "PageCreateCanvasContent": (
                    "structure",
                    [
                        "structure PageCreateCanvasContent {",
                        '    @documentation("Indicates a page containing canvas content.")',
                        "    @required",
                        "    type: PageType",
                        "",
                        "    @required",
                        "    canvasContent: PageContent",
                        "}",
                    ],
                ),
                "PageCreateEmbedContent": (
                    "structure",
                    [
                        "structure PageCreateEmbedContent {",
                        '    @documentation("Indicates a page that embeds other content.")',
                        "    @required",
                        "    type: PageType",
                        "",
                        '    @documentation("The URL of the content to embed.")',
                        "    @required",
                        "    url: String",
                        "",
                        "    renderMethod: PageEmbedRenderMethod",
                        "}",
                    ],
                ),
                "PageCreatePageSyncContent": (
                    "structure",
                    [
                        "structure PageCreatePageSyncContent {",
                        '    @documentation("Indicates a page that embeds other Superhuman Docs content.")',
                        "    @required",
                        "    type: PageType",
                        "",
                        '    @documentation("Indicates a single-page sync page.")',
                        "    @required",
                        "    mode: SyncPageType",
                        "",
                        '    @documentation("Include subpages in the sync page.")',
                        "    @required",
                        "    includeSubpages: Boolean",
                        "",
                        '    @documentation("The page id to insert as a sync page.")',
                        "    @required",
                        "    sourcePageId: String",
                        "",
                        '    @documentation("The id of the document to insert as a sync page.")',
                        "    @required",
                        "    sourceDocId: String",
                        "}",
                    ],
                ),
                "PageCreateDocumentSyncContent": (
                    "structure",
                    [
                        "structure PageCreateDocumentSyncContent {",
                        '    @documentation("Indicates a page that embeds other content.")',
                        "    @required",
                        "    type: PageType",
                        "",
                        '    @documentation("Indicates a full doc sync page.")',
                        "    @required",
                        "    mode: SyncPageType",
                        "",
                        '    @documentation("The id of the document to insert as a sync page.")',
                        "    @required",
                        "    sourceDocId: String",
                        "}",
                    ],
                ),
            },
        )

    def normalize_shape_names(
        self, operations: list[tuple[str, str, str]]
    ) -> list[tuple[str, str, str]]:
        """Replace generated collision suffixes with stable domain names."""
        for old_name, new_name in SHAPE_RENAMES.items():
            if old_name not in self.shapes:
                continue
            self.shapes[new_name] = re.sub(
                rf"\b{re.escape(old_name)}\b", new_name, self.shapes.pop(old_name)
            )
            self.shape_kind[new_name] = self.shape_kind.pop(old_name)
            self.shape_files[new_name] = self.shape_files.pop(old_name)

        for shape_name, shape_text in list(self.shapes.items()):
            for old_name, new_name in SHAPE_RENAMES.items():
                shape_text = re.sub(rf"\b{re.escape(old_name)}\b", new_name, shape_text)
            self.shapes[shape_name] = shape_text

        renamed_operations: list[tuple[str, str, str]] = []
        for name, text, domain_file in operations:
            for old_name, new_name in SHAPE_RENAMES.items():
                text = re.sub(rf"\b{re.escape(old_name)}\b", new_name, text)
            renamed_operations.append((name, text, domain_file))
        return renamed_operations

    def generate(self, output_dir: Path) -> None:
        for component in self.spec.get("components", {}).get("schemas", {}):
            self.ensure_component(component)

        common_errors: dict[str, str] = {}
        for name, response in self.spec.get("components", {}).get("responses", {}).items():
            code_by_name = {
                "BadRequestError": 400,
                "BadRequestWithValidationErrors": 400,
                "UnauthorizedError": 401,
                "ForbiddenError": 403,
                "NotFoundError": 404,
                "GoneError": 410,
                "UnprocessableEntityError": 422,
                "TooManyRequestsError": 429,
            }
            common_errors[name] = self.emit_error(pascal(name), response, code_by_name[name])

        operations: list[tuple[str, str, str]] = []
        for path, path_item in self.spec["paths"].items():
            for method, op in path_item.items():
                if method.lower() in HTTP_METHODS:
                    operations.append(self.build_operation(path, method, op, common_errors))
        self.normalize_anonymous_unions()
        operations = self.normalize_doc_create_result(operations)
        operations = self.normalize_shape_names(operations)

        model_dir = output_dir / "model"
        model_dir.mkdir(parents=True, exist_ok=True)
        # Resource taxonomy is a hand-maintained Smithy overlay because OpenAPI
        # tags do not express lifecycle bindings, properties, or child resources.
        resource_overlay_path = model_dir / "resources.smithy"
        resource_overlay = resource_overlay_path.read_text(encoding="utf-8") if resource_overlay_path.exists() else None
        for old_model in model_dir.glob("*.smithy"):
            old_model.unlink()
        operation_names = [name for name, _, _ in operations]

        service = [
            '$version: "2"',
            'metadata openapiSource = "https://docs.superhuman.com/apis/v1/openapi.json"',
            'metadata originalApiTitle = "Coda API"',
            'metadata originalApiVersion = "1.5.0"',
            "",
            "namespace com.superhuman.docs.v1",
            "",
            "use smithy.api#documentation",
            "use smithy.api#httpBearerAuth",
            "",
            '@documentation("Superhuman Docs API v1, generated from the public OpenAPI description. The published OpenAPI document still identifies the API as Coda API v1.")',
            "@httpBearerAuth",
            "service SuperhumanDocsApi {",
            '    version: "1.5.0"',
            "    operations: [",
        ]
        direct_operations = SERVICE_OPERATIONS if resource_overlay else operation_names
        service.extend(f"        {name}" for name in direct_operations)
        service.append("    ]")
        if resource_overlay:
            service.append("    resources: [")
            service.extend(f"        {name}" for name in SERVICE_RESOURCES)
            service.append("    ]")
        service.extend(["}", ""])

        domain_prelude = [
            '$version: "2"',
            "namespace com.superhuman.docs.v1",
            "",
            "use smithy.api#documentation",
            "use smithy.api#enumValue",
            "use smithy.api#error",
            "use smithy.api#http",
            "use smithy.api#httpError",
            "use smithy.api#httpHeader",
            "use smithy.api#httpLabel",
            "use smithy.api#httpPayload",
            "use smithy.api#httpQuery",
            "use smithy.api#idempotent",
            "use smithy.api#jsonName",
            "use smithy.api#readonly",
            "use smithy.api#required",
            "use smithy.api#suppress",
            "",
        ]

        common_lines = [
            '$version: "2"',
            "namespace com.superhuman.docs.v1",
            "",
            "use smithy.api#documentation",
            "use smithy.api#enumValue",
            "use smithy.api#httpPayload",
            "use smithy.api#jsonName",
            "use smithy.api#required",
            "",
        ]

        errors_lines = [
            '$version: "2"',
            "namespace com.superhuman.docs.v1",
            "",
            "use smithy.api#documentation",
            "use smithy.api#error",
            "use smithy.api#httpError",
            "use smithy.api#jsonName",
            "use smithy.api#required",
            "",
        ]

        lines_by_file: dict[str, list[str]] = {domain: domain_prelude.copy() for domain in DOMAIN_ORDER}
        lines_by_file["common"] = common_lines
        lines_by_file["errors"] = errors_lines

        for _, text, domain_file in operations:
            lines_by_file[domain_file].append(text)
            lines_by_file[domain_file].append("")

        for name in sorted(self.shapes):
            file_name = self.shape_files.get(name, "common")
            lines_by_file[file_name].append(self.shapes[name])
            lines_by_file[file_name].append("")

        (model_dir / "main.smithy").write_text("\n".join(service), encoding="utf-8")
        for file_name in ["common", "errors", *DOMAIN_ORDER]:
            (model_dir / f"{file_name}.smithy").write_text(
                "\n".join(lines_by_file[file_name]), encoding="utf-8"
            )
        if resource_overlay is not None:
            resource_overlay_path.write_text(resource_overlay, encoding="utf-8")


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: openapi_to_smithy.py OPENAPI_JSON OUTPUT_DIR", file=sys.stderr)
        return 2
    spec = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    Generator(spec).generate(Path(sys.argv[2]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
