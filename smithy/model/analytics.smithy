$version: "2"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#http
use smithy.api#httpLabel
use smithy.api#httpQuery
use smithy.api#input
use smithy.api#readonly
use smithy.api#required

@documentation("List doc analytics")
@readonly
@http(method: "GET", uri: "/analytics/docs", code: 200)
operation ListDocAnalytics {
    input: ListDocAnalyticsInput
    output: DocAnalyticsCollection
    errors: [
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("List page analytics")
@readonly
@http(method: "GET", uri: "/analytics/docs/{docId}/pages", code: 200)
operation ListPageAnalytics {
    input: ListPageAnalyticsInput
    output: PageAnalyticsCollection
    errors: [
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("Get doc analytics summary")
@readonly
@http(method: "GET", uri: "/analytics/docs/summary", code: 200)
operation ListDocAnalyticsSummary {
    input: ListDocAnalyticsSummaryInput
    output: DocAnalyticsSummary
    errors: [
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("List Pack analytics")
@readonly
@http(method: "GET", uri: "/analytics/packs", code: 200)
operation ListPackAnalytics {
    input: ListPackAnalyticsInput
    output: PackAnalyticsCollection
    errors: [
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("Get Pack analytics summary")
@readonly
@http(method: "GET", uri: "/analytics/packs/summary", code: 200)
operation ListPackAnalyticsSummary {
    input: ListPackAnalyticsSummaryInput
    output: PackAnalyticsSummary
    errors: [
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("List Pack formula analytics")
@readonly
@http(method: "GET", uri: "/analytics/packs/{packId}/formulas", code: 200)
operation ListPackFormulaAnalytics {
    input: ListPackFormulaAnalyticsInput
    output: PackFormulaAnalyticsCollection
    errors: [
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("Get analytics last updated day")
@readonly
@http(method: "GET", uri: "/analytics/updated", code: 200)
operation GetAnalyticsLastUpdated {
    input: GetAnalyticsLastUpdatedInput
    output: AnalyticsLastUpdatedResponse
    errors: [
        TooManyRequestsError
    ]
}

@input
structure GetAnalyticsLastUpdatedInput {}

list ListDocAnalyticsDocIds {
    member: String
}

structure ListDocAnalyticsInput {
    @httpQuery("docIds")
    docIds: ListDocAnalyticsDocIds

    @httpQuery("workspaceId")
    workspaceId: String

    @httpQuery("query")
    query: String

    @httpQuery("isPublished")
    isPublished: Boolean

    @httpQuery("sinceDate")
    sinceDate: String

    @httpQuery("untilDate")
    untilDate: String

    @httpQuery("scale")
    scale: AnalyticsScale

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("orderBy")
    orderBy: DocAnalyticsOrderBy

    @httpQuery("direction")
    direction: SortDirection

    @httpQuery("limit")
    limit: Integer
}

structure ListDocAnalyticsSummaryInput {
    @httpQuery("isPublished")
    isPublished: Boolean

    @httpQuery("sinceDate")
    sinceDate: String

    @httpQuery("untilDate")
    untilDate: String

    @httpQuery("workspaceId")
    workspaceId: String
}

structure ListPackAnalyticsInput {
    @httpQuery("packIds")
    packIds: ListPackAnalyticsPackIds

    @httpQuery("workspaceId")
    workspaceId: String

    @httpQuery("query")
    query: String

    @httpQuery("sinceDate")
    sinceDate: String

    @httpQuery("untilDate")
    untilDate: String

    @httpQuery("scale")
    scale: AnalyticsScale

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("orderBy")
    orderBy: PackAnalyticsOrderBy

    @httpQuery("direction")
    direction: SortDirection

    @httpQuery("isPublished")
    isPublished: Boolean

    @httpQuery("limit")
    limit: Integer
}

list ListPackAnalyticsPackIds {
    member: Integer
}

structure ListPackAnalyticsSummaryInput {
    @httpQuery("packIds")
    packIds: ListPackAnalyticsSummaryPackIds

    @httpQuery("workspaceId")
    workspaceId: String

    @httpQuery("isPublished")
    isPublished: Boolean

    @httpQuery("sinceDate")
    sinceDate: String

    @httpQuery("untilDate")
    untilDate: String
}

list ListPackAnalyticsSummaryPackIds {
    member: Integer
}

structure ListPackFormulaAnalyticsInput {
    @httpQuery("packFormulaNames")
    packFormulaNames: ListPackFormulaAnalyticsPackFormulaNames

    @httpQuery("packFormulaTypes")
    packFormulaTypes: ListPackFormulaAnalyticsPackFormulaTypes

    @httpLabel
    @required
    packId: PackId

    @httpQuery("sinceDate")
    sinceDate: String

    @httpQuery("untilDate")
    untilDate: String

    @httpQuery("scale")
    scale: AnalyticsScale

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("orderBy")
    orderBy: PackFormulaAnalyticsOrderBy

    @httpQuery("direction")
    direction: SortDirection

    @httpQuery("limit")
    limit: Integer
}

list ListPackFormulaAnalyticsPackFormulaNames {
    member: String
}

list ListPackFormulaAnalyticsPackFormulaTypes {
    member: PackFormulaType
}

structure ListPageAnalyticsInput {
    @httpLabel
    @required
    docId: String

    @httpQuery("sinceDate")
    sinceDate: String

    @httpQuery("untilDate")
    untilDate: String

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("limit")
    limit: Integer
}
