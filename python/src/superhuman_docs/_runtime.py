from __future__ import annotations

import json
import os
from collections.abc import Callable, Iterable, Mapping
from dataclasses import dataclass
from typing import Any, Optional, Tuple
from urllib.error import HTTPError
from urllib.parse import quote, urlencode
from urllib.request import Request, urlopen


DEFAULT_BASE_URL = "https://coda.io/apis/v1"
Transport = Callable[["PreparedRequest", float], "Response"]


@dataclass(frozen=True)
class QueryBinding:
    member: str
    name: str


@dataclass(frozen=True)
class PathLabel:
    member: str


@dataclass(frozen=True)
class Operation:
    name: str
    method: str
    path: str
    status_code: int
    path_parts: Tuple[str | PathLabel, ...]
    labels: Tuple[str, ...] = ()
    queries: Tuple[QueryBinding, ...] = ()
    payload: Optional[str] = None
    required: Tuple[str, ...] = ()

    @property
    def members(self) -> set[str]:
        values = set(self.labels)
        values.update(binding.member for binding in self.queries)
        if self.payload is not None:
            values.add(self.payload)
        return values


@dataclass(frozen=True)
class PreparedRequest:
    method: str
    url: str
    headers: Mapping[str, str]
    body: Optional[bytes]


@dataclass(frozen=True)
class Response:
    status_code: int
    headers: Mapping[str, str]
    body: bytes


class ApiError(Exception):
    """Raised when the API returns an HTTP error status."""

    def __init__(
        self,
        status_code: int,
        message: str,
        *,
        response: Any = None,
        headers: Optional[Mapping[str, str]] = None,
    ) -> None:
        super().__init__(message)
        self.status_code = status_code
        self.response = response
        self.headers = dict(headers or {})


class BaseClient:
    """Shared HTTP implementation for generated Superhuman Docs operations."""

    def __init__(
        self,
        *,
        token: Optional[str] = None,
        base_url: str = DEFAULT_BASE_URL,
        timeout: float = 30.0,
        headers: Optional[Mapping[str, str]] = None,
        transport: Optional[Transport] = None,
    ) -> None:
        self.token = token if token is not None else os.getenv("SUPERHUMAN_DOCS_API_TOKEN")
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.headers = dict(headers or {})
        self.transport = transport

    def _request(self, operation: Operation, params: Mapping[str, Any]) -> Any:
        prepared = self._prepare_request(operation, params)
        if self.transport is not None:
            response = self.transport(prepared, self.timeout)
        else:
            response = self._send(prepared)
        return self._decode_response(response)

    def _prepare_request(self, operation: Operation, params: Mapping[str, Any]) -> PreparedRequest:
        unknown = sorted(name for name in params if name not in operation.members)
        if unknown:
            joined = ", ".join(unknown)
            raise TypeError(f"{operation.name} got unexpected parameter(s): {joined}")

        missing = [name for name in operation.required if params.get(name) is None]
        if missing:
            joined = ", ".join(missing)
            raise TypeError(f"{operation.name} missing required parameter(s): {joined}")

        path_values: list[str] = []
        for part in operation.path_parts:
            if isinstance(part, str):
                path_values.append(part)
                continue
            value = params.get(part.member)
            if value is None:
                raise TypeError(f"{operation.name} missing required label: {part.member}")
            path_values.append(quote(str(value), safe=""))
        path = "".join(path_values)

        query_pairs: list[tuple[str, str]] = []
        for binding in operation.queries:
            value = params.get(binding.member)
            if value is None:
                continue
            for item in _as_query_values(value):
                query_pairs.append((binding.name, item))

        url = f"{self.base_url}{path}"
        if query_pairs:
            url = f"{url}?{urlencode(query_pairs)}"

        body = None
        headers = {
            "Accept": "application/json",
            "User-Agent": "superhuman-docs-python/0.2.0",
            **self.headers,
        }
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"

        if operation.payload is not None and params.get(operation.payload) is not None:
            body = json.dumps(params[operation.payload], separators=(",", ":")).encode("utf-8")
            headers["Content-Type"] = "application/json"

        return PreparedRequest(operation.method, url, headers, body)

    def _send(self, prepared: PreparedRequest) -> Response:
        request = Request(
            prepared.url,
            data=prepared.body,
            headers=dict(prepared.headers),
            method=prepared.method,
        )
        try:
            with urlopen(request, timeout=self.timeout) as raw_response:
                return Response(
                    status_code=raw_response.status,
                    headers=dict(raw_response.headers.items()),
                    body=raw_response.read(),
                )
        except HTTPError as error:
            return Response(
                status_code=error.code,
                headers=dict(error.headers.items()),
                body=error.read(),
            )

    def _decode_response(self, response: Response) -> Any:
        decoded = _decode_body(response.body)
        if response.status_code >= 400:
            message = _error_message(decoded, response.status_code)
            raise ApiError(response.status_code, message, response=decoded, headers=response.headers)
        return decoded


def _as_query_values(value: Any) -> Iterable[str]:
    if isinstance(value, bool):
        return ("true" if value else "false",)
    if isinstance(value, (list, tuple, set, frozenset)):
        return tuple(_query_scalar(item) for item in value)
    return (_query_scalar(value),)


def _query_scalar(value: Any) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value)


def _decode_body(body: bytes) -> Any:
    if not body:
        return None
    text = body.decode("utf-8")
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return text


def _error_message(decoded: Any, status_code: int) -> str:
    if isinstance(decoded, Mapping):
        message = decoded.get("message") or decoded.get("statusMessage")
        if message:
            return str(message)
    return f"API request failed with HTTP {status_code}"
