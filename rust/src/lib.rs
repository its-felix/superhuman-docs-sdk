pub mod core;
pub mod generated;

pub use core::{Error, Method, Request, Response, UrlBuilder, DEFAULT_BASE_URL};
pub use generated::operations;

#[cfg(test)]
mod tests {
    use super::{operations, Method, DEFAULT_BASE_URL};

    #[test]
    fn generated_builder_exposes_smithy_operation_request() {
        let request = operations::build_get_doc(
            DEFAULT_BASE_URL,
            operations::GetDocInput {
                doc_id: "doc 1".to_string(),
            },
        )
        .expect("request");

        assert_eq!(request.method, Method::Get);
        assert_eq!(request.expected_status, 200);
        assert_eq!(request.operation, "GetDoc");
        assert_eq!(request.url, "https://coda.io/apis/v1/docs/doc%201");
    }
}
