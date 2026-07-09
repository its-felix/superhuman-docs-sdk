import json
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from superhuman_docs import SuperhumanDocsClient
from superhuman_docs._runtime import Response


class ClientTests(unittest.TestCase):
    def test_get_request_encodes_labels_and_query(self):
        captured = []

        def transport(request, timeout):
            captured.append((request, timeout))
            return Response(200, {"content-type": "application/json"}, b'{"ok":true}')

        client = SuperhumanDocsClient(token="token", base_url="https://example.test/api", transport=transport)

        result = client.list_rows(
            doc_id="doc/1",
            table_id_or_name="Table A",
            use_column_names=True,
            value_format="simple",
            limit=5,
        )

        self.assertEqual(result, {"ok": True})
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
            return Response(201, {}, b'{"id":"doc1"}')

        client = SuperhumanDocsClient(token="token", base_url="https://example.test/api", transport=transport)
        result = client.create_doc(payload={"title": "Roadmap"})

        self.assertEqual(result, {"id": "doc1"})
        request = captured[0]
        self.assertEqual(request.method, "POST")
        self.assertEqual(request.url, "https://example.test/api/docs")
        self.assertEqual(request.headers["Content-Type"], "application/json")
        self.assertEqual(json.loads(request.body.decode("utf-8")), {"title": "Roadmap"})

    def test_optional_payload_can_be_omitted(self):
        captured = []

        def transport(request, timeout):
            captured.append(request)
            return Response(202, {}, b'{"requestId":"req1"}')

        client = SuperhumanDocsClient(token="token", base_url="https://example.test/api", transport=transport)
        result = client.delete_page_content(doc_id="doc1", page_id_or_name="page1")

        self.assertEqual(result, {"requestId": "req1"})
        request = captured[0]
        self.assertEqual(request.method, "DELETE")
        self.assertEqual(request.url, "https://example.test/api/docs/doc1/pages/page1/content")
        self.assertIsNone(request.body)
        self.assertNotIn("Content-Type", request.headers)


if __name__ == "__main__":
    unittest.main()
