$version: "2"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#http
use smithy.api#httpLabel
use smithy.api#httpQuery
use smithy.api#readonly
use smithy.api#required

@documentation("List tables")
@readonly
@http(method: "GET", uri: "/docs/{docId}/tables", code: 200)
operation ListTables {
    input: ListTablesInput
    output: TableList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get a table")
@readonly
@http(method: "GET", uri: "/docs/{docId}/tables/{tableIdOrName}", code: 200)
operation GetTable {
    input: GetTableInput
    output: Table
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List columns")
@readonly
@http(method: "GET", uri: "/docs/{docId}/tables/{tableIdOrName}/columns", code: 200)
operation ListColumns {
    input: ListColumnsInput
    output: ColumnList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get a column")
@readonly
@http(method: "GET", uri: "/docs/{docId}/tables/{tableIdOrName}/columns/{columnIdOrName}", code: 200)
operation GetColumn {
    input: GetColumnInput
    output: ColumnDetail
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List formulas")
@readonly
@http(method: "GET", uri: "/docs/{docId}/formulas", code: 200)
operation ListFormulas {
    input: ListFormulasInput
    output: FormulaList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get a formula")
@readonly
@http(method: "GET", uri: "/docs/{docId}/formulas/{formulaIdOrName}", code: 200)
operation GetFormula {
    input: GetFormulaInput
    output: Formula
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List controls")
@readonly
@http(method: "GET", uri: "/docs/{docId}/controls", code: 200)
operation ListControls {
    input: ListControlsInput
    output: ControlList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get a control")
@readonly
@http(method: "GET", uri: "/docs/{docId}/controls/{controlIdOrName}", code: 200)
operation GetControl {
    input: GetControlInput
    output: Control
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

structure GetColumnInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpLabel
    @required
    columnIdOrName: String
}

structure GetControlInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    controlIdOrName: String
}

structure GetFormulaInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    formulaIdOrName: String
}

structure GetTableInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpQuery("useUpdatedTableLayouts")
    useUpdatedTableLayouts: Boolean
}

structure ListColumnsInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    tableIdOrName: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("visibleOnly")
    visibleOnly: Boolean
}

structure ListControlsInput {
    @httpLabel
    @required
    docId: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("sortBy")
    sortBy: SortBy
}

structure ListFormulasInput {
    @httpLabel
    @required
    docId: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("sortBy")
    sortBy: SortBy
}

structure ListTablesInput {
    @httpLabel
    @required
    docId: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("sortBy")
    sortBy: SortBy

    @httpQuery("tableTypes")
    tableTypes: ListTablesTableTypes
}

list ListTablesTableTypes {
    member: TableType
}
