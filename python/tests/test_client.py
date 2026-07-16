import json
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from superhuman_docs import SuperhumanDocsClient
from superhuman_docs._models import (
    DeletePageContentInput,
    DocUpdate,
    ListRowsInput,
    PageContentDeleteResponse,
    RowList,
    UpdateDocInput,
    ValueFormat,
)
from superhuman_docs._runtime import Response


class ClientTests(unittest.TestCase):
    def test_legacy_dynamic_request_api_is_not_exposed(self):
        client = SuperhumanDocsClient(token="token")

        self.assertFalse(hasattr(client, "request"))
        self.assertFalse(hasattr(client, "rows"))

    def test_transport_object_uses_send_request_boundary(self):
        class Transport:
            def __init__(self):
                self.calls = []

            def send_request(self, request, timeout):
                self.calls.append((request, timeout))
                return Response(200, {}, b'{"items":[]}')

        transport = Transport()
        client = SuperhumanDocsClient(
            token="token",
            base_url="https://example.test/api",
            timeout=7.5,
            transport=transport,
        )

        result = client.tables().rows().list(ListRowsInput(doc_id="doc1", table_id_or_name="grid1"))

        self.assertIsInstance(result, RowList)
        self.assertEqual(len(transport.calls), 1)
        self.assertEqual(transport.calls[0][1], 7.5)

    def test_get_request_encodes_labels_and_query(self):
        captured = []

        def transport(request, timeout):
            captured.append((request, timeout))
            return Response(200, {"content-type": "application/json"}, b'{"items":[]}')

        client = SuperhumanDocsClient(token="token", base_url="https://example.test/api", transport=transport)

        result = client.tables().rows().list(ListRowsInput(
            doc_id="doc/1",
            table_id_or_name="Table A",
            use_column_names=True,
            value_format=ValueFormat.SIMPLE,
            limit=5,
        ))

        self.assertIsInstance(result, RowList)
        self.assertEqual(result.items, [])
        request, timeout = captured[0]
        self.assertEqual(timeout, 30.0)
        self.assertEqual(request.method, "GET")
        self.assertEqual(
            request.url,
            "https://example.test/api/docs/doc%2F1/tables/Table%20A/rows?useColumnNames=true&valueFormat=simple&limit=5",
        )
        self.assertEqual(request.headers["Authorization"], "Bearer token")
        self.assertIsNone(request.body)

    def test_json_payload_is_sent_for_payload_member(self):
        captured = []

        def transport(request, timeout):
            captured.append(request)
            return Response(200, {}, b'{}')

        client = SuperhumanDocsClient(token="token", base_url="https://example.test/api", transport=transport)
        result = client.docs().update(UpdateDocInput(doc_id="doc1", payload=DocUpdate(title="Roadmap")))

        request = captured[0]
        self.assertEqual(request.method, "PATCH")
        self.assertEqual(request.url, "https://example.test/api/docs/doc1")
        self.assertEqual(request.headers["Content-Type"], "application/json")
        self.assertEqual(json.loads(request.body.decode("utf-8")), {"title": "Roadmap"})

    def test_optional_payload_can_be_omitted(self):
        captured = []

        def transport(request, timeout):
            captured.append(request)
            return Response(202, {}, b'{"requestId":"req1","id":"page1"}')

        client = SuperhumanDocsClient(token="token", base_url="https://example.test/api", transport=transport)
        result = client.docs().pages().delete_page_content(
            DeletePageContentInput(doc_id="doc1", page_id_or_name="page1")
        )

        self.assertIsInstance(result, PageContentDeleteResponse)
        self.assertEqual(result.request_id, "req1")
        request = captured[0]
        self.assertEqual(request.method, "DELETE")
        self.assertEqual(request.url, "https://example.test/api/docs/doc1/pages/page1/content")
        self.assertIsNone(request.body)
        self.assertNotIn("Content-Type", request.headers)


if __name__ == "__main__":
    unittest.main()
