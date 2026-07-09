#!/usr/bin/env python3
from __future__ import annotations

import ast
import keyword
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


REPO_ROOT = Path(__file__).resolve().parents[2]
MODEL_DIR = REPO_ROOT / "smithy" / "model"
OUTPUT = REPO_ROOT / "python" / "src" / "superhuman_docs" / "_generated.py"


@dataclass(frozen=True)
class Member:
    name: str
    traits: tuple[str, ...]
    query_name: str | None


@dataclass(frozen=True)
class OperationDef:
    name: str
    method: str
    path: str
    status_code: int
    input_shape: str | None
    documentation: str | None


def main() -> None:
    text_by_file = {path.name: path.read_text(encoding="utf-8") for path in sorted(MODEL_DIR.glob("*.smithy"))}
    structures = parse_structures("\n".join(text_by_file.values()))
    operations = parse_operations(text_by_file)
    service_order = parse_service_order(text_by_file["main.smithy"])
    ordered = [operations[name] for name in service_order if name in operations]
    missing = sorted(set(service_order) - set(operations))
    if missing:
        raise SystemExit(f"Service references operations not found in model: {', '.join(missing)}")
    OUTPUT.write_text(render(ordered, structures), encoding="utf-8")


def parse_service_order(text: str) -> list[str]:
    match = re.search(r"operations:\s*\[(.*?)\]", text, re.S)
    if not match:
        raise SystemExit("Could not find service operations in main.smithy")
    return re.findall(r"\b[A-Z][A-Za-z0-9_]*\b", match.group(1))


def parse_operations(text_by_file: dict[str, str]) -> dict[str, OperationDef]:
    operations: dict[str, OperationDef] = {}
    for text in text_by_file.values():
        pending_doc: str | None = None
        pending_http: tuple[str, str, int] | None = None
        lines = text.splitlines()
        index = 0
        while index < len(lines):
            stripped = lines[index].strip()
            if stripped.startswith("@documentation("):
                pending_doc = parse_documentation(stripped)
            elif stripped.startswith("@http("):
                block, index = collect_trait_block(lines, index)
                pending_http = parse_http(block)
            elif stripped.startswith("operation "):
                block, index = collect_shape_block(lines, index)
                name = re.match(r"operation\s+([A-Za-z0-9_]+)", stripped).group(1)  # type: ignore[union-attr]
                input_match = re.search(r"\binput:\s*([A-Za-z0-9_]+)", block)
                if pending_http is None:
                    raise SystemExit(f"Operation {name} is missing @http")
                method, path, status_code = pending_http
                operations[name] = OperationDef(
                    name=name,
                    method=method,
                    path=path,
                    status_code=status_code,
                    input_shape=input_match.group(1) if input_match else None,
                    documentation=pending_doc,
                )
                pending_doc = None
                pending_http = None
            index += 1
    return operations


def parse_structures(text: str) -> dict[str, tuple[Member, ...]]:
    structures: dict[str, tuple[Member, ...]] = {}
    lines = text.splitlines()
    index = 0
    while index < len(lines):
        stripped = lines[index].strip()
        match = re.match(r"structure\s+([A-Za-z0-9_]+)\s*(\{)?", stripped)
        if not match:
            index += 1
            continue
        name = match.group(1)
        if stripped.endswith("{}"):
            structures[name] = ()
            index += 1
            continue
        block, index = collect_shape_block(lines, index)
        structures[name] = tuple(parse_members(block))
        index += 1
    return structures


def parse_members(block: str) -> list[Member]:
    members: list[Member] = []
    traits: list[str] = []
    query_name: str | None = None
    for raw_line in block.splitlines()[1:-1]:
        line = raw_line.strip()
        if not line:
            continue
        if line.startswith("@"):
            trait_name = line[1:].split("(", 1)[0]
            traits.append(trait_name)
            if trait_name == "httpQuery":
                value = re.search(r'@httpQuery\("([^"]+)"\)', line)
                if value:
                    query_name = value.group(1)
            continue
        match = re.match(r"([A-Za-z_][A-Za-z0-9_]*):\s*([A-Za-z0-9_.$#]+)", line)
        if match:
            members.append(Member(match.group(1), tuple(traits), query_name))
            traits = []
            query_name = None
    return members


def collect_trait_block(lines: list[str], start: int) -> tuple[str, int]:
    collected = [lines[start]]
    balance = lines[start].count("(") - lines[start].count(")")
    index = start
    while balance > 0:
        index += 1
        collected.append(lines[index])
        balance += lines[index].count("(") - lines[index].count(")")
    return "\n".join(collected), index


def collect_shape_block(lines: list[str], start: int) -> tuple[str, int]:
    collected = [lines[start]]
    balance = lines[start].count("{") - lines[start].count("}")
    index = start
    while balance > 0:
        index += 1
        collected.append(lines[index])
        balance += lines[index].count("{") - lines[index].count("}")
    return "\n".join(collected), index


def parse_documentation(line: str) -> str | None:
    match = re.search(r"@documentation\((.*)\)", line)
    if not match:
        return None
    return ast.literal_eval(match.group(1))


def parse_http(block: str) -> tuple[str, str, int]:
    method = require_match(r'method:\s*"([^"]+)"', block, "@http method")
    path = require_match(r'uri:\s*"([^"]+)"', block, "@http uri")
    status_code = int(require_match(r"code:\s*([0-9]+)", block, "@http code"))
    return method, path, status_code


def require_match(pattern: str, text: str, label: str) -> str:
    match = re.search(pattern, text, re.S)
    if not match:
        raise SystemExit(f"Could not parse {label}: {text}")
    return match.group(1)


def render(operations: Iterable[OperationDef], structures: dict[str, tuple[Member, ...]]) -> str:
    operation_list = list(operations)
    lines: list[str] = [
        "# Code generated by python/scripts/generate.py; DO NOT EDIT.",
        "from __future__ import annotations",
        "",
        "from typing import Any",
        "",
        "from ._runtime import Operation, PathLabel, QueryBinding",
        "",
        "",
        "OPERATIONS = {",
    ]
    for operation in operation_list:
        members = structures.get(operation.input_shape or "", ())
        labels = tuple(member.name for member in members if "httpLabel" in member.traits)
        queries = tuple((member.name, member.query_name or member.name) for member in members if "httpQuery" in member.traits)
        payload = next((member.name for member in members if "httpPayload" in member.traits), None)
        required = tuple(member.name for member in members if "required" in member.traits)
        lines.extend(
            [
                f'    "{operation.name}": Operation(',
                f'        name="{operation.name}",',
                f'        method="{operation.method}",',
                f'        path="{operation.path}",',
                f"        status_code={operation.status_code},",
                f"        path_parts={render_path_parts(operation.path)},",
                f"        labels={labels!r},",
                f"        queries={render_queries(queries)},",
                f"        payload={payload!r},",
                f"        required={required!r},",
                "    ),",
            ]
        )
    lines.extend(["}", "", "", "class GeneratedOperationsMixin:", ""])
    for operation in operation_list:
        lines.extend(render_method(operation, structures.get(operation.input_shape or "", ())))
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def render_queries(queries: tuple[tuple[str, str], ...]) -> str:
    if not queries:
        return "()"
    values = ", ".join(f'QueryBinding("{member}", "{name}")' for member, name in queries)
    if len(queries) == 1:
        values += ","
    return f"({values})"


def render_path_parts(path: str) -> str:
    parts: list[str] = []
    pos = 0
    for match in re.finditer(r"\{([A-Za-z_][A-Za-z0-9_]*)\}", path):
        if match.start() > pos:
            parts.append(repr(path[pos : match.start()]))
        parts.append(f'PathLabel("{match.group(1)}")')
        pos = match.end()
    if pos < len(path):
        parts.append(repr(path[pos:]))
    if not parts:
        return "()"
    if len(parts) == 1:
        return f"({parts[0]},)"
    return f"({', '.join(parts)})"


def render_method(operation: OperationDef, members: tuple[Member, ...]) -> list[str]:
    method_name = to_snake(operation.name)
    required_members = [member for member in members if "required" in member.traits]
    optional_members = [member for member in members if "required" not in member.traits]
    ordered_members = required_members + optional_members
    param_names = {member.name: safe_name(to_snake(member.name)) for member in ordered_members}
    signature_parts = [f"{param_names[member.name]}: Any" for member in required_members]
    signature_parts.extend(f"{param_names[member.name]}: Any = None" for member in optional_members)
    if signature_parts:
        signature = f"self, *, {', '.join(signature_parts)}"
    else:
        signature = "self"
    lines = [f"    def {method_name}({signature}) -> Any:"]
    doc = operation.documentation or operation.name
    lines.append(f'        """{escape_doc(doc)}')
    lines.append("")
    lines.append(f"        HTTP {operation.method} {operation.path}")
    lines.append('        """')
    if ordered_members:
        lines.append("        params = {")
        for member in ordered_members:
            lines.append(f'            "{member.name}": {param_names[member.name]},')
        lines.append("        }")
    else:
        lines.append("        params = {}")
    lines.append(f'        return self._request(OPERATIONS["{operation.name}"], params)')
    return lines


def to_snake(value: str) -> str:
    value = re.sub(r"(.)([A-Z][a-z]+)", r"\1_\2", value)
    value = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", value)
    return value.lower()


def safe_name(value: str) -> str:
    if keyword.iskeyword(value):
        return f"{value}_"
    return value


def escape_doc(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"""', '\\"\\"\\"')


if __name__ == "__main__":
    main()
