#!/usr/bin/env python3
from __future__ import annotations

import dataclasses
import keyword
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


PACKAGE = "superhumandocs"
ROOT = Path(__file__).resolve().parents[2]
MODEL_DIR = ROOT / "smithy" / "model"
OUT_DIR = ROOT / "go"


@dataclasses.dataclass
class Trait:
    name: str
    value: str = ""


@dataclasses.dataclass
class Member:
    name: str
    target: str
    traits: list[Trait]


@dataclasses.dataclass
class Shape:
    kind: str
    name: str
    traits: list[Trait]
    members: list[Member] = dataclasses.field(default_factory=list)
    enum_values: list[tuple[str, str]] = dataclasses.field(default_factory=list)
    input: str = ""
    output: str = ""
    errors: list[str] = dataclasses.field(default_factory=list)
    http_method: str = ""
    http_uri: str = ""
    http_code: int = 0


def sanitize_comments(text: str) -> str:
    return text


def parse_trait(raw: str) -> Trait:
    raw = " ".join(raw.strip().split())
    name = raw[1:]
    value = ""
    if "(" in name:
        name, value = name.split("(", 1)
        value = value.rsplit(")", 1)[0].strip()
    return Trait(name=name, value=value)


def without_strings(text: str) -> str:
    return re.sub(r'"(?:\\.|[^"\\])*"', '""', text)


def brace_delta(text: str) -> int:
    text = without_strings(text)
    return text.count("{") - text.count("}")


def paren_delta(text: str) -> int:
    text = without_strings(text)
    return text.count("(") - text.count(")")


def trait_value(traits: list[Trait], name: str) -> str:
    for trait in traits:
        if trait.name == name:
            value = trait.value
            if len(value) >= 2 and value[0] == '"' and value[-1] == '"':
                return value[1:-1]
            return value
    return ""


def has_trait(traits: list[Trait], name: str) -> bool:
    return any(trait.name == name for trait in traits)


def parse_model() -> dict[str, Shape]:
    shapes: dict[str, Shape] = {}
    for path in sorted(MODEL_DIR.glob("*.smithy")):
        lines = sanitize_comments(path.read_text()).splitlines()
        pending: list[Trait] = []
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            if not line:
                i += 1
                continue
            if line.startswith("@"):
                parts = [line]
                balance = paren_delta(line)
                while balance > 0 and i + 1 < len(lines):
                    i += 1
                    parts.append(lines[i].strip())
                    balance += paren_delta(lines[i])
                pending.append(parse_trait(" ".join(parts)))
                i += 1
                continue

            simple = re.match(r"^(string|integer|long|double|boolean|blob|timestamp|document)\s+([A-Za-z_][A-Za-z0-9_]*)$", line)
            if simple:
                kind, name = simple.groups()
                shapes[name] = Shape(kind=kind, name=name, traits=pending)
                pending = []
                i += 1
                continue

            block = re.match(r"^(service|operation|structure|list|map|enum|union)\s+([A-Za-z_][A-Za-z0-9_]*)(?:\s*\{)?", line)
            if not block:
                pending = []
                i += 1
                continue
            kind, name = block.groups()
            shape = Shape(kind=kind, name=name, traits=pending)
            pending = []

            if "{" not in line:
                i += 1
                continue
            if "}" in line and line.index("{") < line.index("}"):
                shapes[name] = shape
                i += 1
                continue

            depth = brace_delta(line)
            i += 1
            inner_pending: list[Trait] = []
            while i < len(lines) and depth > 0:
                raw = lines[i]
                stripped = raw.strip()
                if not stripped or stripped == "]" or stripped == "}," or stripped == "}":
                    depth += brace_delta(stripped)
                    i += 1
                    continue
                if stripped.startswith("@"):
                    parts = [stripped]
                    balance = paren_delta(stripped)
                    while balance > 0 and i + 1 < len(lines):
                        i += 1
                        parts.append(lines[i].strip())
                        balance += paren_delta(lines[i])
                    inner_pending.append(parse_trait(" ".join(parts)))
                    depth += brace_delta(" ".join(parts))
                    i += 1
                    continue
                if kind == "operation":
                    if stripped.startswith("input:"):
                        shape.input = stripped.split(":", 1)[1].strip()
                    elif stripped.startswith("output:"):
                        shape.output = stripped.split(":", 1)[1].strip()
                    elif stripped.startswith("errors:"):
                        values = []
                        if "[" in stripped and "]" in stripped:
                            values = stripped.split("[", 1)[1].split("]", 1)[0].split(",")
                        else:
                            i += 1
                            while i < len(lines) and "]" not in lines[i]:
                                item = lines[i].strip().rstrip(",")
                                if item:
                                    values.append(item)
                                i += 1
                        shape.errors = [v.strip().rstrip(",") for v in values if v.strip().rstrip(",")]
                    depth += brace_delta(stripped)
                    i += 1
                    continue
                if kind == "service":
                    depth += brace_delta(stripped)
                    i += 1
                    continue
                member = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):\s*([A-Za-z_][A-Za-z0-9_]*)", stripped)
                if member:
                    shape.members.append(Member(member.group(1), member.group(2), inner_pending))
                    inner_pending = []
                    depth += brace_delta(stripped)
                    i += 1
                    continue
                enum_member = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)$", stripped.rstrip(","))
                if kind == "enum" and enum_member:
                    literal = trait_value(inner_pending, "enumValue") or enum_member.group(1)
                    shape.enum_values.append((enum_member.group(1), literal))
                    inner_pending = []
                depth += brace_delta(stripped)
                i += 1

            if kind == "operation":
                http = next((t.value for t in shape.traits if t.name == "http"), "")
                shape.http_method = re_search(http, r'method:\s*"([^"]+)"')
                shape.http_uri = re_search(http, r'uri:\s*"([^"]+)"')
                code = re_search(http, r"code:\s*([0-9]+)")
                shape.http_code = int(code or 0)
            shapes[name] = shape
    return shapes


def re_search(text: str, pattern: str) -> str:
    match = re.search(pattern, text)
    return match.group(1) if match else ""


INITIALISMS = {"id": "ID", "url": "URL", "api": "API", "acl": "ACL", "oauth": "OAuth", "json": "JSON", "http": "HTTP"}
KEYWORDS = {"type", "map", "func", "var", "const", "range", "select", "case", "defer", "go", "chan", "interface", "struct", "package", "default", "fallthrough", "for", "if", "else", "switch", "return", "break", "continue"}


def export_name(name: str) -> str:
    parts = re.findall(r"[A-Za-z]+|[0-9]+", name.replace("_", " "))
    if not parts:
        return "Value"
    out = []
    for part in parts:
        low = part.lower()
        out.append(INITIALISMS.get(low, part[:1].upper() + part[1:]))
    result = "".join(out)
    if result in {"Type", "Map", "Func", "Var"}:
        result += "Value"
    if result and result[0].isdigit():
        result = "Value" + result
    return result


def json_name(member: Member) -> str:
    return trait_value(member.traits, "jsonName") or member.name


def is_required(member: Member) -> bool:
    return has_trait(member.traits, "required")


def target_type(target: str, shapes: dict[str, Shape], required: bool = True) -> str:
    primitives = {
        "String": "string",
        "Integer": "int",
        "Long": "int64",
        "Double": "float64",
        "Float": "float64",
        "Boolean": "bool",
        "Blob": "[]byte",
        "Document": "any",
        "Timestamp": "string",
    }
    if target in primitives:
        typ = primitives[target]
    else:
        shape = shapes.get(target)
        if not shape:
            typ = export_name(target)
        elif shape.kind == "list":
            typ = "[]" + target_type(shape.members[0].target, shapes, True)
        elif shape.kind == "map":
            key = "string"
            val = "any"
            for m in shape.members:
                if m.name == "key":
                    key = target_type(m.target, shapes, True)
                elif m.name == "value":
                    val = target_type(m.target, shapes, True)
            typ = "map[" + key + "]" + val
        elif shape.kind in primitives:
            typ = primitives[shape.kind]
        else:
            typ = export_name(target)
    if required:
        return typ
    if typ.startswith("[]") or typ.startswith("map[") or typ == "any" or typ == "[]byte":
        return typ
    return "*" + typ


def enum_const(shape_name: str, member_name: str, literal: str) -> str:
    suffix = export_name(member_name)
    if suffix == "Value" and literal:
        suffix = export_name(literal)
    return export_name(shape_name) + suffix


def render_types(shapes: dict[str, Shape]) -> str:
    lines = [
        "// Code generated by scripts/generate.py; DO NOT EDIT.",
        "",
        f"package {PACKAGE}",
        "",
    ]
    for name in sorted(shapes):
        shape = shapes[name]
        if shape.kind in {"operation", "service"}:
            continue
        go_name = export_name(name)
        if shape.kind in {"string", "integer", "long", "double", "boolean", "blob", "timestamp", "document"}:
            lines.append(f"type {go_name} {target_type({'string':'String','integer':'Integer','long':'Long','double':'Double','boolean':'Boolean','blob':'Blob','timestamp':'Timestamp','document':'Document'}[shape.kind], shapes)}")
            lines.append("")
        elif shape.kind == "enum":
            lines.append(f"type {go_name} string")
            lines.append("")
            if shape.enum_values:
                lines.append("const (")
                used: set[str] = set()
                for member, literal in shape.enum_values:
                    const = enum_const(name, member, literal)
                    base = const
                    n = 2
                    while const in used:
                        const = f"{base}{n}"
                        n += 1
                    used.add(const)
                    lines.append(f'\t{const} {go_name} = "{literal}"')
                lines.append(")")
                lines.append("")
            lines.append(f"func (v {go_name}) String() string {{ return string(v) }}")
            lines.append("")
        elif shape.kind == "list":
            member_target = shape.members[0].target if shape.members else "Document"
            lines.append(f"type {go_name} []{target_type(member_target, shapes, True)}")
            lines.append("")
        elif shape.kind == "map":
            key = "string"
            value = "any"
            for member in shape.members:
                if member.name == "key":
                    key = target_type(member.target, shapes, True)
                if member.name == "value":
                    value = target_type(member.target, shapes, True)
            lines.append(f"type {go_name} map[{key}]{value}")
            lines.append("")
        elif shape.kind in {"structure", "union"}:
            lines.append(f"type {go_name} struct {{")
            used_fields: set[str] = set()
            for member in shape.members:
                field = export_name(member.name)
                if field.lower() in KEYWORDS:
                    field += "Value"
                base = field
                n = 2
                while field in used_fields:
                    field = f"{base}{n}"
                    n += 1
                used_fields.add(field)
                required = is_required(member) and shape.kind == "structure"
                typ = target_type(member.target, shapes, required)
                tag = json_name(member)
                if not required:
                    tag += ",omitempty"
                lines.append(f"\t{field} {typ} `json:\"{tag}\"`")
            lines.append("}")
            lines.append("")
    return "\n".join(lines)


def render_operations(shapes: dict[str, Shape]) -> str:
    ops = [s for s in shapes.values() if s.kind == "operation"]
    ops.sort(key=lambda s: s.name)
    lines = [
        "// Code generated by scripts/generate.py; DO NOT EDIT.",
        "",
        f"package {PACKAGE}",
        "",
        "import (",
        '\t"context"',
        '\t"net/http"',
        '\t"net/url"',
        ")",
        "",
    ]
    for op in ops:
        output_type = "*" + export_name(op.output) if op.output else "any"
        if op.input:
            input_type = "*" + export_name(op.input)
            lines.append(f"func (c *Client) {export_name(op.name)}(ctx context.Context, input {input_type}) ({output_type}, error) {{")
            lines.append("\tif input == nil {")
            lines.append(f"\t\tinput = &{export_name(op.input)}{{}}")
            lines.append("\t}")
        else:
            lines.append(f"func (c *Client) {export_name(op.name)}(ctx context.Context) ({output_type}, error) {{")
        lines.append(f"\tpath := {render_go_path(op, shapes)}")
        lines.append("\tquery := url.Values{}")
        payload_expr = "nil"
        if op.input and op.input in shapes:
            input_shape = shapes[op.input]
            for member in input_shape.members:
                field = export_name(member.name)
                if field.lower() in KEYWORDS:
                    field += "Value"
                if has_trait(member.traits, "httpQuery"):
                    qname = trait_value(member.traits, "httpQuery")
                    lines.append(f'\taddQueryValue(query, "{qname}", input.{field})')
                elif has_trait(member.traits, "httpPayload"):
                    payload_expr = f"input.{field}"
        if output_type == "any":
            lines.append(f'\terr := c.do(ctx, http.Method{method_const(op.http_method)}, path, query, {payload_expr}, nil)')
            lines.append("\treturn nil, err")
        else:
            lines.append(f"\tvar out {export_name(op.output)}")
            lines.append(f'\terr := c.do(ctx, http.Method{method_const(op.http_method)}, path, query, {payload_expr}, &out)')
            lines.append("\treturn &out, err")
        lines.append("}")
        lines.append("")
    return "\n".join(lines)


def render_go_path(op: Shape, shapes: dict[str, Shape]) -> str:
    labels: dict[str, str] = {}
    if op.input and op.input in shapes:
        for member in shapes[op.input].members:
            if has_trait(member.traits, "httpLabel"):
                field = export_name(member.name)
                if field.lower() in KEYWORDS:
                    field += "Value"
                labels[member.name] = field

    parts: list[str] = []
    pos = 0
    for match in re.finditer(r"\{([A-Za-z_][A-Za-z0-9_]*)\}", op.http_uri):
        if match.start() > pos:
            parts.append(repr_go_string(op.http_uri[pos : match.start()]))
        label = match.group(1)
        field = labels.get(label)
        if field is None:
            raise ValueError(f"missing @httpLabel member {label} for {op.name}")
        parts.append(f"pathEscape(input.{field})")
        pos = match.end()
    if pos < len(op.http_uri):
        parts.append(repr_go_string(op.http_uri[pos:]))
    if not parts:
        return '""'
    return " + ".join(parts)


def repr_go_string(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def method_const(method: str) -> str:
    return {
        "GET": "Get",
        "POST": "Post",
        "PUT": "Put",
        "PATCH": "Patch",
        "DELETE": "Delete",
        "HEAD": "Head",
    }.get(method.upper(), "Get")


def main() -> int:
    shapes = parse_model()
    generated = [OUT_DIR / "types_gen.go", OUT_DIR / "operations_gen.go"]
    generated[0].write_text(render_types(shapes) + "\n")
    generated[1].write_text(render_operations(shapes) + "\n")
    gofmt = os.environ.get("GOFMT") or shutil.which("gofmt")
    if gofmt:
        subprocess.run([gofmt, "-w", *(str(path) for path in generated)], check=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
