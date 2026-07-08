$version: "2"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#http
use smithy.api#httpLabel
use smithy.api#httpPayload
use smithy.api#httpQuery
use smithy.api#idempotent
use smithy.api#readonly
use smithy.api#required
use smithy.api#suppress

@documentation("List table rows")
@readonly
@http(method: "GET", uri: "/docs/{docId}/tables/{tableIdOrName}/rows", code: 200)
operation ListRows {
    input: ListRowsInput
    output: RowList
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Insert/upsert rows")
@http(method: "POST", uri: "/docs/{docId}/tables/{tableIdOrName}/rows", code: 202)
operation UpsertRows {
    input: UpsertRowsInput
    output: RowsUpsertResult
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete multiple rows")
@idempotent
@suppress(["HttpMethodSemantics.UnexpectedPayload"])
@http(method: "DELETE", uri: "/docs/{docId}/tables/{tableIdOrName}/rows", code: 202)
operation DeleteRows {
    input: DeleteRowsInput
    output: RowsDeleteResult
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get a row")
@readonly
@http(method: "GET", uri: "/docs/{docId}/tables/{tableIdOrName}/rows/{rowIdOrName}", code: 200)
operation GetRow {
    input: GetRowInput
    output: RowDetail
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Update row")
@idempotent
@http(method: "PUT", uri: "/docs/{docId}/tables/{tableIdOrName}/rows/{rowIdOrName}", code: 202)
operation UpdateRow {
    input: UpdateRowInput
    output: RowUpdateResult
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete row")
@idempotent
@http(method: "DELETE", uri: "/docs/{docId}/tables/{tableIdOrName}/rows/{rowIdOrName}", code: 202)
operation DeleteRow {
    input: DeleteRowInput
    output: RowDeleteResult
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Push a button")
@http(
    method: "POST"
    uri: "/docs/{docId}/tables/{tableIdOrName}/rows/{rowIdOrName}/buttons/{columnIdOrName}"
    code: 202
)
operation PushButton {
    input: PushButtonInput
    output: PushButtonResult
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

structure DeleteRowInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpLabel
    @required
    rowIdOrName: String
}

structure DeleteRowsInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpPayload
    @required
    payload: RowsDelete
}

structure GetRowInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpLabel
    @required
    rowIdOrName: String

    @httpQuery("useColumnNames")
    useColumnNames: Boolean

    @httpQuery("valueFormat")
    valueFormat: ValueFormat
}

structure ListRowsInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpQuery("query")
    query: String

    @httpQuery("sortBy")
    sortBy: RowsSortBy

    @httpQuery("useColumnNames")
    useColumnNames: Boolean

    @httpQuery("valueFormat")
    valueFormat: ValueFormat

    @httpQuery("visibleOnly")
    visibleOnly: Boolean

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("syncToken")
    syncToken: String
}

structure PushButtonInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpLabel
    @required
    rowIdOrName: String

    @httpLabel
    @required
    columnIdOrName: String
}

structure UpdateRowInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpLabel
    @required
    rowIdOrName: String

    @httpQuery("disableParsing")
    disableParsing: Boolean

    @httpPayload
    @required
    payload: RowUpdate
}

structure UpsertRowsInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpQuery("disableParsing")
    disableParsing: Boolean

    @httpPayload
    @required
    payload: RowsUpsert
}
