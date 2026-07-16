from __future__ import annotations

from ._generated import GeneratedServiceClientMixin
from ._runtime import BaseClient


class SuperhumanDocsClient(GeneratedServiceClientMixin, BaseClient):
    """Client for the Superhuman Docs API."""


Client = SuperhumanDocsClient
