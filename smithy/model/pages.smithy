$version: "2"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#enumValue
use smithy.api#http
use smithy.api#httpLabel
use smithy.api#httpPayload
use smithy.api#httpQuery
use smithy.api#idempotent
use smithy.api#readonly
use smithy.api#required
use smithy.api#suppress

@documentation("List pages")
@readonly
@http(method: "GET", uri: "/docs/{docId}/pages", code: 200)
operation ListPages {
    input: ListPagesInput
    output: PageList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Create a page")
@http(method: "POST", uri: "/docs/{docId}/pages", code: 202)
operation CreatePage {
    input: CreatePageInput
    output: PageCreateResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get a page")
@readonly
@http(method: "GET", uri: "/docs/{docId}/pages/{pageIdOrName}", code: 200)
operation GetPage {
    input: GetPageInput
    output: Page
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        GoneError
        TooManyRequestsError
    ]
}

@documentation("Update a page")
@idempotent
@http(method: "PUT", uri: "/docs/{docId}/pages/{pageIdOrName}", code: 202)
operation UpdatePage {
    input: UpdatePageInput
    output: PageUpdateResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete a page")
@idempotent
@http(method: "DELETE", uri: "/docs/{docId}/pages/{pageIdOrName}", code: 202)
operation DeletePage {
    input: DeletePageInput
    output: PageDeleteResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List page content")
@readonly
@http(method: "GET", uri: "/docs/{docId}/pages/{pageIdOrName}/content", code: 200)
operation ListPageContent {
    input: ListPageContentInput
    output: PageContentList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        GoneError
        TooManyRequestsError
    ]
}

@documentation("Delete page content")
@idempotent
@suppress(["HttpMethodSemantics.UnexpectedPayload"])
@http(method: "DELETE", uri: "/docs/{docId}/pages/{pageIdOrName}/content", code: 202)
operation DeletePageContent {
    input: DeletePageContentInput
    output: PageContentDeleteResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Begin content export")
@http(method: "POST", uri: "/docs/{docId}/pages/{pageIdOrName}/export", code: 202)
operation BeginPageContentExport {
    input: BeginPageContentExportInput
    output: BeginPageContentExportResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        GoneError
        TooManyRequestsError
    ]
}

@documentation("Content export status")
@readonly
@http(method: "GET", uri: "/docs/{docId}/pages/{pageIdOrName}/export/{requestId}", code: 200)
operation GetPageContentExportStatus {
    input: GetPageContentExportStatusInput
    output: PageContentExportStatusResponse
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        GoneError
        TooManyRequestsError
    ]
}

structure BeginPageContentExportInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    pageIdOrName: String

    @httpPayload
    @required
    payload: BeginPageContentExportPayload
}

structure CreatePageInput {
    @httpLabel
    @required
    docId: String

    @httpPayload
    @required
    payload: PageCreate
}

structure DeletePageContentInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    pageIdOrName: String

    @httpPayload
    payload: PageContentDelete
}

structure DeletePageInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    pageIdOrName: String
}

structure GetPageContentExportStatusInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    pageIdOrName: String

    @httpLabel
    @required
    requestId: String
}

structure GetPageInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    pageIdOrName: String
}

enum ListPageContentContentFormat {
    @enumValue("plainText")
    PLAIN_TEXT
}

structure ListPageContentInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    pageIdOrName: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("contentFormat")
    contentFormat: ListPageContentContentFormat
}

structure ListPagesInput {
    @httpLabel
    @required
    docId: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String
}

structure UpdatePageInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    pageIdOrName: String

    @httpPayload
    @required
    payload: PageUpdate
}
