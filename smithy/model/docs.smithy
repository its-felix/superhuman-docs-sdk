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

@documentation("Get doc categories")
@readonly
@http(method: "GET", uri: "/categories", code: 200)
operation ListCategories {
    output: DocCategoryList
    errors: [
        UnauthorizedError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List available docs")
@readonly
@http(method: "GET", uri: "/docs", code: 200)
operation ListDocs {
    input: ListDocsInput
    output: DocList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Create doc")
@http(method: "POST", uri: "/docs", code: 201)
operation CreateDoc {
    input: CreateDocInput
    output: Doc
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        TooManyRequestsError
    ]
}

@documentation("Get info about a doc")
@readonly
@http(method: "GET", uri: "/docs/{docId}", code: 200)
operation GetDoc {
    input: GetDocInput
    output: Doc
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete doc")
@idempotent
@http(method: "DELETE", uri: "/docs/{docId}", code: 202)
operation DeleteDoc {
    input: DeleteDocInput
    output: DocDelete
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Update doc")
@http(method: "PATCH", uri: "/docs/{docId}", code: 200)
operation UpdateDoc {
    input: UpdateDocInput
    output: DocUpdateResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get sharing metadata")
@readonly
@http(method: "GET", uri: "/docs/{docId}/acl/metadata", code: 200)
operation GetSharingMetadata {
    input: GetSharingMetadataInput
    output: SharingMetadata
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List permissions")
@readonly
@http(method: "GET", uri: "/docs/{docId}/acl/permissions", code: 200)
operation GetPermissions {
    input: GetPermissionsInput
    output: Acl
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Add permission")
@http(method: "POST", uri: "/docs/{docId}/acl/permissions", code: 200)
operation AddPermission {
    input: AddPermissionInput
    output: AddPermissionResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete permission")
@idempotent
@http(method: "DELETE", uri: "/docs/{docId}/acl/permissions/{permissionId}", code: 200)
operation DeletePermission {
    input: DeletePermissionInput
    output: DeletePermissionResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Search principals")
@readonly
@http(method: "GET", uri: "/docs/{docId}/acl/principals/search", code: 200)
operation SearchPrincipals {
    input: SearchPrincipalsInput
    output: SearchPrincipalsResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get ACL settings")
@readonly
@http(method: "GET", uri: "/docs/{docId}/acl/settings", code: 200)
operation GetAclSettings {
    input: GetAclSettingsInput
    output: AclSettings
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Update ACL settings")
@http(method: "PATCH", uri: "/docs/{docId}/acl/settings", code: 200)
operation UpdateAclSettings {
    input: UpdateAclSettingsInput
    output: AclSettings
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Publish doc")
@idempotent
@http(method: "PUT", uri: "/docs/{docId}/publish", code: 202)
operation PublishDoc {
    input: PublishDocInput
    output: PublishResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Unpublish doc")
@idempotent
@http(method: "DELETE", uri: "/docs/{docId}/publish", code: 200)
operation UnpublishDoc {
    input: UnpublishDocInput
    output: UnpublishResponse
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List custom doc domains")
@readonly
@http(method: "GET", uri: "/docs/{docId}/domains", code: 200)
operation ListCustomDocDomains {
    input: ListCustomDocDomainsInput
    output: CustomDocDomainList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Add custom domain")
@http(method: "POST", uri: "/docs/{docId}/domains", code: 202)
operation AddCustomDocDomain {
    input: AddCustomDocDomainInput
    output: AddCustomDocDomainResponse
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Deletes a custom domain")
@idempotent
@http(method: "DELETE", uri: "/docs/{docId}/domains/{customDocDomain}", code: 200)
operation DeleteCustomDocDomain {
    input: DeleteCustomDocDomainInput
    output: DeleteCustomDocDomainResponse
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Updates a custom domain")
@http(method: "PATCH", uri: "/docs/{docId}/domains/{customDocDomain}", code: 200)
operation UpdateCustomDocDomain {
    input: UpdateCustomDocDomainInput
    output: UpdateCustomDocDomainResponse
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Gets custom doc domains providers")
@readonly
@http(method: "GET", uri: "/domains/provider/{customDocDomain}", code: 200)
operation GetCustomDocDomainProvider {
    input: GetCustomDocDomainProviderInput
    output: CustomDocDomainProviderResponse
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List folders")
@readonly
@http(method: "GET", uri: "/folders", code: 200)
operation ListFolders {
    input: ListFoldersInput
    output: FolderList
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        TooManyRequestsError
    ]
}

@documentation("Create folder")
@http(method: "POST", uri: "/folders", code: 201)
operation CreateFolder {
    input: CreateFolderInput
    output: Folder
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        TooManyRequestsError
    ]
}

@documentation("Get folder")
@readonly
@http(method: "GET", uri: "/folders/{folderId}", code: 200)
operation GetFolder {
    input: GetFolderInput
    output: Folder
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Update folder")
@http(method: "PATCH", uri: "/folders/{folderId}", code: 200)
operation UpdateFolder {
    input: UpdateFolderInput
    output: Folder
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Delete folder")
@idempotent
@http(method: "DELETE", uri: "/folders/{folderId}", code: 200)
operation DeleteFolder {
    input: DeleteFolderInput
    output: DeleteFolderResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get user info")
@readonly
@http(method: "GET", uri: "/whoami", code: 200)
operation Whoami {
    output: User
    errors: [
        UnauthorizedError
        TooManyRequestsError
    ]
}

@documentation("Resolve browser link")
@readonly
@http(method: "GET", uri: "/resolveBrowserLink", code: 200)
operation ResolveBrowserLink {
    input: ResolveBrowserLinkInput
    output: ApiLink
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Get mutation status")
@readonly
@http(method: "GET", uri: "/mutationStatus/{requestId}", code: 200)
operation GetMutationStatus {
    input: GetMutationStatusInput
    output: MutationStatus
    errors: [
        UnauthorizedError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Trigger automation")
@http(method: "POST", uri: "/docs/{docId}/hooks/automation/{ruleId}", code: 202)
operation TriggerWebhookAutomation {
    input: TriggerWebhookAutomationInput
    output: WebhookTriggerResponse
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        UnprocessableEntityError
        TooManyRequestsError
    ]
}

@documentation("List workspace users")
@readonly
@http(method: "GET", uri: "/workspaces/{workspaceId}/users", code: 200)
operation ListWorkspaceMembers {
    input: ListWorkspaceMembersInput
    output: WorkspaceMembersList
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Updates user role")
@http(method: "POST", uri: "/workspaces/{workspaceId}/users/role", code: 200)
operation ChangeUserRole {
    input: ChangeUserRoleInput
    output: ChangeRoleResponse
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("List workspace roles")
@readonly
@http(method: "GET", uri: "/workspaces/{workspaceId}/roles", code: 200)
operation ListWorkspaceRoleActivity {
    input: ListWorkspaceRoleActivityInput
    output: GetWorkspaceRoleActivity
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        TooManyRequestsError
    ]
}

@documentation("Add a go link")
@http(method: "POST", uri: "/organizations/{organizationId}/goLinks", code: 200)
operation AddGoLink {
    input: AddGoLinkInput
    output: AddGoLinkResponse
    errors: [
        BadRequestError
        ForbiddenError
    ]
}

structure AddCustomDocDomainInput {
    @httpLabel
    @required
    docId: String

    @httpPayload
    @required
    payload: AddCustomDocDomainPayload
}

structure AddGoLinkInput {
    @httpLabel
    @required
    organizationId: String

    @httpPayload
    @required
    payload: AddGoLinkPayload
}

structure AddPermissionInput {
    @httpLabel
    @required
    docId: String

    @httpPayload
    @required
    payload: AddPermissionPayload
}

structure ChangeUserRoleInput {
    @httpLabel
    @required
    workspaceId: String

    @httpPayload
    @required
    payload: ChangeRole
}

structure CreateDocInput {
    @httpPayload
    @required
    payload: DocCreate
}

structure CreateFolderInput {
    @httpPayload
    @required
    payload: CreateFolderPayload
}

structure DeleteCustomDocDomainInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    customDocDomain: String
}

structure DeleteDocInput {
    @httpLabel
    @required
    docId: String
}

structure DeleteFolderInput {
    @httpLabel
    @required
    folderId: String
}

structure DeletePermissionInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    permissionId: String
}

structure GetAclSettingsInput {
    @httpLabel
    @required
    docId: String
}

structure GetCustomDocDomainProviderInput {
    @httpLabel
    @required
    customDocDomain: String
}

structure GetDocInput {
    @httpLabel
    @required
    docId: String
}

structure GetFolderInput {
    @httpLabel
    @required
    folderId: String
}

structure GetMutationStatusInput {
    @httpLabel
    @required
    requestId: String
}

structure GetPermissionsInput {
    @httpLabel
    @required
    docId: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String
}

structure GetSharingMetadataInput {
    @httpLabel
    @required
    docId: String
}

structure ListCustomDocDomainsInput {
    @httpLabel
    @required
    docId: String
}

structure ListDocsInput {
    @httpQuery("isOwner")
    isOwner: Boolean

    @httpQuery("isPublished")
    isPublished: Boolean

    @httpQuery("query")
    query: String

    @httpQuery("sourceDoc")
    sourceDoc: String

    @httpQuery("isStarred")
    isStarred: Boolean

    @httpQuery("inGallery")
    inGallery: Boolean

    @httpQuery("workspaceId")
    workspaceId: String

    @httpQuery("folderId")
    folderId: String

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String
}

structure ListFoldersInput {
    @httpQuery("workspaceId")
    workspaceId: String

    @httpQuery("isStarred")
    isStarred: Boolean

    @httpQuery("limit")
    limit: Integer

    @httpQuery("pageToken")
    pageToken: String
}

list ListWorkspaceMembersIncludedRoles {
    member: WorkspaceUserRole
}

structure ListWorkspaceMembersInput {
    @httpLabel
    @required
    workspaceId: String

    @httpQuery("includedRoles")
    includedRoles: ListWorkspaceMembersIncludedRoles

    @httpQuery("pageToken")
    pageToken: String
}

structure ListWorkspaceRoleActivityInput {
    @httpLabel
    @required
    workspaceId: String
}

structure PublishDocInput {
    @httpLabel
    @required
    docId: String

    @httpPayload
    @required
    payload: DocPublish
}

structure ResolveBrowserLinkInput {
    @httpQuery("url")
    @required
    url: String

    @httpQuery("degradeGracefully")
    degradeGracefully: Boolean
}

structure SearchPrincipalsInput {
    @httpLabel
    @required
    docId: String

    @httpQuery("query")
    query: String
}

structure TriggerWebhookAutomationInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    ruleId: String

    @httpPayload
    payload: WebhookTriggerPayload
}

structure UnpublishDocInput {
    @httpLabel
    @required
    docId: String
}

structure UpdateAclSettingsInput {
    @httpLabel
    @required
    docId: String

    @httpPayload
    @required
    payload: UpdateAclSettingsPayload
}

structure UpdateCustomDocDomainInput {
    @httpLabel
    @required
    docId: String

    @httpLabel
    @required
    customDocDomain: String

    @httpPayload
    @required
    payload: UpdateCustomDocDomainPayload
}

structure UpdateDocInput {
    @httpLabel
    @required
    docId: String

    @httpPayload
    @required
    payload: DocUpdate
}

structure UpdateFolderInput {
    @httpLabel
    @required
    folderId: String

    @httpPayload
    @required
    payload: UpdateFolderPayload
}
