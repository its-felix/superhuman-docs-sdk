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
}
