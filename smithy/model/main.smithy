$version: "2"

metadata openapiSource = "https://docs.superhuman.com/apis/v1/openapi.json"
metadata originalApiTitle = "Coda API"
metadata originalApiVersion = "1.5.0"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#httpBearerAuth

@documentation("Superhuman Docs API v1. Resource-oriented model of the public API.")
@httpBearerAuth
service SuperhumanDocsApi {
    version: "1.5.0"

    // Direct service operations are intentionally limited to RPC-style actions
    // that do not belong to a resource hierarchy.
    operations: [
        Whoami
        ResolveBrowserLink
    ]

    resources: [
        CategoryResource
        DocResource
        TableResource
        FolderResource
        PackResource
        MarketplacePackListingResource
        UserPackInvitationResource
        WorkspaceResource
        OrganizationResource
        AnalyticsResource
        AgentInstanceResource
        MutationStatusResource
        CustomDocDomainProviderResource
    ]
}
