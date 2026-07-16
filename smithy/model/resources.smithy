$version: "2"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#notProperty
use smithy.api#resourceIdentifier

@documentation("Opaque Pack identifier. Pack IDs are serialized as strings even when they contain only digits.")
string PackId

@documentation("A document category returned by the category catalog.")
resource CategoryResource {
    identifiers: { categoryName: String }
    list: ListCategories
}

@documentation("A Superhuman document and the resources contained by it.")
resource DocResource {
    identifiers: { docId: String }
    properties: {
        name: String
        href: String
        browserLink: String
    }
    create: CreateDoc
    read: GetDoc
    update: UpdateDoc
    delete: DeleteDoc
    list: ListDocs
    operations: [
        GetSharingMetadata
        GetPermissions
        AddPermission
        DeletePermission
        SearchPrincipals
        GetAclSettings
        UpdateAclSettings
        PublishDoc
        UnpublishDoc
    ]
    resources: [
        PageResource
        FormulaResource
        ControlResource
        CustomDocDomainResource
        AutomationResource
    ]
}

@documentation("A page contained by a document.")
resource PageResource {
    identifiers: {
        docId: String
        pageIdOrName: String
    }
    properties: {
        name: String
        href: String
        browserLink: String
    }
    create: CreatePage
    read: GetPage
    update: UpdatePage
    delete: DeletePage
    list: ListPages
    operations: [
        ListPageContent
        DeletePageContent
        BeginPageContentExport
        GetPageContentExportStatus
    ]
}

@documentation("A table or view contained by a document.")
resource TableResource {
    identifiers: {
        docId: String
        tableIdOrName: String
    }
    properties: {
        name: String
        href: String
    }
    read: GetTable
    list: ListTables
    resources: [ColumnResource, RowResource]
}

@documentation("A column contained by a table.")
resource ColumnResource {
    identifiers: {
        docId: String
        tableIdOrName: String
        columnIdOrName: String
    }
    properties: {
        name: String
        href: String
    }
    read: GetColumn
    list: ListColumns
}

@documentation("A row contained by a table.")
resource RowResource {
    identifiers: {
        docId: String
        tableIdOrName: String
        rowIdOrName: String
    }
    properties: {
        name: String
        href: String
    }
    read: GetRow
    update: UpdateRow
    delete: DeleteRow
    list: ListRows
    operations: [PushButton]
    collectionOperations: [UpsertRows, DeleteRows]
}

@documentation("A named formula contained by a document.")
resource FormulaResource {
    identifiers: {
        docId: String
        formulaIdOrName: String
    }
    properties: {
        name: String
        href: String
    }
    read: GetFormula
    list: ListFormulas
}

@documentation("A control contained by a document.")
resource ControlResource {
    identifiers: {
        docId: String
        controlIdOrName: String
    }
    properties: {
        name: String
        href: String
    }
    read: GetControl
    list: ListControls
}

@documentation("A custom domain associated with a document.")
resource CustomDocDomainResource {
    identifiers: {
        docId: String
        customDocDomain: String
    }
    create: AddCustomDocDomain
    update: UpdateCustomDocDomain
    delete: DeleteCustomDocDomain
    list: ListCustomDocDomains
}

@documentation("A webhook automation rule contained by a document.")
resource AutomationResource {
    identifiers: {
        docId: String
        ruleId: String
    }
    operations: [TriggerWebhookAutomation]
}

@documentation("A folder containing documents.")
resource FolderResource {
    identifiers: { folderId: String }
    properties: {
        name: String
        browserLink: String
        description: String
    }
    create: CreateFolder
    read: GetFolder
    update: UpdateFolder
    delete: DeleteFolder
    list: ListFolders
}

@documentation("A Pack and its subordinate development resources.")
resource PackResource {
    identifiers: { packId: PackId }
    properties: {
        name: String
        description: String
        workspaceId: String
    }
    create: CreatePack
    read: GetPack
    update: UpdatePack
    delete: DeletePack
    list: ListPacks
    operations: [
        GetPackConfigurationSchema
        GetNextPackVersion
        GetPackVersionDiffs
        PackVersionUploadComplete
        GetPackListingDraft
        UpsertPackListingDraft
        DeletePackListingDraft
        SetPackOauthConfig
        GetPackOauthConfig
        SetPackSystemConnection
        PatchPackSystemConnection
        GetPackSystemConnection
        UploadPackAsset
        UploadPackSourceCode
        PackAssetUploadComplete
        ListPackLogs
        ListIngestionLogs
        ListGroupedPackLogs
        ListGroupedIngestionLogs
        ListIngestionBatchExecutions
        ListIngestionParentItems
        GetPackLogDetails
        ListPackFeaturedDocs
        UpdatePackFeaturedDocs
    ]
    resources: [
        PackVersionResource
        PackReleaseResource
        PackReviewResource
        PackPermissionResource
        PackInvitationResource
        PackMakerResource
        PackCategoryResource
    ]
}

@documentation("A registered version of a Pack.")
resource PackVersionResource {
    identifiers: {
        packId: PackId
        packVersion: String
    }
    list: ListPackVersions
    operations: [
        RegisterPackVersion
        PackSourceCodeUploadComplete
        GetPackSourceCode
    ]
}

@documentation("A release of a Pack.")
resource PackReleaseResource {
    identifiers: {
        packId: PackId
        packReleaseId: String
    }
    create: CreatePackRelease
    update: UpdatePackRelease
    list: ListPackReleases
}

@documentation("A review of a Pack.")
resource PackReviewResource {
    identifiers: {
        packId: PackId
        packReviewId: String
    }
    create: CreatePackReview
    list: ListPackReviews
    collectionOperations: [CancelPackReview]
}

@documentation("A permission granted on a Pack.")
resource PackPermissionResource {
    identifiers: {
        packId: PackId
        permissionId: String
    }
    create: AddPackPermission
    delete: DeletePackPermission
    list: GetPackPermissions
    collectionOperations: [DeleteUserPackPermission]
}

@documentation("An invitation scoped to a Pack.")
resource PackInvitationResource {
    identifiers: {
        packId: PackId
        invitationId: String
    }
    create: CreatePackInvitation
    update: UpdatePackInvitation
    delete: DeletePackInvitation
    list: ListPackInvitations
}

@documentation("A maker assigned to a Pack.")
resource PackMakerResource {
    identifiers: {
        packId: PackId
        loginId: String
    }
    create: AddPackMaker
    delete: DeletePackMaker
    list: ListPackMakers
}

@documentation("A publishing category assigned to a Pack.")
resource PackCategoryResource {
    identifiers: {
        packId: PackId
        categoryName: String
    }
    create: AddPackCategory
    delete: DeletePackCategory
    list: ListPackCategories
}

@documentation("A Pack listing visible in the marketplace.")
resource MarketplacePackListingResource {
    identifiers: { packId: PackId }
    read: GetPackListing
    list: ListPackListings
}

@documentation("A Pack invitation received by the current user.")
resource UserPackInvitationResource {
    identifiers: { invitationId: String }
    list: ListUserPackInvitations
    operations: [ReplyToPackInvitation]
}

@documentation("A workspace whose membership and roles can be administered.")
resource WorkspaceResource {
    identifiers: { workspaceId: String }
    operations: [
        ListWorkspaceMembers
        ChangeUserRole
        ListWorkspaceRoleActivity
    ]
}

@documentation("An organization that owns Go links.")
resource OrganizationResource {
    identifiers: { organizationId: String }
    operations: [AddGoLink]
}

@documentation("Analytics reports available to the authenticated account.")
resource AnalyticsResource {
    operations: [
        ListDocAnalytics
        ListPageAnalytics
        ListDocAnalyticsSummary
        ListPackAnalytics
        ListPackAnalyticsSummary
        ListPackFormulaAnalytics
        GetAnalyticsLastUpdated
    ]
}

@documentation("An agent instance whose sessions and logs can be inspected.")
resource AgentInstanceResource {
    identifiers: {
        tenantId: String
        agentInstanceId: String
    }
    operations: [
        ListAgentSessionIds
        ListAgentLogs
        GetAgentPackLogDetails
    ]
}

@documentation("The processing status of an asynchronous mutation request.")
resource MutationStatusResource {
    identifiers: { requestId: String }
    properties: {
        completed: Boolean
        warning: String
    }
    read: GetMutationStatus
}

@documentation("The registrar provider detected for a custom domain.")
resource CustomDocDomainProviderResource {
    identifiers: { customDocDomain: String }
    properties: { provider: CustomDocDomainProvider }
    read: GetCustomDocDomainProvider
}

// Resource operations use the public API wire shapes directly. Explicitly mark
// transport-only members, and map wire `id` fields to resource identifiers.
apply Acl$items @notProperty
apply Acl$nextPageLink @notProperty
apply Acl$nextPageToken @notProperty
apply AclSettings$allowCopying @notProperty
apply AclSettings$allowEditorsToChangePermissions @notProperty
apply AclSettings$allowViewersToRequestEditing @notProperty
apply AddPermissionInput$payload @notProperty
apply BeginPageContentExportInput$payload @notProperty
apply BeginPageContentExportResponse$id @notProperty
apply BeginPageContentExportResponse$status @notProperty
apply ColumnDetail$calculated @notProperty
apply ColumnDetail$defaultValue @notProperty
apply ColumnDetail$display @notProperty
apply ColumnDetail$format @notProperty
apply ColumnDetail$formula @notProperty
apply ColumnDetail$id @resourceIdentifier("columnIdOrName")
apply ColumnDetail$parent @notProperty
apply ColumnDetail$type @notProperty
apply Control$controlType @notProperty
apply Control$id @resourceIdentifier("controlIdOrName")
apply Control$parent @notProperty
apply Control$type @notProperty
apply Control$value @notProperty
apply CreateDocInput$payload @notProperty
apply CreateFolderInput$payload @notProperty
apply CreatePackInput$payload @notProperty
apply CreatePackVersionResponse$deprecationWarnings @notProperty
apply CreatePageInput$payload @notProperty
apply DeletePageContentInput$payload @notProperty
apply DeletePermissionInput$permissionId @notProperty
apply Doc$createdAt @notProperty
apply Doc$docSize @notProperty
apply Doc$folder @notProperty
apply Doc$folderId @notProperty
apply Doc$icon @notProperty
apply Doc$id @resourceIdentifier("docId")
apply Doc$owner @notProperty
apply Doc$ownerName @notProperty
apply Doc$published @notProperty
apply Doc$requestId @notProperty
apply Doc$sourceDoc @notProperty
apply Doc$type @notProperty
apply Doc$updatedAt @notProperty
apply Doc$workspace @notProperty
apply Doc$workspaceId @notProperty
apply Folder$canEdit @notProperty
apply Folder$createdAt @notProperty
apply Folder$icon @notProperty
apply Folder$id @resourceIdentifier("folderId")
apply Folder$type @notProperty
apply Folder$workspace @notProperty
apply Formula$id @resourceIdentifier("formulaIdOrName")
apply Formula$parent @notProperty
apply Formula$type @notProperty
apply Formula$value @notProperty
apply GetNextPackVersionInput$payload @notProperty
apply GetPackListingDraftResponse$listingData @notProperty
apply GetPackListingDraftResponse$packListingDraftId @notProperty
apply GetPackLogDetailsInput$detailsKey @notProperty
apply GetPackLogDetailsInput$logId @notProperty
apply GetPackLogDetailsInput$rootIngestionId @notProperty
apply GetPackLogDetailsInput$tenantId @notProperty
apply GetPackLogDetailsOutput$body @notProperty
apply GetPackSystemConnectionOutput$body @notProperty
apply GetPackVersionDiffsInput$basePackVersion @notProperty
apply GetPackVersionDiffsInput$targetPackVersion @notProperty
apply GetPageContentExportStatusInput$requestId @notProperty
apply GetPermissionsInput$limit @notProperty
apply GetPermissionsInput$pageToken @notProperty
apply GetRowInput$useColumnNames @notProperty
apply GetRowInput$valueFormat @notProperty
apply GetTableInput$useUpdatedTableLayouts @notProperty
apply GroupedPackLogsList$incompleteRelatedLogs @notProperty
apply GroupedPackLogsList$items @notProperty
apply GroupedPackLogsList$nextPageLink @notProperty
apply GroupedPackLogsList$nextPageToken @notProperty
apply IngestionBatchExecutionsList$items @notProperty
apply IngestionBatchExecutionsList$nextPageToken @notProperty
apply IngestionParentItemsList$items @notProperty
apply IngestionParentItemsList$nextPageToken @notProperty
apply ListGroupedIngestionLogsInput$afterTimestamp @notProperty
apply ListGroupedIngestionLogsInput$beforeTimestamp @notProperty
apply ListGroupedIngestionLogsInput$ingestionExecutionId @notProperty
apply ListGroupedIngestionLogsInput$limit @notProperty
apply ListGroupedIngestionLogsInput$order @notProperty
apply ListGroupedIngestionLogsInput$pageToken @notProperty
apply ListGroupedIngestionLogsInput$q @notProperty
apply ListGroupedIngestionLogsInput$rootIngestionId @notProperty
apply ListGroupedIngestionLogsInput$tenantId @notProperty
apply ListGroupedPackLogsInput$afterTimestamp @notProperty
apply ListGroupedPackLogsInput$beforeTimestamp @notProperty
apply ListGroupedPackLogsInput$docId @notProperty
apply ListGroupedPackLogsInput$limit @notProperty
apply ListGroupedPackLogsInput$order @notProperty
apply ListGroupedPackLogsInput$pageToken @notProperty
apply ListGroupedPackLogsInput$q @notProperty
apply ListIngestionBatchExecutionsInput$datasource @notProperty
apply ListIngestionBatchExecutionsInput$executionType @notProperty
apply ListIngestionBatchExecutionsInput$includeDeletedIngestions @notProperty
apply ListIngestionBatchExecutionsInput$ingestionExecutionId @notProperty
apply ListIngestionBatchExecutionsInput$ingestionId @notProperty
apply ListIngestionBatchExecutionsInput$ingestionStatus @notProperty
apply ListIngestionBatchExecutionsInput$limit @notProperty
apply ListIngestionBatchExecutionsInput$pageToken @notProperty
apply ListIngestionBatchExecutionsInput$rootIngestionId @notProperty
apply ListIngestionBatchExecutionsInput$tenantId @notProperty
apply ListIngestionLogsInput$afterTimestamp @notProperty
apply ListIngestionLogsInput$beforeTimestamp @notProperty
apply ListIngestionLogsInput$ingestionExecutionId @notProperty
apply ListIngestionLogsInput$ingestionStatus @notProperty
apply ListIngestionLogsInput$limit @notProperty
apply ListIngestionLogsInput$logTypes @notProperty
apply ListIngestionLogsInput$onlyExecutionCompletions @notProperty
apply ListIngestionLogsInput$order @notProperty
apply ListIngestionLogsInput$pageToken @notProperty
apply ListIngestionLogsInput$q @notProperty
apply ListIngestionLogsInput$requestIds @notProperty
apply ListIngestionLogsInput$rootIngestionId @notProperty
apply ListIngestionLogsInput$tenantId @notProperty
apply ListIngestionParentItemsInput$ingestionExecutionId @notProperty
apply ListIngestionParentItemsInput$ingestionId @notProperty
apply ListIngestionParentItemsInput$ingestionStatus @notProperty
apply ListIngestionParentItemsInput$limit @notProperty
apply ListIngestionParentItemsInput$pageToken @notProperty
apply ListIngestionParentItemsInput$rootIngestionId @notProperty
apply ListIngestionParentItemsInput$tenantId @notProperty
apply ListPackLogsInput$afterTimestamp @notProperty
apply ListPackLogsInput$beforeTimestamp @notProperty
apply ListPackLogsInput$docId @notProperty
apply ListPackLogsInput$limit @notProperty
apply ListPackLogsInput$logTypes @notProperty
apply ListPackLogsInput$order @notProperty
apply ListPackLogsInput$pageToken @notProperty
apply ListPackLogsInput$q @notProperty
apply ListPackLogsInput$requestIds @notProperty
apply ListPageContentInput$contentFormat @notProperty
apply ListPageContentInput$limit @notProperty
apply ListPageContentInput$pageToken @notProperty
apply NextPackVersionInfo$findingDetails @notProperty
apply NextPackVersionInfo$findings @notProperty
apply NextPackVersionInfo$nextVersion @notProperty
apply Pack$additionalInformation @notProperty
apply Pack$agentDescription @notProperty
apply Pack$agentImages @notProperty
apply Pack$agentShortDescription @notProperty
apply Pack$categories @notProperty
apply Pack$certified @notProperty
apply Pack$certifiedAgent @notProperty
apply Pack$coverUrl @notProperty
apply Pack$exampleImages @notProperty
apply Pack$featuredDocStatus @notProperty
apply Pack$id @resourceIdentifier("packId")
apply Pack$logoUrl @notProperty
apply Pack$overallRateLimit @notProperty
apply Pack$packEntrypoints @notProperty
apply Pack$perConnectionRateLimit @notProperty
apply Pack$privacyPolicyUrl @notProperty
apply Pack$shortDescription @notProperty
apply Pack$sourceCodeVisibility @notProperty
apply Pack$supportEmail @notProperty
apply Pack$termsOfServiceUrl @notProperty
apply Pack$verifiedVersion @notProperty
apply PackAssetUploadCompleteInput$packAssetId @notProperty
apply PackAssetUploadCompleteInput$packAssetType @notProperty
apply PackAssetUploadCompleteResponse$assetId @notProperty
apply PackAssetUploadCompleteResponse$requestId @notProperty
apply PackAssetUploadInfo$headers @notProperty
apply PackAssetUploadInfo$packAssetUploadedPathName @notProperty
apply PackAssetUploadInfo$uploadUrl @notProperty
apply PackFeaturedDocsResponse$items @notProperty
apply PackLogsList$items @notProperty
apply PackLogsList$nextPageLink @notProperty
apply PackLogsList$nextPageToken @notProperty
apply PackOauthConfigMetadata$authorizationUrl @notProperty
apply PackOauthConfigMetadata$maskedClientId @notProperty
apply PackOauthConfigMetadata$maskedClientSecret @notProperty
apply PackOauthConfigMetadata$redirectUri @notProperty
apply PackOauthConfigMetadata$scopes @notProperty
apply PackOauthConfigMetadata$tokenPrefix @notProperty
apply PackOauthConfigMetadata$tokenUrl @notProperty
apply PackOauthConfigMetadata$useDynamicClientRegistration @notProperty
apply PackSourceCodeUploadInfo$headers @notProperty
apply PackSourceCodeUploadInfo$uploadUrl @notProperty
apply PackSourceCodeUploadInfo$uploadedPathName @notProperty
apply PackVersionDiffs$findingDetails @notProperty
apply PackVersionDiffs$findings @notProperty
apply PackVersionUploadCompleteInput$packVersion @notProperty
apply PackVersionUploadCompleteInput$payload @notProperty
apply Page$authors @notProperty
apply Page$children @notProperty
apply Page$contentType @notProperty
apply Page$createdAt @notProperty
apply Page$createdBy @notProperty
apply Page$icon @notProperty
apply Page$id @resourceIdentifier("pageIdOrName")
apply Page$image @notProperty
apply Page$isEffectivelyHidden @notProperty
apply Page$isHidden @notProperty
apply Page$parent @notProperty
apply Page$subtitle @notProperty
apply Page$type @notProperty
apply Page$updatedAt @notProperty
apply Page$updatedBy @notProperty
apply PageContentDeleteResponse$id @resourceIdentifier("pageIdOrName")
apply PageContentDeleteResponse$requestId @notProperty
apply PageContentExportStatusResponse$downloadLink @notProperty
apply PageContentExportStatusResponse$error @notProperty
apply PageContentExportStatusResponse$id @notProperty
apply PageContentExportStatusResponse$status @notProperty
apply PageContentList$items @notProperty
apply PageContentList$nextPageLink @notProperty
apply PageContentList$nextPageToken @notProperty
apply PageCreateResponse$id @resourceIdentifier("pageIdOrName")
apply PageCreateResponse$requestId @notProperty
apply PageDeleteResponse$id @resourceIdentifier("pageIdOrName")
apply PageDeleteResponse$requestId @notProperty
apply PageUpdateResponse$id @resourceIdentifier("pageIdOrName")
apply PageUpdateResponse$requestId @notProperty
apply PatchPackSystemConnectionInput$payload @notProperty
apply PatchPackSystemConnectionOutput$body @notProperty
apply PublishDocInput$payload @notProperty
apply PublishResponse$requestId @notProperty
apply PushButtonInput$columnIdOrName @notProperty
apply PushButtonResponse$columnId @notProperty
apply PushButtonResponse$requestId @notProperty
apply PushButtonResponse$rowId @notProperty
apply RowDeleteResponse$id @resourceIdentifier("rowIdOrName")
apply RowDeleteResponse$requestId @notProperty
apply RowDetail$browserLink @notProperty
apply RowDetail$createdAt @notProperty
apply RowDetail$id @resourceIdentifier("rowIdOrName")
apply RowDetail$index @notProperty
apply RowDetail$parent @notProperty
apply RowDetail$type @notProperty
apply RowDetail$updatedAt @notProperty
apply RowDetail$values @notProperty
apply RowUpdateResponse$id @resourceIdentifier("rowIdOrName")
apply RowUpdateResponse$requestId @notProperty
apply SearchPrincipalsInput$query @notProperty
apply SearchPrincipalsResponse$groups @notProperty
apply SearchPrincipalsResponse$users @notProperty
apply SetPackOauthConfigInput$payload @notProperty
apply SetPackSystemConnectionInput$payload @notProperty
apply SetPackSystemConnectionOutput$body @notProperty
apply SharingMetadata$canCopy @notProperty
apply SharingMetadata$canShare @notProperty
apply SharingMetadata$canShareWithOrg @notProperty
apply SharingMetadata$canShareWithWorkspace @notProperty
apply Table$browserLink @notProperty
apply Table$createdAt @notProperty
apply Table$displayColumn @notProperty
apply Table$filter @notProperty
apply Table$id @resourceIdentifier("tableIdOrName")
apply Table$layout @notProperty
apply Table$parent @notProperty
apply Table$parentTable @notProperty
apply Table$rowCount @notProperty
apply Table$sorts @notProperty
apply Table$tableType @notProperty
apply Table$type @notProperty
apply Table$updatedAt @notProperty
apply UpdateAclSettingsInput$payload @notProperty
apply UpdateDocInput$payload @notProperty
apply UpdateFolderInput$payload @notProperty
apply UpdatePackFeaturedDocsInput$payload @notProperty
apply UpdatePackInput$payload @notProperty
apply UpdatePageInput$payload @notProperty
apply UpdateRowInput$disableParsing @notProperty
apply UpdateRowInput$payload @notProperty
apply UploadPackAssetInput$payload @notProperty
apply UploadPackSourceCodeInput$payload @notProperty
apply UpsertPackListingDraftInput$payload @notProperty
apply UpsertPackListingDraftResponse$listingData @notProperty
apply UpsertPackListingDraftResponse$packListingDraftId @notProperty
