use std::fmt;

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
    pub body: Option<String>,
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
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Error::EmptyBaseUrl => f.write_str("base URL must not be empty"),
        }
    }
}

impl std::error::Error for Error {}

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
