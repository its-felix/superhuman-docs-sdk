from __future__ import annotations

from typing import Any

from ._generated import OPERATIONS, GeneratedOperationsMixin
from ._runtime import BaseClient


class SuperhumanDocsClient(GeneratedOperationsMixin, BaseClient):
    """Client for the Superhuman Docs API."""

    def request(self, operation_name: str, **params: Any) -> Any:
        """Call an operation by its Smithy operation name using Smithy member names."""
        try:
            operation = OPERATIONS[operation_name]
        except KeyError as error:
            raise ValueError(f"Unknown operation: {operation_name}") from error
        return self._request(operation, params)


Client = SuperhumanDocsClient
