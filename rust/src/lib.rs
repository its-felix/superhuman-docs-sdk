pub mod core;
pub mod generated;

pub use core::{
    Client, ClientOptions, Error, Method, Request, Response, Transport, UrlBuilder,
    DEFAULT_BASE_URL,
};
pub use generated::operations;
pub use generated::operations::models;

#[cfg(test)]
mod tests {
    use std::sync::{Arc, Mutex};

    use super::{operations, Client, ClientOptions, Request, Response};
    use serde_json::json;

    #[test]
    fn resource_client_routes_typed_operation_through_transport() {
        let captured = Arc::new(Mutex::new(None::<Request>));
        let capture = Arc::clone(&captured);
        let client = Client::new(ClientOptions::new(move |request: Request| {
            *capture.lock().expect("capture lock") = Some(request);
            Ok(Response {
                status: 202,
                body: b"{}".to_vec(),
            })
        }))
        .expect("client");

        let _deleted = client
            .docs()
            .delete(operations::DeleteDocInput {
                doc_id: "doc 1".to_string(),
            })
            .expect("typed delete response");

        let request = captured
            .lock()
            .expect("capture lock")
            .take()
            .expect("request");
        assert_eq!(request.operation, "DeleteDoc");
        assert_eq!(request.url, "https://coda.io/apis/v1/docs/doc%201");
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
        let content = operations::PageCreateContent::Canvas(
            operations::PageCreateCanvasContent {
                type_: operations::PageType::Canvas,
                canvas_content: operations::PageContent {
                    format: operations::PageContentFormat::Html,
                    content: "<p>Hello</p>".to_string(),
                },
            },
        );

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
