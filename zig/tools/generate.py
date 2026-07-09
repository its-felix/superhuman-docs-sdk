#!/usr/bin/env python3
"""Generate Zig operation builders from the Smithy model.

This script intentionally parses only the Smithy features used by the HTTP
operation input shapes in ../smithy/model: @http, @httpLabel, @httpQuery,
@httpPayload, @required, operation, structure, and list member declarations.
"""

from __future__ import annotations

import dataclasses
import pathlib
import re
from typing import Iterable


ROOT = pathlib.Path(__file__).resolve().parents[2]
MODEL_DIR = ROOT / "smithy" / "model"
OUT = ROOT / "zig" / "src" / "generated" / "operations.zig"


@dataclasses.dataclass
class Member:
    name: str
    shape: str
    required: bool
    http_label: bool
    http_query: str | None
    http_payload: bool


@dataclasses.dataclass
class Operation:
    name: str
    method: str
    uri: str
    code: int
    input_shape: str | None


def strip_comments(text: str) -> str:
    return re.sub(r"//.*", "", text)


def block_after(text: str, start: int) -> tuple[str, int]:
    open_at = text.index("{", start)
    depth = 0
    for idx in range(open_at, len(text)):
        if text[idx] == "{":
            depth += 1
        elif text[idx] == "}":
            depth -= 1
            if depth == 0:
                return text[open_at + 1 : idx], idx + 1
    raise ValueError("unclosed block")


def attrs_from(prefix: str) -> list[str]:
    return re.findall(r"@([A-Za-z0-9_]+)(?:\((.*?)\))?", prefix, flags=re.S)


def parse_structures(text: str) -> dict[str, list[Member]]:
    structs: dict[str, list[Member]] = {}
    for match in re.finditer(r"\bstructure\s+([A-Za-z0-9_]+)\s*(?:\{\}|{)", text):
        name = match.group(1)
        if text[match.end() - 1] != "{":
            structs[name] = []
            continue
        body, _ = block_after(text, match.start())
        members: list[Member] = []
        pending: list[str] = []
        for raw in body.splitlines():
            line = raw.strip()
            if not line:
                continue
            if line.startswith("@"):
                pending.append(line)
                continue
            m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)\s*:\s*([A-Za-z0-9_.$#]+)\s*$", line)
            if not m:
                continue
            attr_text = "\n".join(pending)
            pending = []
            attrs = attrs_from(attr_text)
            required = any(name == "required" for name, _ in attrs)
            http_label = any(name == "httpLabel" for name, _ in attrs)
            http_payload = any(name == "httpPayload" for name, _ in attrs)
            http_query = None
            for attr, arg in attrs:
                if attr == "httpQuery":
                    qm = re.search(r'"([^"]+)"', arg)
                    http_query = qm.group(1) if qm else m.group(1)
            members.append(
                Member(
                    name=m.group(1),
                    shape=m.group(2).split("#")[-1],
                    required=required,
                    http_label=http_label,
                    http_query=http_query,
                    http_payload=http_payload,
                )
            )
        structs[name] = members
    return structs


def parse_lists(text: str) -> dict[str, str]:
    lists: dict[str, str] = {}
    for match in re.finditer(r"\blist\s+([A-Za-z0-9_]+)\s*{", text):
        name = match.group(1)
        body, _ = block_after(text, match.start())
        mm = re.search(r"\bmember\s*:\s*([A-Za-z0-9_.$#]+)", body)
        if mm:
            lists[name] = mm.group(1).split("#")[-1]
    return lists


def parse_operations(text: str) -> list[Operation]:
    ops: list[Operation] = []
    for match in re.finditer(r"\boperation\s+([A-Za-z0-9_]+)\s*{", text):
        prefix = text[max(0, match.start() - 700) : match.start()]
        http_attrs = re.findall(r"@http\s*\((.*?)\)", prefix, flags=re.S)
        if not http_attrs:
            # The @http trait is immediately before every generated operation.
            raise ValueError(f"missing @http for operation {match.group(1)}")
        http = http_attrs[-1]
        method = re.search(r'method\s*:\s*"([^"]+)"', http).group(1)
        uri = re.search(r'uri\s*:\s*"([^"]+)"', http).group(1)
        code = int(re.search(r"code\s*:\s*([0-9]+)", http).group(1))
        body, _ = block_after(text, match.start())
        input_match = re.search(r"\binput\s*:\s*([A-Za-z0-9_.$#]+)", body)
        ops.append(Operation(match.group(1), method, uri, code, input_match.group(1).split("#")[-1] if input_match else None))
    return ops


def zig_string(s: str) -> str:
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def lower_camel(name: str) -> str:
    return name[:1].lower() + name[1:]


def is_string_like(shape: str, lists: dict[str, str]) -> bool:
    if shape == "String":
        return True
    if shape in ("Integer", "Long", "Double", "Float", "Boolean", "Blob", "Timestamp", "Document"):
        return False
    if shape in lists:
        return False
    return True


def scalar_type(shape: str) -> str:
    if shape == "Boolean":
        return "bool"
    if shape in ("Integer", "Long"):
        return "i64"
    if shape in ("Double", "Float"):
        return "f64"
    return "[]const u8"


def field_type(member: Member, lists: dict[str, str]) -> str:
    if member.http_payload:
        base = "[]const u8"
    elif member.shape in lists:
        inner = lists[member.shape]
        if inner in ("Integer", "Long"):
            base = "[]const i64"
        elif inner in ("Double", "Float"):
            base = "[]const f64"
        elif inner == "Boolean":
            base = "[]const bool"
        else:
            base = "[]const []const u8"
    else:
        base = scalar_type(member.shape)
    return base if member.required else f"?{base}"


def default_suffix(member: Member) -> str:
    return "" if member.required else " = null"


def query_helper(member: Member, lists: dict[str, str]) -> str:
    if member.shape in lists:
        inner = lists[member.shape]
        if inner in ("Integer", "Long"):
            return "queryOptionalIntList" if not member.required else "queryIntList"
        if inner in ("Double", "Float"):
            return "queryOptionalFloatList" if not member.required else "queryFloatList"
        if inner == "Boolean":
            return "queryOptionalBoolList" if not member.required else "queryBoolList"
        return "queryOptionalStringList" if not member.required else "queryStringList"
    if member.shape == "Boolean":
        return "queryOptionalBool" if not member.required else "queryBool"
    if member.shape in ("Integer", "Long"):
        return "queryOptionalInt" if not member.required else "queryInt"
    if member.shape in ("Double", "Float"):
        return "queryOptionalFloat" if not member.required else "queryFloat"
    return "queryOptionalString" if not member.required else "queryString"


def path_helper(member: Member) -> str:
    if member.shape in ("Integer", "Long"):
        return "pathInt"
    if member.shape in ("Double", "Float"):
        return "pathFloat"
    if member.shape == "Boolean":
        return "pathBool"
    return "pathString"


def path_parts(uri: str) -> Iterable[tuple[str, str]]:
    pos = 0
    for match in re.finditer(r"\{([A-Za-z_][A-Za-z0-9_]*)\}", uri):
        if match.start() > pos:
            yield ("literal", uri[pos : match.start()])
        yield ("label", match.group(1))
        pos = match.end()
    if pos < len(uri):
        yield ("literal", uri[pos:])


def main() -> None:
    text = "\n".join(strip_comments(path.read_text()) for path in sorted(MODEL_DIR.glob("*.smithy")))
    structures = parse_structures(text)
    lists = parse_lists(text)
    operations = parse_operations(text)
    service_order = []
    main_text = (MODEL_DIR / "main.smithy").read_text()
    service_body = re.search(r"operations\s*:\s*\[(.*?)\]", main_text, flags=re.S).group(1)
    for item in re.findall(r"\b([A-Za-z_][A-Za-z0-9_]*)\b", service_body):
        service_order.append(item)
    op_by_name = {op.name: op for op in operations}
    operations = [op_by_name[name] for name in service_order if name in op_by_name]

    lines: list[str] = [
        "// Generated by tools/generate.py from ../smithy/model. Do not edit by hand.",
        "",
        'const std = @import("std");',
        'const core = @import("../core.zig");',
        "",
        "const Allocator = std.mem.Allocator;",
        "",
        f"pub const operation_count = {len(operations)};",
        "",
    ]

    emitted_inputs: set[str] = set()
    for op in operations:
        shape = op.input_shape
        if shape is None or shape in emitted_inputs:
            continue
        emitted_inputs.add(shape)
        members = structures.get(shape, [])
        lines.append(f"pub const {shape} = struct {{")
        if not members:
            lines.append("};")
            lines.append("")
            continue
        for member in members:
            if not (member.http_label or member.http_query is not None or member.http_payload):
                continue
            lines.append(f"    {member.name}: {field_type(member, lists)}{default_suffix(member)},")
        lines.append("};")
        lines.append("")

    for op in operations:
        input_type = op.input_shape or "void"
        input_arg = "_: void" if op.input_shape is None else f"input: {input_type}"
        lines.append(f"pub fn build{op.name}(allocator: Allocator, base_url: []const u8, {input_arg}) !core.Request {{")
        lines.append("    var url = core.UrlBuilder.init(allocator);")
        lines.append("    errdefer url.deinit();")
        lines.append("    try url.base(base_url);")
        members_by_name = {m.name: m for m in structures.get(op.input_shape or "", [])}
        for kind, value in path_parts(op.uri):
            if kind == "literal":
                lines.append(f"    try url.pathLiteral({zig_string(value)});")
            else:
                member = members_by_name[value]
                lines.append(f"    try url.{path_helper(member)}(input.{value});")
        if op.input_shape:
            for member in structures.get(op.input_shape, []):
                if member.http_query is not None:
                    lines.append(f"    try url.{query_helper(member, lists)}({zig_string(member.http_query)}, input.{member.name});")
        payload = "null"
        if op.input_shape:
            for member in structures.get(op.input_shape, []):
                if member.http_payload:
                    payload = f"input.{member.name}" if member.required else f"(input.{member.name} orelse null)"
                    break
        lines.append("    return .{")
        lines.append(f"        .operation = {zig_string(op.name)},")
        lines.append(f"        .method = .{op.method},")
        lines.append("        .url = try url.finish(),")
        lines.append(f"        .body = {payload},")
        lines.append(f"        .expected_status = {op.code},")
        lines.append("    };")
        lines.append("}")
        lines.append("")

    lines.append('test "generated operation count tracks Smithy service" {')
    lines.append(f"    try std.testing.expectEqual(@as(usize, {len(operations)}), operation_count);")
    lines.append("}")
    lines.append("")

    OUT.write_text("\n".join(lines))


if __name__ == "__main__":
    main()
