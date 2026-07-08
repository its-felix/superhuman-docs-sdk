$version: "2"

metadata openapiSource = "https://docs.superhuman.com/apis/v1/openapi.json"
metadata originalApiTitle = "Coda API"
metadata originalApiVersion = "1.5.0"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#httpBearerAuth

@documentation("Superhuman Docs API v1, generated from the public OpenAPI description. The published OpenAPI document still identifies the API as Coda API v1.")
@httpBearerAuth
service SuperhumanDocsApi {
    version: "1.5.0"
    operations: [
        ListCategories
        ListDocs
        CreateDoc
        GetDoc
        DeleteDoc
        UpdateDoc
        GetSharingMetadata
        GetPermissions
        AddPermission
        DeletePermission
        SearchPrincipals
        GetAclSettings
        UpdateAclSettings
        PublishDoc
        UnpublishDoc
        ListPages
        CreatePage
        GetPage
        UpdatePage
        DeletePage
        ListPageContent
        DeletePageContent
        BeginPageContentExport
        GetPageContentExportStatus
        ListTables
        GetTable
        ListColumns
        ListRows
        UpsertRows
        DeleteRows
        GetRow
        UpdateRow
        DeleteRow
        PushButton
        GetColumn
        ListFormulas
        GetFormula
        ListControls
        GetControl
        ListCustomDocDomains
        AddCustomDocDomain
        DeleteCustomDocDomain
        UpdateCustomDocDomain
        GetCustomDocDomainProvider
        ListFolders
        CreateFolder
        GetFolder
        UpdateFolder
        DeleteFolder
        Whoami
        ResolveBrowserLink
        GetMutationStatus
        TriggerWebhookAutomation
        ListDocAnalytics
        ListPageAnalytics
        ListDocAnalyticsSummary
        ListPackAnalytics
        ListPackAnalyticsSummary
        ListPackFormulaAnalytics
        GetAnalyticsLastUpdated
        ListWorkspaceMembers
        ChangeUserRole
        ListWorkspaceRoleActivity
        ListPacks
        CreatePack
        GetPack
        UpdatePack
        DeletePack
        GetPackConfigurationSchema
        ListPackVersions
        GetNextPackVersion
        GetPackVersionDiffs
        RegisterPackVersion
        PackVersionUploadComplete
        CreatePackRelease
        ListPackReleases
        UpdatePackRelease
        ListPackReviews
        CreatePackReview
        CancelPackReview
        GetPackListingDraft
        UpsertPackListingDraft
        DeletePackListingDraft
        SetPackOauthConfig
        GetPackOauthConfig
        SetPackSystemConnection
        PatchPackSystemConnection
        GetPackSystemConnection
        GetPackPermissions
        AddPackPermission
        DeleteUserPackPermission
        DeletePackPermission
        ListUserPackInvitations
        ListPackInvitations
        CreatePackInvitation
        UpdatePackInvitation
        DeletePackInvitation
        ReplyToPackInvitation
        ListPackMakers
        AddPackMaker
        DeletePackMaker
        ListPackCategories
        AddPackCategory
        DeletePackCategory
        UploadPackAsset
        UploadPackSourceCode
        PackAssetUploadComplete
        PackSourceCodeUploadComplete
        GetPackSourceCode
        ListPackListings
        GetPackListing
        ListPackLogs
        ListIngestionLogs
        ListGroupedPackLogs
        ListGroupedIngestionLogs
        ListIngestionBatchExecutions
        ListIngestionParentItems
        GetPackLogDetails
        ListPackFeaturedDocs
        UpdatePackFeaturedDocs
        AddGoLink
        ListAgentSessionIds
        ListAgentLogs
        GetAgentPackLogDetails
    ]
}
