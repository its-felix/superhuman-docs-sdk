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

@documentation("List Packs")
@readonly
@http(method: "GET", uri: "/packs", code: 200)
operation ListPacks {
    input: ListPacksInput
    output: PackSummaryList
    errors: [
        BadRequestError
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("Create Pack")
@http(method: "POST", uri: "/packs", code: 200)
operation CreatePack {
    input: CreatePackInput
    output: CreatePackResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        TooManyRequestsError
    ]
}

@documentation("Get a single Pack")
@readonly
@http(method: "GET", uri: "/packs/{packId}", code: 200)
operation GetPack {
    input: GetPackInput
    output: Pack
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Update Pack")
@http(method: "PATCH", uri: "/packs/{packId}", code: 200)
operation UpdatePack {
    input: UpdatePackInput
    output: Pack
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete Pack")
@idempotent
@http(method: "DELETE", uri: "/packs/{packId}", code: 200)
operation DeletePack {
    input: DeletePackInput
    output: DeletePackResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Gets the JSON Schema for Pack configuration.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/configurations/schema", code: 200)
operation GetPackConfigurationSchema {
    input: GetPackConfigurationSchemaInput
    output: GetPackConfigurationJsonSchemaResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List the versions for a Pack.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/versions", code: 200)
operation ListPackVersions {
    input: ListPackVersionsInput
    output: PackVersionList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get the next valid version for a Pack.")
@http(method: "POST", uri: "/packs/{packId}/nextVersion", code: 200)
operation GetNextPackVersion {
    input: GetNextPackVersionInput
    output: NextPackVersionInfo
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get the difference between two pack versions.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/versions/{basePackVersion}/diff/{targetPackVersion}", code: 200)
operation GetPackVersionDiffs {
    input: GetPackVersionDiffsInput
    output: PackVersionDiffs
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Register Pack version")
@http(method: "POST", uri: "/packs/{packId}/versions/{packVersion}/register", code: 200)
operation RegisterPackVersion {
    input: RegisterPackVersionInput
    output: PackVersionUploadInfo
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Pack version upload complete")
@http(method: "POST", uri: "/packs/{packId}/versions/{packVersion}/uploadComplete", code: 200)
operation PackVersionUploadComplete {
    input: PackVersionUploadCompleteInput
    output: CreatePackVersionResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Create a new Pack release.")
@http(method: "POST", uri: "/packs/{packId}/releases", code: 200)
operation CreatePackRelease {
    input: CreatePackReleaseInput
    output: PackRelease
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List the releases for a Pack.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/releases", code: 200)
operation ListPackReleases {
    input: ListPackReleasesInput
    output: PackReleaseList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Update an existing Pack release.")
@idempotent
@http(method: "PUT", uri: "/packs/{packId}/releases/{packReleaseId}", code: 200)
operation UpdatePackRelease {
    input: UpdatePackReleaseInput
    output: PackRelease
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List pack reviews")
@readonly
@http(method: "GET", uri: "/packs/{packId}/reviews", code: 200)
operation ListPackReviews {
    input: ListPackReviewsInput
    output: ListPackReviewsResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Create pack review")
@http(method: "POST", uri: "/packs/{packId}/reviews", code: 200)
operation CreatePackReview {
    input: CreatePackReviewInput
    output: CreatePackReviewResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Cancel pending pack review")
@http(method: "POST", uri: "/packs/{packId}/reviews/pending/cancel", code: 200)
operation CancelPackReview {
    input: CancelPackReviewInput
    output: CancelPackReviewResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get Pack listing draft")
@readonly
@http(method: "GET", uri: "/packs/{packId}/listingDraft", code: 200)
operation GetPackListingDraft {
    input: GetPackListingDraftInput
    output: GetPackListingDraftResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Upsert Pack listing draft")
@idempotent
@http(method: "PUT", uri: "/packs/{packId}/listingDraft", code: 200)
operation UpsertPackListingDraft {
    input: UpsertPackListingDraftInput
    output: UpsertPackListingDraftResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete Pack listing draft")
@idempotent
@http(method: "DELETE", uri: "/packs/{packId}/listingDraft", code: 200)
operation DeletePackListingDraft {
    input: DeletePackListingDraftInput
    output: DeletePackListingDraftResponse
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Set the OAuth configurations of the Pack.")
@idempotent
@http(method: "PUT", uri: "/packs/{packId}/oauthConfig", code: 200)
operation SetPackOauthConfig {
    input: SetPackOauthConfigInput
    output: PackOauthConfigMetadata
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the OAuth configuration of the Pack.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/oauthConfig", code: 200)
operation GetPackOauthConfig {
    input: GetPackOauthConfigInput
    output: PackOauthConfigMetadata
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Set the system connection credentials of the Pack.")
@idempotent
@http(method: "PUT", uri: "/packs/{packId}/systemConnection", code: 200)
operation SetPackSystemConnection {
    input: SetPackSystemConnectionInput
    output: SetPackSystemConnectionOutput
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Patch the system connection credentials of the Pack.")
@http(method: "PATCH", uri: "/packs/{packId}/systemConnection", code: 200)
operation PatchPackSystemConnection {
    input: PatchPackSystemConnectionInput
    output: PatchPackSystemConnectionOutput
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the system connection metadata of the Pack.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/systemConnection", code: 200)
operation GetPackSystemConnection {
    input: GetPackSystemConnectionInput
    output: GetPackSystemConnectionOutput
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List permissions for a Pack")
@readonly
@http(method: "GET", uri: "/packs/{packId}/permissions", code: 200)
operation GetPackPermissions {
    input: GetPackPermissionsInput
    output: PackPermissionList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Add a permission for Pack")
@http(method: "POST", uri: "/packs/{packId}/permissions", code: 200)
operation AddPackPermission {
    input: AddPackPermissionInput
    output: AddPackPermissionResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete a user's own permissions for Pack")
@idempotent
@http(method: "DELETE", uri: "/packs/{packId}/permissions", code: 200)
operation DeleteUserPackPermission {
    input: DeleteUserPackPermissionInput
    output: DeleteUserPackPermissionsResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete a permission for Pack")
@idempotent
@http(method: "DELETE", uri: "/packs/{packId}/permissions/{permissionId}", code: 200)
operation DeletePackPermission {
    input: DeletePackPermissionInput
    output: DeletePackPermissionResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List pending Pack invitations for the current user")
@readonly
@http(method: "GET", uri: "/packs/invitations", code: 200)
operation ListUserPackInvitations {
    input: ListUserPackInvitationsInput
    output: PackInvitationWithPackList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("List invitations for a Pack")
@readonly
@http(method: "GET", uri: "/packs/{packId}/invitations", code: 200)
operation ListPackInvitations {
    input: ListPackInvitationsInput
    output: PackInvitationList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Create an invitation for Pack")
@http(method: "POST", uri: "/packs/{packId}/invitations", code: 200)
operation CreatePackInvitation {
    input: CreatePackInvitationInput
    output: CreatePackInvitationResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Update an invitation for Pack")
@idempotent
@http(method: "PUT", uri: "/packs/{packId}/invitations/{invitationId}", code: 200)
operation UpdatePackInvitation {
    input: UpdatePackInvitationInput
    output: UpdatePackInvitationResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Revoke an invitation for Pack")
@idempotent
@http(method: "DELETE", uri: "/packs/{packId}/invitations/{invitationId}", code: 200)
operation DeletePackInvitation {
    input: DeletePackInvitationInput
    output: DeletePackInvitationResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Reply to a Pack invitation")
@http(method: "POST", uri: "/packs/invitations/{invitationId}/reply", code: 200)
operation ReplyToPackInvitation {
    input: ReplyToPackInvitationInput
    output: HandlePackInvitationResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List makers for Pack")
@readonly
@http(method: "GET", uri: "/packs/{packId}/makers", code: 200)
operation ListPackMakers {
    input: ListPackMakersInput
    output: ListPackMakersResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Add a maker for Pack")
@http(method: "POST", uri: "/packs/{packId}/maker", code: 200)
operation AddPackMaker {
    input: AddPackMakerInput
    output: AddPackMakerResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete a maker for Pack")
@idempotent
@http(method: "DELETE", uri: "/packs/{packId}/maker/{loginId}", code: 200)
operation DeletePackMaker {
    input: DeletePackMakerInput
    output: AddPackMakerResponse2
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List categories for Pack")
@readonly
@http(method: "GET", uri: "/packs/{packId}/categories", code: 200)
operation ListPackCategories {
    input: ListPackCategoriesInput
    output: ListPackCategoriesResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Add a category for Pack")
@http(method: "POST", uri: "/packs/{packId}/category", code: 200)
operation AddPackCategory {
    input: AddPackCategoryInput
    output: AddPackCategoryResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete a category for Pack")
@idempotent
@http(method: "DELETE", uri: "/packs/{packId}/category/{categoryName}", code: 200)
operation DeletePackCategory {
    input: DeletePackCategoryInput
    output: DeletePackCategoryResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Upload a Pack asset.")
@http(method: "POST", uri: "/packs/{packId}/uploadAsset", code: 200)
operation UploadPackAsset {
    input: UploadPackAssetInput
    output: PackAssetUploadInfo
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Upload Pack source code.")
@http(method: "POST", uri: "/packs/{packId}/uploadSourceCode", code: 200)
operation UploadPackSourceCode {
    input: UploadPackSourceCodeInput
    output: PackSourceCodeUploadInfo
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Pack asset upload complete")
@http(method: "POST", uri: "/packs/{packId}/assets/{packAssetId}/assetType/{packAssetType}/uploadComplete", code: 200)
operation PackAssetUploadComplete {
    input: PackAssetUploadCompleteInput
    output: PackAssetUploadCompleteResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Pack source code upload complete")
@http(method: "POST", uri: "/packs/{packId}/versions/{packVersion}/sourceCode/uploadComplete", code: 200)
operation PackSourceCodeUploadComplete {
    input: PackSourceCodeUploadCompleteInput
    output: PackSourceCodeUploadCompleteResponse
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("get the source code for a Pack version.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/versions/{packVersion}/sourceCode", code: 200)
operation GetPackSourceCode {
    input: GetPackSourceCodeInput
    output: PackSourceCodeInfo
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List the Pack listings accessible to a user.")
@readonly
@http(method: "GET", uri: "/packs/listings", code: 200)
operation ListPackListings {
    input: ListPackListingsInput
    output: PackListingList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get detailed listing information for a Pack.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/listing", code: 200)
operation GetPackListing {
    input: GetPackListingInput
    output: PackListingDetail
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the logs of a Pack.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/docs/{docId}/logs", code: 200)
operation ListPackLogs {
    input: ListPackLogsInput
    output: PackLogsList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the logs of a Ingestion.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/tenantId/{tenantId}/rootIngestionId/{rootIngestionId}/logs", code: 200)
operation ListIngestionLogs {
    input: ListIngestionLogsInput
    output: PackLogsList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the grouped logs of a Pack.")
@readonly
@http(method: "GET", uri: "/packs/{packId}/docs/{docId}/groupedLogs", code: 200)
operation ListGroupedPackLogs {
    input: ListGroupedPackLogsInput
    output: GroupedPackLogsList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the grouped logs of a Pack for a specific ingestionExecutionId.")
@readonly
@http(
    method: "GET"
    uri: "/packs/{packId}/tenantId/{tenantId}/rootIngestionId/{rootIngestionId}/groupedLogs"
    code: 200
)
operation ListGroupedIngestionLogs {
    input: ListGroupedIngestionLogsInput
    output: GroupedPackLogsList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve a list of ingestion batch executions for the given root ingestion id.")
@readonly
@http(
    method: "GET"
    uri: "/packs/{packId}/tenantId/{tenantId}/rootIngestionId/{rootIngestionId}/ingestionBatchExecutions"
    code: 200
)
operation ListIngestionBatchExecutions {
    input: ListIngestionBatchExecutionsInput
    output: IngestionBatchExecutionsList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve a list of parent items for the given ingestion batch execution id.")
@readonly
@http(
    method: "GET"
    uri: "/packs/{packId}/tenantId/{tenantId}/rootIngestionId/{rootIngestionId}/ingestionBatchExecutions/{ingestionExecutionId}/parentItems"
    code: 200
)
operation ListIngestionParentItems {
    input: ListIngestionParentItemsInput
    output: IngestionParentItemsList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the information for a specific log.")
@readonly
@http(
    method: "GET"
    uri: "/packs/{packId}/tenantId/{tenantId}/rootIngestionId/{rootIngestionId}/logs/{logId}"
    code: 200
)
operation GetPackLogDetails {
    input: GetPackLogDetailsInput
    output: GetPackLogDetailsOutput
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List featured docs for a Pack")
@readonly
@http(method: "GET", uri: "/packs/{packId}/featuredDocs", code: 200)
operation ListPackFeaturedDocs {
    input: ListPackFeaturedDocsInput
    output: PackFeaturedDocsResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Update featured docs for a Pack")
@idempotent
@http(method: "PUT", uri: "/packs/{packId}/featuredDocs", code: 200)
operation UpdatePackFeaturedDocs {
    input: UpdatePackFeaturedDocsInput
    output: UpdatePackFeaturedDocsResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the chat sessions of an agent instance.")
@readonly
@http(method: "GET", uri: "/go/tenants/{tenantId}/agentInstances/{agentInstanceId}/agentSessionIds", code: 200)
operation ListAgentSessionIds {
    input: ListAgentSessionIdsInput
    output: PackLogsList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the logs of an agent instance.")
@readonly
@http(method: "GET", uri: "/go/tenants/{tenantId}/agentInstances/{agentInstanceId}/logs", code: 200)
operation ListAgentLogs {
    input: ListAgentLogsInput
    output: PackLogsList
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Retrieve the information for a specific log.")
@readonly
@http(method: "GET", uri: "/go/tenants/{tenantId}/agentInstances/{agentInstanceId}/logs/{logId}", code: 200)
operation GetAgentPackLogDetails {
    input: GetAgentPackLogDetailsInput
    output: GetAgentPackLogDetailsOutput
    errors: [
        BadRequestWithValidationErrors
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

structure AddPackCategoryInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: AddPackCategoryPayload
}

structure AddPackMakerInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: AddPackMakerPayload
}

structure AddPackPermissionInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: AddPackPermissionPayload
}

structure CancelPackReviewInput {
    @httpLabel
    @required
    packId: Integer
}

structure CreatePackInput {
    @httpPayload
    @required
    payload: CreatePackPayload
}

structure CreatePackInvitationInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: CreatePackInvitationPayload
}

structure CreatePackReleaseInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: CreatePackReleasePayload
}

structure CreatePackReviewInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: CreatePackReviewPayload
}

structure DeletePackCategoryInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    categoryName: String
}

structure DeletePackInput {
    @httpLabel
    @required
    packId: Integer
}

structure DeletePackInvitationInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    invitationId: String
}

structure DeletePackListingDraftInput {
    @httpLabel
    @required
    packId: Integer
}

structure DeletePackMakerInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    loginId: String
}

structure DeletePackPermissionInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    permissionId: String
}

structure DeleteUserPackPermissionInput {
    @httpLabel
    @required
    packId: Integer
}

structure GetAgentPackLogDetailsInput {
    @httpLabel
    @required
    tenantId: String

    @httpLabel
    @required
    agentInstanceId: String

    @httpLabel
    @required
    logId: String

    @httpQuery("detailsKey")
    @required
    detailsKey: String
}

structure GetAgentPackLogDetailsOutput {
    @httpPayload
    body: PackLogDetails
}

structure GetNextPackVersionInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    payload: GetNextPackVersionPayload
}

structure GetPackConfigurationSchemaInput {
    @httpLabel
    @required
    packId: Integer
}

structure GetPackInput {
    @httpLabel
    @required
    packId: Integer
}

structure GetPackListingDraftInput {
    @httpLabel
    @required
    packId: Integer
}

structure GetPackListingInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("workspaceId")
    workspaceId: String

    @httpQuery("docId")
    docId: String

    @httpQuery("ingestionId")
    ingestionId: String

    @httpQuery("installContext")
    installContext: PackListingInstallContextType

    @httpQuery("releaseChannel")
    releaseChannel: IngestionPackReleaseChannel
}

structure GetPackLogDetailsInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    tenantId: String

    @httpLabel
    @required
    rootIngestionId: String

    @httpLabel
    @required
    logId: String

    @httpQuery("detailsKey")
    @required
    detailsKey: String
}

structure GetPackLogDetailsOutput {
    @httpPayload
    body: PackLogDetails
}

structure GetPackOauthConfigInput {
    @httpLabel
    @required
    packId: Integer
}

structure GetPackPermissionsInput {
    @httpLabel
    @required
    packId: Integer
}

structure GetPackSourceCodeInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    packVersion: String
}

structure GetPackSystemConnectionInput {
    @httpLabel
    @required
    packId: Integer
}

structure GetPackSystemConnectionOutput {
    @httpPayload
    body: PackSystemConnectionMetadata
}

structure GetPackVersionDiffsInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    basePackVersion: String

    @httpLabel
    @required
    targetPackVersion: String
}

structure ListAgentLogsInput {
    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpLabel
    @required
    tenantId: String

    @httpLabel
    @required
    agentInstanceId: String

    @httpQuery("logTypes")
    logTypes: ListAgentLogsLogTypes

    @httpQuery("agentSessionId")
    agentSessionId: String

    @httpQuery("beforeTimestamp")
    beforeTimestamp: String

    @httpQuery("afterTimestamp")
    afterTimestamp: String

    @httpQuery("order")
    order: ListAgentLogsOrder

    @httpQuery("q")
    q: String

    @httpQuery("requestIds")
    requestIds: ListAgentLogsRequestIds
}

list ListAgentLogsLogTypes {
    member: PackLogType
}

enum ListAgentLogsOrder {
    @enumValue("asc")
    ASC

    @enumValue("desc")
    DESC
}

list ListAgentLogsRequestIds {
    member: String
}

structure ListAgentSessionIdsInput {
    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpLabel
    @required
    tenantId: String

    @httpLabel
    @required
    agentInstanceId: String

    @httpQuery("agentSessionId")
    agentSessionId: String

    @httpQuery("logTypes")
    logTypes: ListAgentSessionIdsLogTypes

    @httpQuery("beforeTimestamp")
    beforeTimestamp: String

    @httpQuery("afterTimestamp")
    afterTimestamp: String

    @httpQuery("order")
    order: ListAgentSessionIdsOrder

    @httpQuery("q")
    q: String

    @httpQuery("requestIds")
    requestIds: ListAgentSessionIdsRequestIds
}

list ListAgentSessionIdsLogTypes {
    member: PackLogType
}

enum ListAgentSessionIdsOrder {
    @enumValue("asc")
    ASC

    @enumValue("desc")
    DESC
}

list ListAgentSessionIdsRequestIds {
    member: String
}

structure ListGroupedIngestionLogsInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpLabel
    @required
    tenantId: String

    @httpLabel
    @required
    rootIngestionId: String

    @httpQuery("ingestionExecutionId")
    ingestionExecutionId: String

    @httpQuery("beforeTimestamp")
    beforeTimestamp: String

    @httpQuery("afterTimestamp")
    afterTimestamp: String

    @httpQuery("order")
    order: ListGroupedIngestionLogsOrder

    @httpQuery("q")
    q: String
}

enum ListGroupedIngestionLogsOrder {
    @enumValue("asc")
    ASC

    @enumValue("desc")
    DESC
}

structure ListGroupedPackLogsInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpLabel
    @required
    docId: String

    @httpQuery("beforeTimestamp")
    beforeTimestamp: String

    @httpQuery("afterTimestamp")
    afterTimestamp: String

    @httpQuery("order")
    order: ListGroupedPackLogsOrder

    @httpQuery("q")
    q: String
}

enum ListGroupedPackLogsOrder {
    @enumValue("asc")
    ASC

    @enumValue("desc")
    DESC
}

structure ListIngestionBatchExecutionsInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    tenantId: String

    @httpLabel
    @required
    rootIngestionId: String

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("datasource")
    datasource: String

    @httpQuery("executionType")
    executionType: IngestionExecutionType

    @httpQuery("includeDeletedIngestions")
    includeDeletedIngestions: Boolean

    @httpQuery("ingestionExecutionId")
    ingestionExecutionId: String

    @httpQuery("ingestionId")
    ingestionId: String

    @httpQuery("ingestionStatus")
    ingestionStatus: IngestionStatus
}

structure ListIngestionLogsInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpLabel
    @required
    tenantId: String

    @httpLabel
    @required
    rootIngestionId: String

    @httpQuery("logTypes")
    logTypes: ListIngestionLogsLogTypes

    @httpQuery("ingestionExecutionId")
    ingestionExecutionId: String

    @httpQuery("beforeTimestamp")
    beforeTimestamp: String

    @httpQuery("afterTimestamp")
    afterTimestamp: String

    @httpQuery("ingestionStatus")
    ingestionStatus: IngestionStatus

    @httpQuery("onlyExecutionCompletions")
    onlyExecutionCompletions: Boolean

    @httpQuery("order")
    order: ListIngestionLogsOrder

    @httpQuery("q")
    q: String

    @httpQuery("requestIds")
    requestIds: ListIngestionLogsRequestIds
}

list ListIngestionLogsLogTypes {
    member: PackLogType
}

enum ListIngestionLogsOrder {
    @enumValue("asc")
    ASC

    @enumValue("desc")
    DESC
}

list ListIngestionLogsRequestIds {
    member: String
}

structure ListIngestionParentItemsInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    tenantId: String

    @httpLabel
    @required
    rootIngestionId: String

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("limit")
    limit: Integer

    @httpLabel
    @required
    ingestionExecutionId: String

    @httpQuery("ingestionId")
    @required
    ingestionId: String

    @httpQuery("ingestionStatus")
    ingestionStatus: IngestionStatus
}

structure ListPackCategoriesInput {
    @httpLabel
    @required
    packId: Integer
}

structure ListPackFeaturedDocsInput {
    @httpLabel
    @required
    packId: Integer
}

structure ListPackInvitationsInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String
}

structure ListPackListingsInput {
    @httpQuery("packAccessTypes")
    packAccessTypes: PackAccessTypes

    @httpQuery("packIds")
    packIds: ListPackListingsPackIds

    @httpQuery("onlyWorkspaceId")
    onlyWorkspaceId: String

    @httpQuery("parentWorkspaceIds")
    parentWorkspaceIds: ListPackListingsParentWorkspaceIds

    @httpQuery("excludePublicPacks")
    excludePublicPacks: Boolean

    @httpQuery("packEntrypoint")
    packEntrypoint: PackEntrypoint

    @httpQuery("certifiedAgentsOnly")
    certifiedAgentsOnly: Boolean

    @httpQuery("packCategories")
    packCategories: ListPackListingsPackCategories

    @httpQuery("sortBy")
    sortBy: PackListingsSortBy

    @httpQuery("orderBy")
    orderBy: PackListingsSortBy

    @httpQuery("direction")
    direction: SortDirection

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("installContext")
    installContext: PackListingInstallContextType
}

list ListPackListingsPackCategories {
    member: PackCategoryType
}

list ListPackListingsPackIds {
    member: Integer
}

list ListPackListingsParentWorkspaceIds {
    member: String
}

structure ListPackLogsInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpLabel
    @required
    docId: String

    @httpQuery("logTypes")
    logTypes: ListPackLogsLogTypes

    @httpQuery("beforeTimestamp")
    beforeTimestamp: String

    @httpQuery("afterTimestamp")
    afterTimestamp: String

    @httpQuery("order")
    order: ListPackLogsOrder

    @httpQuery("q")
    q: String

    @httpQuery("requestIds")
    requestIds: ListPackLogsRequestIds
}

list ListPackLogsLogTypes {
    member: PackLogType
}

enum ListPackLogsOrder {
    @enumValue("asc")
    ASC

    @enumValue("desc")
    DESC
}

list ListPackLogsRequestIds {
    member: String
}

structure ListPackMakersInput {
    @httpLabel
    @required
    packId: Integer
}

structure ListPackReleasesInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String
}

structure ListPackReviewsInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("status")
    status: PackReviewStatus
}

structure ListPackVersionsInput {
    @httpLabel
    @required
    packId: Integer

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String
}

list ListPacksAccessTypes {
    member: PackAccessType
}

structure ListPacksInput {
    @httpQuery("accessType")
    accessType: PackAccessType

    @httpQuery("accessTypes")
    accessTypes: ListPacksAccessTypes

    @httpQuery("sortBy")
    sortBy: PacksSortBy

    @httpQuery("limit")
    limit: Integer

    @httpQuery("direction")
    direction: SortDirection

    @httpQuery("pageToken")
    pageToken: String

    @httpQuery("onlyWorkspaceId")
    onlyWorkspaceId: String

    @httpQuery("parentWorkspaceIds")
    parentWorkspaceIds: ListPacksParentWorkspaceIds

    @httpQuery("excludePublicPacks")
    excludePublicPacks: Boolean

    @httpQuery("packEntrypoint")
    packEntrypoint: PackEntrypoint
}

list ListPacksParentWorkspaceIds {
    member: String
}

structure ListUserPackInvitationsInput {
    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String
}

structure PackAssetUploadCompleteInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    packAssetId: String

    @httpLabel
    @required
    packAssetType: PackAssetType
}

structure PackSourceCodeUploadCompleteInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    packVersion: String

    @httpPayload
    @required
    payload: PackSourceCodeUploadCompletePayload
}

structure PackVersionUploadCompleteInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    packVersion: String

    @httpPayload
    @required
    payload: CreatePackVersionRequest
}

structure PatchPackSystemConnectionInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: PatchPackSystemConnectionPayload
}

structure PatchPackSystemConnectionOutput {
    @httpPayload
    body: PackSystemConnectionMetadata
}

structure RegisterPackVersionInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    packVersion: String

    @httpPayload
    @required
    payload: RegisterPackVersionPayload
}

structure ReplyToPackInvitationInput {
    @httpLabel
    @required
    invitationId: String

    @httpPayload
    @required
    payload: HandlePackInvitationRequest
}

structure SetPackOauthConfigInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: SetPackOauthConfigPayload
}

structure SetPackSystemConnectionInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: SetPackSystemConnectionPayload
}

structure SetPackSystemConnectionOutput {
    @httpPayload
    body: PackSystemConnectionMetadata
}

structure UpdatePackFeaturedDocsInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: UpdatePackFeaturedDocsPayload
}

structure UpdatePackInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: UpdatePackPayload
}

structure UpdatePackInvitationInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    invitationId: String

    @httpPayload
    @required
    payload: UpdatePackInvitationPayload
}

structure UpdatePackReleaseInput {
    @httpLabel
    @required
    packId: Integer

    @httpLabel
    @required
    packReleaseId: Integer

    @httpPayload
    @required
    payload: UpdatePackReleasePayload
}

structure UploadPackAssetInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: UploadPackAssetPayload
}

structure UploadPackSourceCodeInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: UploadPackSourceCodePayload
}

structure UpsertPackListingDraftInput {
    @httpLabel
    @required
    packId: Integer

    @httpPayload
    @required
    payload: UpsertPackListingDraftPayload
}
