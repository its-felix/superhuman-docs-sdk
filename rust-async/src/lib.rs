pub mod core;
pub mod generated;

pub use core::{
    Client, ClientOptions, Error, Method, Request, Response, Transport, TransportFuture,
    UrlBuilder, DEFAULT_BASE_URL,
};
pub use generated::operations;
pub use generated::operations::models;

#[cfg(test)]
mod tests {
    use std::sync::{Arc, Mutex};

    use super::{operations, Client, ClientOptions, Request, Response, Transport, TransportFuture};
    use serde_json::json;

    #[derive(Clone)]
    struct MockTransport {
        captured: Arc<Mutex<Vec<Request>>>,
        response: Response,
    }

    impl Transport for MockTransport {
        fn send_request(&self, request: Request) -> TransportFuture<'_> {
            let captured = Arc::clone(&self.captured);
            let response = self.response.clone();
            Box::pin(async move {
                captured.lock().expect("capture lock").push(request);
                Ok(response)
            })
        }
    }

    #[tokio::test]
    async fn resource_client_routes_typed_operation_through_transport() {
        let captured = Arc::new(Mutex::new(Vec::new()));
        let client = Client::new(ClientOptions::new(MockTransport {
            captured: Arc::clone(&captured),
            response: Response {
                status: 202,
                body: b"{}".to_vec(),
            },
        }))
        .expect("client");

        let _deleted = client
            .docs()
            .delete(operations::DeleteDocInput {
                doc_id: "doc 1".to_string(),
            })
            .await
            .expect("typed delete response");

        let request = captured
            .lock()
            .expect("capture lock")
            .pop()
            .expect("request");
        assert_eq!(request.operation, "DeleteDoc");
        assert_eq!(request.method.as_str(), "DELETE");
        assert_eq!(
            request.url,
            "https://docs.superhuman.com/apis/v1/docs/doc%201"
        );
        assert_eq!(request.expected_status, 202);
    }

    #[tokio::test]
    async fn generated_delete_rows_preserves_json_body() {
        let captured = Arc::new(Mutex::new(Vec::new()));
        let client = Client::new(ClientOptions::new(MockTransport {
            captured: Arc::clone(&captured),
            response: Response {
                status: 202,
                body: br#"{"requestId":"request-1","rowIds":["row-1","row-2"]}"#.to_vec(),
            },
        }))
        .expect("client");

        client
            .tables()
            .rows()
            .delete_rows(operations::DeleteRowsInput {
                doc_id: "doc-1".to_string(),
                table_id_or_name: "grid-1".to_string(),
                payload: operations::RowsDelete {
                    row_ids: vec!["row-1".to_string(), "row-2".to_string()],
                },
            })
            .await
            .expect("delete rows response");

        let request = captured
            .lock()
            .expect("capture lock")
            .pop()
            .expect("request");
        assert_eq!(request.method.as_str(), "DELETE");
        assert_eq!(request.expected_status, 202);
        assert_eq!(
            serde_json::from_slice::<serde_json::Value>(&request.body.expect("body"))
                .expect("JSON body"),
            json!({"rowIds": ["row-1", "row-2"]})
        );
    }

    #[test]
    fn row_values_serialize_as_api_primitives() {
        let payload = operations::RowsUpsert {
            rows: vec![operations::RowEdit {
                cells: vec![
                    operations::CellEdit {
                        column: "text".to_string(),
                        value: operations::Value::Scalar(operations::ScalarValue::Text(
                            "hello".to_string(),
                        )),
                    },
                    operations::CellEdit {
                        column: "list".to_string(),
                        value: operations::Value::FlatList(vec![
                            operations::ScalarValue::Number(1.5),
                            operations::ScalarValue::Boolean(true),
                        ]),
                    },
                ],
            }],
            key_columns: None,
        };

        assert_eq!(
            serde_json::to_value(payload).expect("serialize rows"),
            json!({
                "rows": [{
                    "cells": [
                        {"column": "text", "value": "hello"},
                        {"column": "list", "value": [1.5, true]}
                    ]
                }]
            })
        );
    }

    #[test]
    fn page_content_serializes_with_its_discriminator() {
        let content = operations::PageCreateContent::Canvas(operations::PageCreateCanvasContent {
            type_: operations::PageType::Canvas,
            canvas_content: operations::PageContent {
                format: operations::PageContentFormat::Html,
                content: "<p>Hello</p>".to_string(),
            },
        });

        assert_eq!(
            serde_json::to_value(content).expect("serialize page content"),
            json!({
                "type": "canvas",
                "canvasContent": {
                    "format": "html",
                    "content": "<p>Hello</p>"
                }
            })
        );
    }
}
