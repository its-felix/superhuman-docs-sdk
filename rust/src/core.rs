use std::fmt;
use std::sync::Arc;

use serde::de::DeserializeOwned;

pub const DEFAULT_BASE_URL: &str = "https://coda.io/apis/v1";

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Method {
    Delete,
    Get,
    Head,
    Patch,
    Post,
    Put,
}

impl Method {
    pub fn as_str(self) -> &'static str {
        match self {
            Method::Delete => "DELETE",
            Method::Get => "GET",
            Method::Head => "HEAD",
            Method::Patch => "PATCH",
            Method::Post => "POST",
            Method::Put => "PUT",
        }
    }
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct Request {
    pub operation: &'static str,
    pub method: Method,
    pub url: String,
    pub body: Option<Vec<u8>>,
    pub expected_status: u16,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct Response {
    pub status: u16,
    pub body: Vec<u8>,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub enum Error {
    EmptyBaseUrl,
    MissingTransport,
    Transport(String),
    Serialize(String),
    Deserialize {
        operation: &'static str,
        message: String,
    },
    UnexpectedStatus {
        operation: &'static str,
        expected: u16,
        actual: u16,
        body: String,
    },
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Error::EmptyBaseUrl => f.write_str("base URL must not be empty"),
            Error::MissingTransport => f.write_str(
                "no HTTP transport configured; construct ClientOptions with a Transport implementation",
            ),
            Error::Transport(message) => write!(f, "transport error: {message}"),
            Error::Serialize(message) => write!(f, "failed to serialize request body: {message}"),
            Error::Deserialize { operation, message } => {
                write!(f, "failed to deserialize {operation} response: {message}")
            }
            Error::UnexpectedStatus {
                operation,
                expected,
                actual,
                body,
            } => write!(
                f,
                "{operation} returned HTTP {actual}, expected {expected}: {body}"
            ),
        }
    }
}

impl std::error::Error for Error {}

impl Error {
    pub fn transport(error: impl fmt::Display) -> Self {
        Self::Transport(error.to_string())
    }

    pub(crate) fn serialize(error: impl fmt::Display) -> Self {
        Self::Serialize(error.to_string())
    }
}

/// Sends a fully encoded SDK request and returns the raw HTTP response.
///
/// Authentication, connection pooling, retries, and timeout policy intentionally
/// live in the transport so applications can use their preferred HTTP stack.
pub trait Transport: Send + Sync {
    fn send_request(&self, request: Request) -> Result<Response, Error>;
}

impl<F> Transport for F
where
    F: Fn(Request) -> Result<Response, Error> + Send + Sync,
{
    fn send_request(&self, request: Request) -> Result<Response, Error> {
        self(request)
    }
}

#[derive(Default)]
struct MissingTransport;

impl Transport for MissingTransport {
    fn send_request(&self, _request: Request) -> Result<Response, Error> {
        Err(Error::MissingTransport)
    }
}

#[derive(Clone)]
pub struct ClientOptions {
    pub base_url: String,
    transport: Arc<dyn Transport>,
}

impl ClientOptions {
    pub fn new(transport: impl Transport + 'static) -> Self {
        Self {
            base_url: DEFAULT_BASE_URL.to_string(),
            transport: Arc::new(transport),
        }
    }

    pub fn with_base_url(mut self, base_url: impl Into<String>) -> Self {
        self.base_url = base_url.into();
        self
    }

    pub fn with_transport(mut self, transport: impl Transport + 'static) -> Self {
        self.transport = Arc::new(transport);
        self
    }

    pub fn with_shared_transport(mut self, transport: Arc<dyn Transport>) -> Self {
        self.transport = transport;
        self
    }
}

impl Default for ClientOptions {
    fn default() -> Self {
        Self {
            base_url: DEFAULT_BASE_URL.to_string(),
            transport: Arc::new(MissingTransport),
        }
    }
}

#[derive(Clone)]
pub struct Client {
    base_url: String,
    transport: Arc<dyn Transport>,
}

impl Client {
    pub fn new(options: ClientOptions) -> Result<Self, Error> {
        let base_url = UrlBuilder::new(&options.base_url)?.finish();
        Ok(Self {
            base_url,
            transport: options.transport,
        })
    }

    pub fn with_transport(transport: impl Transport + 'static) -> Self {
        Self::new(ClientOptions::new(transport)).expect("the default base URL is valid")
    }

    pub fn base_url(&self) -> &str {
        &self.base_url
    }

    /// The single dispatch seam used by every generated operation method.
    pub fn send_request(&self, request: Request) -> Result<Response, Error> {
        self.transport.send_request(request)
    }

    pub(crate) fn execute<T: DeserializeOwned>(&self, request: Request) -> Result<T, Error> {
        let (operation, body) = self.receive(request)?;
        let body: &[u8] = if body.is_empty() { b"{}" } else { &body };
        serde_json::from_slice(body).map_err(|error| Error::Deserialize {
            operation,
            message: error.to_string(),
        })
    }

    pub(crate) fn execute_optional<T: DeserializeOwned>(
        &self,
        request: Request,
    ) -> Result<Option<T>, Error> {
        let (operation, body) = self.receive(request)?;
        if body.is_empty() {
            return Ok(None);
        }
        serde_json::from_slice(&body)
            .map(Some)
            .map_err(|error| Error::Deserialize {
                operation,
                message: error.to_string(),
            })
    }

    fn receive(&self, request: Request) -> Result<(&'static str, Vec<u8>), Error> {
        let operation = request.operation;
        let expected = request.expected_status;
        let response = self.send_request(request)?;
        if response.status != expected {
            return Err(Error::UnexpectedStatus {
                operation,
                expected,
                actual: response.status,
                body: String::from_utf8_lossy(&response.body).into_owned(),
            });
        }
        Ok((operation, response.body))
    }
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct UrlBuilder {
    value: String,
    wrote_query: bool,
}

impl UrlBuilder {
    pub fn new(base_url: &str) -> Result<Self, Error> {
        let trimmed = base_url.trim_end_matches('/');
        if trimmed.is_empty() {
            return Err(Error::EmptyBaseUrl);
        }
        Ok(Self {
            value: trimmed.to_string(),
            wrote_query: false,
        })
    }

    pub fn finish(self) -> String {
        self.value
    }

    pub fn path_literal(&mut self, value: &str) {
        self.value.push_str(value);
    }

    pub fn path_string(&mut self, value: &str) {
        percent_encode_into(&mut self.value, value);
    }

    pub fn path_i64(&mut self, value: i64) {
        self.value.push_str(&value.to_string());
    }

    pub fn path_f64(&mut self, value: f64) {
        self.value.push_str(&value.to_string());
    }

    pub fn path_bool(&mut self, value: bool) {
        self.value.push_str(if value { "true" } else { "false" });
    }

    pub fn query_string(&mut self, name: &str, value: &str) {
        self.query_start(name);
        percent_encode_into(&mut self.value, value);
    }

    pub fn query_i64(&mut self, name: &str, value: i64) {
        self.query_string(name, &value.to_string());
    }

    pub fn query_f64(&mut self, name: &str, value: f64) {
        self.query_string(name, &value.to_string());
    }

    pub fn query_bool(&mut self, name: &str, value: bool) {
        self.query_string(name, if value { "true" } else { "false" });
    }

    fn query_start(&mut self, name: &str) {
        self.value.push(if self.wrote_query { '&' } else { '?' });
        self.wrote_query = true;
        percent_encode_into(&mut self.value, name);
        self.value.push('=');
    }
}

fn percent_encode_into(out: &mut String, value: &str) {
    const HEX: &[u8; 16] = b"0123456789ABCDEF";
    for byte in value.bytes() {
        match byte {
            b'A'..=b'Z' | b'a'..=b'z' | b'0'..=b'9' | b'-' | b'.' | b'_' | b'~' => {
                out.push(byte as char);
            }
            _ => {
                out.push('%');
                out.push(HEX[(byte >> 4) as usize] as char);
                out.push(HEX[(byte & 0x0f) as usize] as char);
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::UrlBuilder;

    #[test]
    fn url_builder_percent_encodes_path_labels_and_query_values() {
        let mut url = UrlBuilder::new("https://example.test/").expect("url");
        url.path_literal("/docs/");
        url.path_string("doc 1/2");
        url.query_string("q", "a+b c");
        url.query_bool("visibleOnly", true);

        assert_eq!(
            url.finish(),
            "https://example.test/docs/doc%201%2F2?q=a%2Bb%20c&visibleOnly=true"
        );
    }
}
