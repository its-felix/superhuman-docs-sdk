$version: "2"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#enumValue
use smithy.api#jsonName
use smithy.api#required

@documentation("Type of access.")
enum AccessType {
    @enumValue("readonly")
    READONLY

    @enumValue("write")
    WRITE

    @enumValue("comment")
    COMMENT

    @enumValue("none")
    NONE
}

@documentation("Type of access (excluding none).")
enum AccessTypeNotNone {
    @enumValue("readonly")
    READONLY

    @enumValue("write")
    WRITE

    @enumValue("comment")
    COMMENT
}

@documentation("List of Permissions.")
structure Acl {
    @required
    items: AclItems

    @documentation("API link to these results")
    @required
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

@documentation("Doc level metadata associated with ACL.")
structure Acl2 {
    @documentation("When true, the user of the api can share")
    @required
    canShare: Boolean

    @documentation("When true, the user of the api can share with the workspace")
    @required
    canShareWithWorkspace: Boolean

    @documentation("When true, the user of the api can share with the org")
    @required
    canShareWithOrg: Boolean

    @documentation("When true, the user of the api can copy the doc")
    @required
    canCopy: Boolean
}

list AclItems {
    member: Permission
}

@documentation("Sharing settings for the doc.")
structure AclSettings {
    @documentation("When true, allows editors to change doc permissions. When false, only doc owner can change doc permissions.")
    @required
    allowEditorsToChangePermissions: Boolean

    @documentation("When true, allows doc viewers to copy the doc.")
    @required
    allowCopying: Boolean

    @documentation("When true, allows doc viewers to request editing permissions.")
    @required
    allowViewersToRequestEditing: Boolean
}

@documentation("Payload for adding a custom published doc domain.")
structure AddCustomDocDomainPayload {
    @documentation("The custom domain.")
    @required
    customDocDomain: String
}

@documentation("The result of adding a custom domain to a published doc.")
structure AddCustomDocDomainResponse {}

@documentation("Payload for creating a Go Link")
structure AddGoLinkPayload {
    @documentation("The name of the Go Link that comes after go/. Only alphanumeric characters, dashes, and underscores are allowed.")
    @required
    name: String

    @documentation("The URL that the Go Link redirects to.")
    @required
    destinationUrl: String

    @documentation("Optional description for the Go Link.")
    description: String

    @documentation("Optional destination URL with {*} placeholders for variables to be inserted. Variables are specified like go/<name>/<var1>/<var2>.")
    urlPattern: String

    @documentation("Optional creator email for the Go Link. Only organization admins can set this field.")
    creatorEmail: String
}

@documentation("The result of adding a Go Link.")
structure AddGoLinkResult {}

@documentation("Payload for adding a Pack Category.")
structure AddPackCategoryPayload {
    @documentation("Name of the publishing category.")
    @required
    categoryName: String
}

@documentation("Confirmation of successfully adding a Pack category.")
structure AddPackCategoryResponse {}

@documentation("Payload for adding a Pack maker.")
structure AddPackMakerPayload {
    @documentation("The email of the Pack maker.")
    @required
    loginId: String
}

@documentation("Confirmation of successfully adding a Pack maker.")
structure AddPackMakerResponse {}

@documentation("Confirmation of successfully deleting a Pack maker.")
structure AddPackMakerResponse2 {}

@documentation("Payload for upserting a Pack permission.")
structure AddPackPermissionPayload {
    @required
    principal: PackPrincipal

    @required
    access: PackAccessType
}

@documentation("Confirmation of successfully upserting a Pack permission.")
structure AddPackPermissionResponse {
    @documentation("The ID of the permission created or updated.")
    @required
    permissionId: String
}

@documentation("Payload for granting a new permission.")
structure AddPermissionPayload {
    @required
    access: AccessTypeNotNone

    @required
    principal: AddedPrincipal

    @documentation("When true suppresses email notification")
    suppressEmail: Boolean
}

@documentation("The result of sharing a doc.")
structure AddPermissionResult {}

structure AddedAnyonePrincipal {
    @documentation("The type of this principal.")
    @required
    type: AddedAnyonePrincipalType
}

@documentation("The type of this principal.")
enum AddedAnyonePrincipalType {
    @enumValue("anyone")
    ANYONE
}

structure AddedDomainPrincipal {
    @documentation("The type of this principal.")
    @required
    type: AddedDomainPrincipalType

    @documentation("Domain for the principal.")
    @required
    domain: String
}

@documentation("The type of this principal.")
enum AddedDomainPrincipalType {
    @enumValue("domain")
    DOMAIN
}

structure AddedEmailPrincipal {
    @documentation("The type of this principal.")
    @required
    type: AddedEmailPrincipalType

    @documentation("Email for the principal.")
    @required
    email: String
}

@documentation("The type of this principal.")
enum AddedEmailPrincipalType {
    @enumValue("email")
    EMAIL
}

structure AddedGroupPrincipal {
    @documentation("The type of this principal.")
    @required
    type: AddedGroupPrincipalType

    @documentation("Group ID for the principal.")
    @required
    groupId: String
}

@documentation("The type of this principal.")
enum AddedGroupPrincipalType {
    @enumValue("group")
    GROUP
}

@documentation("Metadata about a principal to add to a doc.")
union AddedPrincipal {
    addedEmailPrincipal: AddedEmailPrincipal
    addedGroupPrincipal: AddedGroupPrincipal
    addedDomainPrincipal: AddedDomainPrincipal
    addedWorkspacePrincipal: AddedWorkspacePrincipal
    addedAnyonePrincipal: AddedAnyonePrincipal
}

structure AddedWorkspacePrincipal {
    @documentation("The type of this principal.")
    @required
    type: AddedWorkspacePrincipalType

    @documentation("WorkspaceId for the principal.")
    @required
    workspaceId: String
}

@documentation("The type of this principal.")
enum AddedWorkspacePrincipalType {
    @enumValue("workspace")
    WORKSPACE
}

@documentation("Response representing the last day analytics were updated.")
structure AnalyticsLastUpdatedResponse {
    @documentation("Date that doc analytics were last updated.")
    @required
    docAnalyticsLastUpdated: String

    @documentation("Date that Pack analytics were last updated.")
    @required
    packAnalyticsLastUpdated: String

    @documentation("Date that Pack formula analytics were last updated.")
    @required
    packFormulaAnalyticsLastUpdated: String
}

@documentation("Quantization period over which to view analytics.")
enum AnalyticsScale {
    @enumValue("daily")
    DAILY

    @enumValue("cumulative")
    CUMULATIVE
}

structure AnyonePrincipal {
    @documentation("The type of this principal.")
    @required
    type: AnyonePrincipalType
}

@documentation("The type of this principal.")
enum AnyonePrincipalType {
    @enumValue("anyone")
    ANYONE
}

@documentation("Info about a resolved link to an API resource.")
structure ApiLink {
    @documentation("The type of this resource.")
    @required
    type: ApiLinkType

    @documentation("Self link to this query.")
    @required
    href: String

    @documentation("Canonical browser-friendly link to the resolved resource.")
    browserLink: String

    @required
    @jsonName("resource")
    resourceValue: ApiLinkResolvedResource
}

@documentation("Reference to the resolved resource.")
structure ApiLinkResolvedResource {
    @required
    type: Type

    @documentation("ID of the resolved resource.")
    @required
    id: String

    @documentation("Name of the resource.")
    name: String

    @documentation("API link to the resolved resource that can be queried to get further information.")
    @required
    href: String
}

@documentation("The type of this resource.")
enum ApiLinkType {
    @enumValue("apiLink")
    API_LINK
}

@documentation("Detail about why this request was rejected.")
structure BadRequestWithValidationErrorsCodaDetail {
    validationErrors: BadRequestWithValidationErrorsCodaDetailValidationErrors
}

list BadRequestWithValidationErrorsCodaDetailValidationErrors {
    member: ValidationError
}

@documentation("Request for beginning an export of page content.")
structure BeginPageContentExportPayload {
    @required
    outputFormat: PageContentOutputFormat
}

@documentation("Response when beginning an export of page content.")
structure BeginPageContentExportResponse {
    @documentation("The identifier of this export request.")
    @required
    id: String

    @documentation("The status of this export.")
    @required
    status: String

    @documentation("The URL that reports the status of this export. Poll this URL to get the content URL when the export has completed.")
    @required
    href: String
}

@documentation("The Pack plan to show the Pack can be accessed if the workspace is at least the given tier.")
structure BundledPackPlan {
    @required
    packPlanId: String

    @required
    packId: Double

    @required
    pricing: BundledPackPlanPricing

    @documentation("Timestamp for when the Pack plan was created.")
    @required
    createdAt: String
}

@documentation("Pricing used when workspaces have access to the Pack for free if their workspace is at least the given tier.")
structure BundledPackPlanPricing {
    @required
    type: BundledPackPlanPricingType

    @required
    minimumFeatureSet: PaidFeatureSet
}

enum BundledPackPlanPricingType {
    @enumValue("BundledWithTier")
    BUNDLED_WITH_TIER
}

@documentation("Format of a button column.")
structure ButtonColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @documentation("Label formula for the button.")
    label: String

    @documentation("DisableIf formula for the button.")
    disableIf: String

    @documentation("Action formula for the button.")
    action: String
}

@documentation("Response confirming the pack review was canceled")
structure CancelPackReviewResponse {}

@documentation("An edit made to a particular cell in a row.")
structure CellEdit {
    @documentation("Column ID, URL, or name (fragile and discouraged) associated with this edit.")
    @required
    column: String

    @required
    value: Value
}

@documentation("All values that a row cell can contain.")
union CellValue {
    value: Value
    richValue: RichValue
}

@documentation("Parameters for changing a workspace user role.")
structure ChangeRole {
    @documentation("Email of the user.")
    @required
    email: String

    @required
    newRole: WorkspaceUserRole
}

@documentation("The result of changing a user's workspace user role.")
structure ChangeRoleResult {
    @documentation("Timestamp for when the user's role last changed in this workspace.")
    @required
    roleChangedAt: String
}

@documentation("Format of a checkbox column.")
structure CheckboxColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @required
    displayType: CheckboxDisplayType
}

@documentation("How a checkbox should be displayed.")
enum CheckboxDisplayType {
    @enumValue("toggle")
    TOGGLE

    @enumValue("check")
    CHECK
}

@documentation("Info about a column.")
structure Column {
    @documentation("ID of the column.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: ColumnType

    @documentation("API link to the column.")
    @required
    href: String

    @documentation("Name of the column.")
    @required
    name: String

    @documentation("Whether the column is the display column.")
    display: Boolean

    @documentation("Whether the column has a formula set on it.")
    calculated: Boolean

    @documentation("Formula on the column.")
    formula: String

    @documentation("Default value formula for the column.")
    defaultValue: String

    @required
    format: ColumnFormat
}

@documentation("Info about a column.")
structure ColumnDetail {
    @documentation("ID of the column.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: ColumnDetailType

    @documentation("API link to the column.")
    @required
    href: String

    @documentation("Name of the column.")
    @required
    name: String

    @documentation("Whether the column is the display column.")
    display: Boolean

    @documentation("Whether the column has a formula set on it.")
    calculated: Boolean

    @documentation("Formula on the column.")
    formula: String

    @documentation("Default value formula for the column.")
    defaultValue: String

    @required
    format: ColumnFormat

    @required
    parent: TableReference
}

@documentation("The type of this resource.")
enum ColumnDetailType {
    @enumValue("column")
    COLUMN
}

@documentation("Format of a column.")
union ColumnFormat {
    buttonColumnFormat: ButtonColumnFormat
    checkboxColumnFormat: CheckboxColumnFormat
    dateColumnFormat: DateColumnFormat
    dateTimeColumnFormat: DateTimeColumnFormat
    durationColumnFormat: DurationColumnFormat
    emailColumnFormat: EmailColumnFormat
    linkColumnFormat: LinkColumnFormat
    currencyColumnFormat: CurrencyColumnFormat
    imageReferenceColumnFormat: ImageReferenceColumnFormat
    numericColumnFormat: NumericColumnFormat
    referenceColumnFormat: ReferenceColumnFormat
    selectColumnFormat: SelectColumnFormat
    simpleColumnFormat: SimpleColumnFormat
    scaleColumnFormat: ScaleColumnFormat
    sliderColumnFormat: SliderColumnFormat
    timeColumnFormat: TimeColumnFormat
}

@documentation("Format type of the column")
enum ColumnFormatType {
    @enumValue("text")
    TEXT

    @enumValue("person")
    PERSON

    @enumValue("lookup")
    LOOKUP

    @enumValue("number")
    NUMBER

    @enumValue("percent")
    PERCENT

    @enumValue("currency")
    CURRENCY

    @enumValue("date")
    DATE

    @enumValue("dateTime")
    DATE_TIME

    @enumValue("time")
    TIME

    @enumValue("duration")
    DURATION

    @enumValue("email")
    EMAIL

    @enumValue("link")
    LINK

    @enumValue("slider")
    SLIDER

    @enumValue("scale")
    SCALE

    @enumValue("image")
    IMAGE

    @enumValue("imageReference")
    IMAGE_REFERENCE

    @enumValue("attachments")
    ATTACHMENTS

    @enumValue("button")
    BUTTON

    @enumValue("checkbox")
    CHECKBOX

    @enumValue("select")
    SELECT

    @enumValue("packObject")
    PACK_OBJECT

    @enumValue("reaction")
    REACTION

    @enumValue("canvas")
    CANVAS

    @enumValue("other")
    OTHER
}

@documentation("List of columns.")
structure ColumnList {
    @required
    items: ColumnListItems

    @documentation("API link to these results")
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list ColumnListItems {
    member: Column
}

@documentation("Reference to a column.")
structure ColumnReference {
    @documentation("ID of the column.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: ColumnReferenceType

    @documentation("API link to the column.")
    @required
    href: String
}

@documentation("The type of this resource.")
enum ColumnReferenceType {
    @enumValue("column")
    COLUMN
}

@documentation("The type of this resource.")
enum ColumnType {
    @enumValue("column")
    COLUMN
}

@documentation("Details about a control.")
structure Control {
    @documentation("ID of the control.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: ControlType2

    @documentation("API link to the control.")
    @required
    href: String

    @documentation("Name of the control.")
    @required
    name: String

    parent: PageReference

    @required
    controlType: ControlType

    @required
    value: Value
}

@documentation("List of controls.")
structure ControlList {
    @required
    items: ControlListItems

    @documentation("API link to these results")
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list ControlListItems {
    member: ControlReference
}

@documentation("Reference to a control.")
structure ControlReference {
    @documentation("ID of the control.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: ControlReferenceType

    @documentation("API link to the control.")
    @required
    href: String

    @documentation("Name of the control.")
    @required
    name: String

    parent: PageReference
}

@documentation("The type of this resource.")
enum ControlReferenceType {
    @enumValue("control")
    CONTROL
}

@documentation("Type of the control.")
enum ControlType {
    @enumValue("aiBlock")
    AI_BLOCK

    @enumValue("button")
    BUTTON

    @enumValue("checkbox")
    CHECKBOX

    @enumValue("datePicker")
    DATE_PICKER

    @enumValue("dateRangePicker")
    DATE_RANGE_PICKER

    @enumValue("dateTimePicker")
    DATE_TIME_PICKER

    @enumValue("lookup")
    LOOKUP

    @enumValue("multiselect")
    MULTISELECT

    @enumValue("select")
    SELECT

    @enumValue("scale")
    SCALE

    @enumValue("slider")
    SLIDER

    @enumValue("reaction")
    REACTION

    @enumValue("textbox")
    TEXTBOX

    @enumValue("timePicker")
    TIME_PICKER
}

@documentation("The type of this resource.")
enum ControlType2 {
    @enumValue("control")
    CONTROL
}

@documentation("Request for creating a folder.")
structure CreateFolderPayload {
    @documentation("Name of the folder.")
    @required
    name: String

    @documentation("ID of the workspace where the folder should be created.")
    @required
    workspaceId: String

    @documentation("Description of the folder.")
    description: String
}

@documentation("Payload for creating a Pack invitation.")
structure CreatePackInvitationPayload {
    @documentation("Email address of the user to invite")
    @required
    email: String

    @required
    access: PackAccessType
}

@documentation("Confirmation of successfully creating a Pack invitation.")
structure CreatePackInvitationResponse {
    @documentation("The ID of the invitation created.")
    @required
    invitationId: String
}

@documentation("Payload for creating a Pack.")
structure CreatePackPayload {
    @documentation("The parent workspace for the Pack. If unspecified, the user's default workspace will be used.")
    workspaceId: String

    @documentation("The name for the Pack.")
    name: String

    @documentation("A brief description of the Pack.")
    description: String

    @documentation("The ID of the new Pack's source, if this new Pack was forked.")
    sourcePackId: Double
}

@documentation("Payload for creating a new Pack release.")
structure CreatePackReleasePayload {
    @documentation("Which semantic pack version that the release will be created on.")
    @required
    packVersion: String

    @documentation("Developers notes.")
    releaseNotes: String
}

@documentation("Info about a Pack that was just created.")
structure CreatePackResponse {
    @documentation("The ID assigned to the newly-created Pack.")
    @required
    packId: Double
}

@documentation("Request to create a pack review")
structure CreatePackReviewPayload {
    @documentation("Pack version to review (for code reviews)")
    packVersion: String

    @documentation("Release notes for this version (used when pack is approved and released)")
    releaseNotes: String
}

@documentation("Response containing created review information")
structure CreatePackReviewResponse {
    @documentation("ID of the created review")
    @required
    packReviewId: String
}

@documentation("Payload for Pack version upload complete.")
structure CreatePackVersionRequest {
    @documentation("Developer notes of the new Pack version.")
    notes: String

    source: PackSource

    @documentation("Bypass Coda's protection against SDK version regression when multiple makers build versions.")
    allowOlderSdkVersion: Boolean
}

@documentation("Confirmation of successful Pack version creation.")
structure CreatePackVersionResponse {
    deprecationWarnings: CreatePackVersionResponseDeprecationWarnings
}

list CreatePackVersionResponseDeprecationWarnings {
    member: ValidationError
}

@documentation("A numeric monetary amount as a string or number.")
union CurrencyAmount {
    variant1: String
    variant2: Double
}

@documentation("Format of a currency column.")
structure CurrencyColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @documentation("The currency symbol")
    currencyCode: String

    @documentation("The decimal precision.")
    precision: Integer

    format: CurrencyFormatType
}

@documentation("How the numeric value should be formatted (with or without symbol, negative numbers in parens).")
enum CurrencyFormatType {
    @enumValue("currency")
    CURRENCY

    @enumValue("accounting")
    ACCOUNTING

    @enumValue("financial")
    FINANCIAL
}

@documentation("A monetary value with its associated currency code.")
structure CurrencyValue {
    @documentation("A url describing the schema context for this object, typically \"http://schema.org/\".")
    @required
    @jsonName("@context")
    context: String

    @required
    @jsonName("@type")
    type: CurrencyValueType

    @documentation("An identifier of additional type info specific to Coda that may not be present in a schema.org taxonomy,")
    additionalType: String

    @documentation("The 3-letter currency code.")
    @required
    currency: String

    @required
    amount: CurrencyAmount
}

enum CurrencyValueType {
    @enumValue("MonetaryAmount")
    MONETARY_AMOUNT
}

@documentation("The custom domain added to a published doc.")
structure CustomDocDomain {
    @documentation("The custom domain.")
    @required
    customDocDomain: String

    @documentation("Whether the domain has a certificate")
    @required
    hasCertificate: Boolean

    @documentation("Whether the domain DNS points back to this doc.")
    @required
    hasDnsDocId: Boolean

    @required
    setupStatus: CustomDocDomainSetupStatus

    @required
    domainStatus: CustomDomainConnectedStatus

    @documentation("When the domain DNS settings were last checked.")
    lastVerifiedTimestamp: String
}

@documentation("List of all custom domains added to a published doc.")
structure CustomDocDomainList {
    @documentation("Custom domains for the published doc.")
    @required
    customDocDomains: CustomDocDomainListCustomDocDomains

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

@documentation("Custom domains for the published doc.")
list CustomDocDomainListCustomDocDomains {
    member: CustomDocDomain
}

enum CustomDocDomainProvider {
    @enumValue("GoDaddy")
    GO_DADDY

    @enumValue("Namecheap")
    NAMECHEAP

    @enumValue("Hover (Tucows)")
    HOVER_TUCOWS

    @enumValue("Network Solutions")
    NETWORK_SOLUTIONS

    @enumValue("Google Domains")
    GOOGLE_DOMAINS

    @enumValue("Other")
    OTHER
}

@documentation("The result of determining the domain provider for a custom doc domain.")
structure CustomDocDomainProviderResponse {
    @required
    provider: CustomDocDomainProvider
}

enum CustomDocDomainSetupStatus {
    @enumValue("pending")
    PENDING

    @enumValue("succeeded")
    SUCCEEDED

    @enumValue("failed")
    FAILED
}

enum CustomDomainConnectedStatus {
    @enumValue("connected")
    CONNECTED

    @enumValue("notConnected")
    NOT_CONNECTED
}

@documentation("Format of a date column.")
structure DateColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @documentation("A format string using Moment syntax: https://momentjs.com/docs/#/displaying/")
    format: String
}

@documentation("Format of a date column.")
structure DateTimeColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @documentation("A format string using Moment syntax: https://momentjs.com/docs/#/displaying/")
    dateFormat: String

    @documentation("A format string using Moment syntax: https://momentjs.com/docs/#/displaying/")
    timeFormat: String
}

@documentation("The result of deleting a custom domain from a published doc.")
structure DeleteCustomDocDomainResponse {}

@documentation("The result of a folder deletion.")
structure DeleteFolderResult {}

@documentation("Confirmation of successfully deleting a Pack category.")
structure DeletePackCategoryResponse {}

@documentation("Confirmation of successfully deleting a Pack invitation.")
structure DeletePackInvitationResponse {}

@documentation("Response after deleting a Pack listing draft")
structure DeletePackListingDraftResponse {}

@documentation("Confirmation of successfully deleting a Pack permission.")
structure DeletePackPermissionResponse {}

@documentation("Confirmation of successful Pack deletion.")
structure DeletePackResponse {}

@documentation("The result of deleting a permission.")
structure DeletePermissionResult {}

@documentation("Confirmation of successfully deleting a user's permissions for a Pack.")
structure DeleteUserPackPermissionsResponse {}

@documentation("Metadata about a Coda doc.")
structure Doc {
    @documentation("ID of the Coda doc.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: DocType

    @documentation("API link to the Coda doc.")
    @required
    href: String

    @documentation("Browser-friendly link to the Coda doc.")
    @required
    browserLink: String

    icon: Icon

    @documentation("Name of the doc.")
    @required
    name: String

    @documentation("Email address of the doc owner.")
    @required
    owner: String

    @documentation("Name of the doc owner.")
    @required
    ownerName: String

    docSize: DocSize

    sourceDoc: DocReference

    @documentation("Timestamp for when the doc was created.")
    @required
    createdAt: String

    @documentation("Timestamp for when the doc was last modified.")
    @required
    updatedAt: String

    published: DocPublished

    @required
    folder: FolderReference

    @required
    workspace: WorkspaceReference

    @documentation("ID of the Coda workspace containing this doc.")
    @required
    workspaceId: String

    @documentation("ID of the Coda folder containing this doc.")
    @required
    folderId: String

    @documentation("An arbitrary unique identifier for this request, included on doc creation responses.")
    requestId: String
}

@documentation("List of analytics for Coda docs over a date range.")
structure DocAnalyticsCollection {
    @required
    items: DocAnalyticsCollectionItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list DocAnalyticsCollectionItems {
    member: DocAnalyticsItem
}

structure DocAnalyticsDetails {
    @documentation("ID of the Coda doc.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: DocAnalyticsDetailsType

    @documentation("API link to the Coda doc.")
    @required
    href: String

    @documentation("Browser-friendly link to the Coda doc.")
    @required
    browserLink: String

    @documentation("The name of the doc.")
    @required
    title: String

    icon: Icon

    @documentation("Creation time of the doc.")
    @required
    createdAt: String

    @documentation("Published time of the doc.")
    publishedAt: String
}

@documentation("The type of this resource.")
enum DocAnalyticsDetailsType {
    @enumValue("doc")
    DOC
}

@documentation("Analytics data for a Coda doc.")
structure DocAnalyticsItem {
    @required
    doc: DocAnalyticsDetails

    @required
    metrics: DocAnalyticsItemMetrics
}

list DocAnalyticsItemMetrics {
    member: DocAnalyticsMetrics
}

@documentation("Analytics metrics for a Coda Doc.")
structure DocAnalyticsMetrics {
    @documentation("Date of the analytics data.")
    @required
    date: String

    @documentation("Number of times the doc was viewed.")
    @required
    views: Integer

    @documentation("Number of times the doc was copied.")
    @required
    copies: Integer

    @documentation("Number of times the doc was liked.")
    @required
    likes: Integer

    @documentation("Number of unique visitors to this doc from a mobile device.")
    @required
    sessionsMobile: Integer

    @documentation("Number of unique visitors to this doc from a desktop device.")
    @required
    sessionsDesktop: Integer

    @documentation("Number of unique visitors to this doc from an unknown device type.")
    @required
    sessionsOther: Integer

    @documentation("Sum of the total sessions from any device.")
    @required
    totalSessions: Integer

    @documentation("Number of credits used for AI chat.")
    aiCreditsChat: Integer

    @documentation("Number of credits used for AI block.")
    aiCreditsBlock: Integer

    @documentation("Number of credits used for AI column.")
    aiCreditsColumn: Integer

    @documentation("Number of credits used for AI assistant.")
    aiCreditsAssistant: Integer

    @documentation("Number of credits used for AI reviewer.")
    aiCreditsReviewer: Integer

    @documentation("Total number of AI credits used.")
    aiCredits: Integer
}

@documentation("Determines how the Doc analytics returned are sorted.")
enum DocAnalyticsOrderBy {
    @enumValue("date")
    DATE

    @enumValue("docId")
    DOC_ID

    @enumValue("title")
    TITLE

    @enumValue("createdAt")
    CREATED_AT

    @enumValue("publishedAt")
    PUBLISHED_AT

    @enumValue("likes")
    LIKES

    @enumValue("copies")
    COPIES

    @enumValue("views")
    VIEWS

    @enumValue("sessionsDesktop")
    SESSIONS_DESKTOP

    @enumValue("sessionsMobile")
    SESSIONS_MOBILE

    @enumValue("sessionsOther")
    SESSIONS_OTHER

    @enumValue("totalSessions")
    TOTAL_SESSIONS

    @enumValue("aiCreditsChat")
    AI_CREDITS_CHAT

    @enumValue("aiCreditsBlock")
    AI_CREDITS_BLOCK

    @enumValue("aiCreditsColumn")
    AI_CREDITS_COLUMN

    @enumValue("aiCreditsAssistant")
    AI_CREDITS_ASSISTANT

    @enumValue("aiCreditsReviewer")
    AI_CREDITS_REVIEWER

    @enumValue("aiCredits")
    AI_CREDITS
}

@documentation("Summarized metrics for Coda docs.")
structure DocAnalyticsSummary {
    @documentation("Total number of sessions across all docs.")
    @required
    totalSessions: Integer
}

@documentation("The category applied to a doc.")
structure DocCategory {
    @documentation("Name of the category.")
    @required
    name: String
}

@documentation("A list of categories that can be applied to a doc.")
structure DocCategoryList {
    @documentation("Categories for the doc.")
    @required
    items: DocCategoryListItems
}

@documentation("Categories for the doc.")
list DocCategoryListItems {
    member: DocCategory
}

@documentation("Payload for creating a new doc.")
structure DocCreate {
    @documentation("Title of the new doc. Defaults to 'Untitled'.")
    title: String

    @documentation("An optional doc ID from which to create a copy.")
    sourceDoc: String

    @documentation("The timezone to use for the newly created doc.")
    timezone: String

    @documentation("The ID of the folder within which to create this doc. Defaults to your \"My docs\" folder in the oldest workspace you joined; this is subject to change. You can get this ID by opening the folder in the docs list on your computer and grabbing the `folderId` query parameter.")
    folderId: String

    initialPage: PageCreate
}

@documentation("The result of a doc deletion.")
structure DocDelete {}

@documentation("List of Coda docs.")
structure DocList {
    @required
    items: DocListItems

    @documentation("API link to these results")
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list DocListItems {
    member: Doc
}

@documentation("Payload for publishing a doc or or updating its publishing information.")
structure DocPublish {
    @documentation("Slug for the published doc.")
    slug: String

    @documentation("If true, indicates that the doc is discoverable.")
    discoverable: Boolean

    @documentation("If true, new users may be required to sign in to view content within this document. You will receive Coda credit for each user who signs up via your doc.")
    earnCredit: Boolean

    @documentation("The names of categories to apply to the document.")
    categoryNames: DocPublishCategoryNames

    mode: DocPublishMode
}

@documentation("The names of categories to apply to the document.")
list DocPublishCategoryNames {
    member: String
}

@documentation("Which interaction mode the published doc should use.")
enum DocPublishMode {
    @enumValue("view")
    VIEW

    @enumValue("play")
    PLAY

    @enumValue("edit")
    EDIT
}

@documentation("Information about the publishing state of the document.")
structure DocPublished {
    @documentation("Description of the published doc.")
    description: String

    @documentation("URL to the published doc.")
    @required
    browserLink: String

    @documentation("URL to the cover image for the published doc.")
    imageLink: String

    @documentation("If true, indicates that the doc is discoverable.")
    @required
    discoverable: Boolean

    @documentation("If true, new users may be required to sign in to view content within this document. You will receive Coda credit for each user who signs up via your doc.")
    @required
    earnCredit: Boolean

    @required
    mode: DocPublishMode

    @documentation("Categories applied to the doc.")
    @required
    categories: DocPublishedCategories
}

@documentation("Categories applied to the doc.")
list DocPublishedCategories {
    member: DocCategory
}

@documentation("Reference to a Coda doc.")
structure DocReference {
    @documentation("ID of the Coda doc.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: DocReferenceType

    @documentation("API link to the Coda doc.")
    @required
    href: String

    @documentation("Browser-friendly link to the Coda doc.")
    @required
    browserLink: String
}

@documentation("The type of this resource.")
enum DocReferenceType {
    @enumValue("doc")
    DOC
}

@documentation("The number of components within a Coda doc.")
structure DocSize {
    @documentation("The number of rows contained within all tables of the doc.")
    @required
    totalRowCount: Double

    @documentation("The total number of tables and views contained within the doc.")
    @required
    tableAndViewCount: Double

    @documentation("The total number of page contained within the doc.")
    @required
    pageCount: Double

    @documentation("If true, indicates that the doc is over the API size limit.")
    @required
    overApiSizeLimit: Boolean
}

@documentation("The type of this resource.")
enum DocType {
    @enumValue("doc")
    DOC
}

@documentation("Payload for updating a doc.")
structure DocUpdate {
    @documentation("Title of the doc.")
    title: String

    @documentation("Name of the icon.")
    iconName: String
}

@documentation("The result of a doc update")
structure DocUpdate2 {}

@documentation("Base response type for an operation that mutates a document.")
structure DocumentMutateResponse {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String
}

structure DomainPrincipal {
    @documentation("The type of this principal.")
    @required
    type: DomainPrincipalType

    @documentation("Domain for the principal.")
    @required
    domain: String
}

@documentation("The type of this principal.")
enum DomainPrincipalType {
    @enumValue("domain")
    DOMAIN
}

@documentation("Format of a duration column.")
structure DurationColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    precision: Integer

    maxUnit: DurationUnit
}

@documentation("A time unit used as part of a duration value.")
enum DurationUnit {
    @enumValue("days")
    DAYS

    @enumValue("hours")
    HOURS

    @enumValue("minutes")
    MINUTES

    @enumValue("seconds")
    SECONDS
}

@documentation("Format of an email column.")
structure EmailColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    display: EmailDisplayType

    autocomplete: Boolean
}

@documentation("How an email address should be displayed in the user interface.")
enum EmailDisplayType {
    @enumValue("iconAndEmail")
    ICON_AND_EMAIL

    @enumValue("iconOnly")
    ICON_ONLY

    @enumValue("emailOnly")
    EMAIL_ONLY
}

structure EmailPrincipal {
    @documentation("The type of this principal.")
    @required
    type: EmailPrincipalType

    @documentation("Email for the principal.")
    @required
    email: String
}

@documentation("The type of this principal.")
enum EmailPrincipalType {
    @enumValue("email")
    EMAIL
}

@documentation("Only relevant for original Coda packs.")
enum FeatureSet {
    @enumValue("Basic")
    BASIC

    @enumValue("Pro")
    PRO

    @enumValue("Team")
    TEAM

    @enumValue("Enterprise")
    ENTERPRISE
}

@documentation("Status of featured doc in pack listing.")
enum FeaturedDocStatus {
    @enumValue("docInaccessibleOrDoesNotExist")
    DOC_INACCESSIBLE_OR_DOES_NOT_EXIST

    @enumValue("invalidPublishedDocUrl")
    INVALID_PUBLISHED_DOC_URL
}

@documentation("A Coda folder.")
structure Folder {
    @documentation("ID of the Coda folder.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: FolderType

    @documentation("The name of the folder.")
    @required
    name: String

    @documentation("Browser-friendly link to the folder.")
    @required
    browserLink: String

    @documentation("The description of the folder.")
    description: String

    icon: Icon

    @documentation("Timestamp for when the folder was created.")
    createdAt: String

    @documentation("Whether the folder settings can be edited. E.g., some folder types (like personal folders - \"My Docs\") cannot be edited.")
    canEdit: Boolean

    @required
    workspace: WorkspaceReference
}

@documentation("List of folders.")
structure FolderList {
    @required
    items: FolderListItems

    @documentation("API link to these results.")
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list FolderListItems {
    member: Folder
}

@documentation("Reference to a Coda folder.")
structure FolderReference {
    @documentation("ID of the Coda folder.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: FolderReferenceType

    @documentation("Browser-friendly link to the folder.")
    @required
    browserLink: String

    @documentation("Name of the folder; included if the user has access to the folder.")
    name: String
}

@documentation("The type of this resource.")
enum FolderReferenceType {
    @enumValue("folder")
    FOLDER
}

@documentation("The type of this resource.")
enum FolderType {
    @enumValue("folder")
    FOLDER
}

@documentation("Details about a formula.")
structure Formula {
    @documentation("ID of the formula.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: FormulaType

    @documentation("API link to the formula.")
    @required
    href: String

    @documentation("Name of the formula.")
    @required
    name: String

    parent: PageReference

    @required
    value: Value
}

@documentation("Detailed information about a formula.")
structure FormulaDetail {
    @documentation("Returns whether or not the given formula is valid.")
    @required
    valid: Boolean

    @documentation("Returns whether or not the given formula can return different results in different contexts (for example, for different users).")
    isVolatile: Boolean

    @documentation("Returns whether or not the given formula has a User() formula within it.")
    hasUserFormula: Boolean

    @documentation("Returns whether or not the given formula has a Today() formula within it.")
    hasTodayFormula: Boolean

    @documentation("Returns whether or not the given formula has a Now() formula within it.")
    hasNowFormula: Boolean
}

@documentation("List of formulas.")
structure FormulaList {
    @required
    items: FormulaListItems

    @documentation("API link to these results")
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list FormulaListItems {
    member: FormulaReference
}

@documentation("Reference to a formula.")
structure FormulaReference {
    @documentation("ID of the formula.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: FormulaReferenceType

    @documentation("API link to the formula.")
    @required
    href: String

    @documentation("Name of the formula.")
    @required
    name: String

    parent: PageReference
}

@documentation("The type of this resource.")
enum FormulaReferenceType {
    @enumValue("formula")
    FORMULA
}

@documentation("The type of this resource.")
enum FormulaType {
    @enumValue("formula")
    FORMULA
}

@documentation("Pricing used when workspaces can subscribe to the Pack for free.")
structure FreePackPlanPricing {
    @required
    type: FreePackPlanPricingType
}

enum FreePackPlanPricingType {
    @enumValue("Free")
    FREE
}

@documentation("Payload for getting the next version of a Pack.")
structure GetNextPackVersionPayload {
    @documentation("The metadata for the next version of the Pack.")
    @required
    proposedMetadata: String

    @documentation("The SDK version the metadata was built on.")
    sdkVersion: String
}

@documentation("JSON schema response.")
structure GetPackConfigurationJsonSchemaResponse {}

@documentation("Response containing the Pack listing draft")
structure GetPackListingDraftResponse {
    @documentation("ID of the listing draft")
    packListingDraftId: String

    listingData: PackListingDraftData
}

@documentation("Response for getting workspace role activity.")
structure GetWorkspaceRoleActivity {
    @required
    items: GetWorkspaceRoleActivityItems
}

list GetWorkspaceRoleActivityItems {
    member: WorkspaceRoleActivity
}

structure GroupPrincipal {
    @documentation("The type of this principal.")
    @required
    type: GroupPrincipalType

    @documentation("Group ID for the principal.")
    @required
    groupId: String

    @documentation("Name of the group.")
    @required
    groupName: String
}

@documentation("The type of this principal.")
enum GroupPrincipalType {
    @enumValue("group")
    GROUP
}

@documentation("Grouped logs of the Pack's auth requests.")
structure GroupedPackAuthLog {
    @required
    type: GroupedPackAuthLogType

    @required
    authLog: PackAuthLog

    @required
    relatedLogs: GroupedPackAuthLogRelatedLogs
}

list GroupedPackAuthLogRelatedLogs {
    member: PackLog
}

enum GroupedPackAuthLogType {
    @enumValue("auth")
    AUTH
}

@documentation("Grouped logs of the invocations of the Pack.")
structure GroupedPackInvocationLog {
    @required
    type: GroupedPackInvocationLogType

    @required
    invocationLog: PackInvocationLog

    @required
    relatedLogs: GroupedPackInvocationLogRelatedLogs
}

list GroupedPackInvocationLogRelatedLogs {
    member: PackLog
}

enum GroupedPackInvocationLogType {
    @enumValue("invocation")
    INVOCATION
}

@documentation("A record of grouped Pack log.")
union GroupedPackLog {
    groupedPackInvocationLog: GroupedPackInvocationLog
    groupedPackAuthLog: GroupedPackAuthLog
}

@documentation("List of grouped Pack logs.")
structure GroupedPackLogsList {
    @required
    items: GroupedPackLogsListItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink

    @documentation("This flag will be set to true if the result doens't include all the related logs.")
    @required
    incompleteRelatedLogs: Boolean
}

list GroupedPackLogsListItems {
    member: GroupedPackLog
}

@documentation("Payload for handling a Pack invitation (accept or reject).")
structure HandlePackInvitationRequest {
    @documentation("True to accept the invitation, false to reject it")
    @required
    accept: Boolean
}

@documentation("Confirmation of successfully handling a Pack invitation.")
structure HandlePackInvitationResponse {
    @documentation("The ID of the permission that was created. Only returned when accepting the invitation.")
    permissionId: String
}

@documentation("Info about the icon.")
structure Icon {
    @documentation("Name of the icon.")
    @required
    name: String

    @documentation("MIME type of the icon")
    @required
    type: String

    @documentation("Browser-friendly link to an icon.")
    @required
    browserLink: String
}

@documentation("List of available icon sets.")
enum IconSet {
    @enumValue("star")
    STAR

    @enumValue("circle")
    CIRCLE

    @enumValue("fire")
    FIRE

    @enumValue("bug")
    BUG

    @enumValue("diamond")
    DIAMOND

    @enumValue("bell")
    BELL

    @enumValue("thumbsup")
    THUMBSUP

    @enumValue("heart")
    HEART

    @enumValue("chili")
    CHILI

    @enumValue("smiley")
    SMILEY

    @enumValue("lightning")
    LIGHTNING

    @enumValue("currency")
    CURRENCY

    @enumValue("coffee")
    COFFEE

    @enumValue("person")
    PERSON

    @enumValue("battery")
    BATTERY

    @enumValue("cocktail")
    COCKTAIL

    @enumValue("cloud")
    CLOUD

    @enumValue("sun")
    SUN

    @enumValue("checkmark")
    CHECKMARK

    @enumValue("lightbulb")
    LIGHTBULB
}

@documentation("Info about the image.")
structure Image {
    @documentation("Browser-friendly link to an image.")
    @required
    browserLink: String

    @documentation("MIME type of the image.")
    type: String

    @documentation("The width in pixels of the image.")
    width: Double

    @documentation("The height in pixels of the image.")
    height: Double
}

@documentation("Information about an image file for an update Pack request.")
structure ImageFileForUpdatePackRequest {
    @documentation("The asset id of the Pack's image, returned by [`#PackAssetUploadComplete`](#operation/packAssetUploadComplete) endpoint.")
    @required
    assetId: String

    @documentation("The filename for the image.")
    @required
    filename: String

    @documentation("The media type of the image being sent.")
    mimeType: String
}

@documentation("Format of an image reference column.")
structure ImageReferenceColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @required
    width: NumberOrNumberFormula

    @required
    height: NumberOrNumberFormula

    @required
    style: ImageShapeStyle
}

@documentation("How an image should be displayed.")
enum ImageShapeStyle {
    @enumValue("auto")
    AUTO

    @enumValue("circle")
    CIRCLE
}

@documentation("The status values that an image object can have.")
enum ImageStatus {
    @enumValue("live")
    LIVE

    @enumValue("deleted")
    DELETED

    @enumValue("failed")
    FAILED
}

@documentation("A named url of an image along with metadata.")
structure ImageUrlValue {
    @documentation("A url describing the schema context for this object, typically \"http://schema.org/\".")
    @required
    @jsonName("@context")
    context: String

    @required
    @jsonName("@type")
    type: ImageUrlValueType

    @documentation("An identifier of additional type info specific to Coda that may not be present in a schema.org taxonomy,")
    additionalType: String

    @documentation("The name of the image.")
    name: String

    @documentation("The url of the image.")
    url: String

    @documentation("The height of the image in pixels.")
    height: Double

    @documentation("The width of the image in pixels.")
    width: Double

    status: ImageStatus
}

enum ImageUrlValueType {
    @enumValue("ImageObject")
    IMAGE_OBJECT
}

@documentation("An ingestion batch execution.")
structure IngestionBatchExecution {
    @documentation("Completion time of the ingestion batch execution in seconds since epoch.")
    @required
    completionTimestamp: Double

    @documentation("Creation time of the ingestion batch execution in seconds since epoch.")
    @required
    creationTimestamp: Double

    @documentation("The label of the dynamic URL of the ingestion, if any.")
    dynamicLabel: String

    @documentation("The dynamic URL of the ingestion.")
    dynamicUrl: String

    @required
    executionType: IngestionExecutionType

    @documentation("The ID of the full ingestion execution.")
    @required
    fullExecutionId: String

    @documentation("The ID of the ingestion batch execution.")
    @required
    ingestionExecutionId: String

    @documentation("The ID of the ingestion.")
    @required
    ingestionId: String

    @documentation("The name of the ingestion.")
    @required
    ingestionName: String

    @documentation("Histogram of IngestionStatus of child executions (even if there's only 1, non-crawled execution) as enum values.")
    ingestionStatusCounts: IngestionBatchExecutionIngestionStatusCounts

    @documentation("The ID of the last full workflow execution that finished.")
    lastFinishedFullWorkflowExecutionId: String

    @documentation("The ID of the last incremental workflow execution that finished.")
    lastFinishedIncrementalWorkflowExecutionId: String

    @documentation("The ID of the latest full workflow execution.")
    latestFullWorkflowExecutionId: String

    @documentation("The ID of the latest incremental workflow execution.")
    latestIncrementalWorkflowExecutionId: String

    @documentation("The ID of the latest full execution.")
    latestIngestionSequenceId: String

    @documentation("The ID of the full execution that generated the currently live data.")
    liveIngestionSequenceId: String

    @documentation("The ID of the parent sync tableingestion, if any.")
    parentSyncTableIngestionId: String

    @documentation("Start time of the ingestion batch execution in seconds since epoch.")
    @required
    startTimestamp: Double

    @documentation("The total number of rows processed in the ingestion batch execution.")
    totalRowCount: Double
}

map IngestionBatchExecutionIngestionStatusCounts {
    key: String
    value: Integer
}

@documentation("List of Ingestion Batch Executions.")
structure IngestionBatchExecutionsList {
    @required
    items: IngestionBatchExecutionsListItems

    nextPageToken: NextPageToken
}

list IngestionBatchExecutionsListItems {
    member: IngestionBatchExecution
}

@documentation("Type of an ingestion childexecution.")
enum IngestionChildExecutionType {
    @enumValue("FULL")
    FULL

    @enumValue("INCREMENTAL")
    INCREMENTAL

    @enumValue("PATCH")
    PATCH
}

@documentation("An attempt of an ingestion execution.")
structure IngestionExecutionAttempt {
    @documentation("The ID of the ingestion execution.")
    @required
    csbIngestionExecutionId: String

    @documentation("The attempt number of the ingestion execution attempt.")
    @required
    attemptNumber: Double

    ingestionStatus: IngestionStatus

    @documentation("The start time of the ingestion execution attempt in seconds since epoch.")
    @required
    startTimestamp: Double

    @documentation("The completion time of the ingestion execution attempt in seconds since epoch.")
    @required
    completionTimestamp: Double

    @documentation("The error message of the ingestion execution attempt.")
    @required
    errorMessage: String

    @documentation("The total number of rows processed in the ingestion execution attempt.")
    rowCountInAttempt: String

    @documentation("The timestamp of the latest checkpoint of the ingestion execution attempt.")
    latestCheckpointTimestamp: Double
}

@documentation("List of Ingestion Execution Attempts.")
structure IngestionExecutionAttemptsList {
    @required
    items: IngestionExecutionAttemptsListItems

    nextPageToken: NextPageToken
}

list IngestionExecutionAttemptsListItems {
    member: IngestionExecutionAttempt
}

@documentation("Context that comes with a ingestion execution.")
structure IngestionExecutionContext {
    @required
    ingestionName: String

    @required
    csbIngestionId: String

    @required
    csbIngestionExecutionId: String

    @documentation("Creation time of the ingestion execution in seconds since epoch.")
    @required
    creationTimestamp: Double

    @required
    parentItemId: String

    @documentation("Start time of the ingestion execution in seconds since epoch.")
    @required
    startTimestamp: Double

    @documentation("Completion time of the ingestion execution in seconds since epoch.")
    @required
    completionTimestamp: Double

    @documentation("Next eligible time for the ingestion to run in seconds since epoch.")
    @required
    nextEligibleTimestamp: Double

    @documentation("Next eligible time for the ingestion to run incrementally in seconds since epoch.")
    @required
    nextEligibleIncrementalTimestamp: Double

    @documentation("The attempt number of the ingestion execution.")
    @required
    attemptNumber: Double

    @required
    ingestionStatus: IngestionStatus

    @required
    executionType: IngestionExecutionType

    @required
    errorMessage: String

    @documentation("The total number of rows processed in the ingestion execution.")
    totalRowCount: String

    @documentation("The timestamp of the latest checkpoint of the ingestion execution.")
    latestCheckpointTimestamp: Double
}

@documentation("Type of an ingestion batch execution.")
enum IngestionExecutionType {
    @enumValue("FULL")
    FULL

    @enumValue("INCREMENTAL")
    INCREMENTAL
}

@documentation("List of Ingestion Executions.")
structure IngestionExecutionsList {
    @required
    items: IngestionExecutionsListItems

    nextPageToken: NextPageToken
}

list IngestionExecutionsListItems {
    member: IngestionExecutionContext
}

@documentation("Limits for a pack-driven ingestion")
structure IngestionLimitSettings {
    @documentation("Map from table name to per table settings. This may not include every table in the pack. Each setting per table will include an optional maxBytesPerSyncTableOverride that will override the default, an optional excludeIngestionByDefault flag, and an optional parameterLimits dictionary of allowed parameter values.")
    tableSettings: IngestionLimitSettingsTableSettings

    @documentation("The default bytes limit when ingesting data for a table in the pack. null means no limit.")
    @required
    maxBytesPerSyncTableDefault: Double

    @documentation("The maximum number of tables that can be included. -1 means no limit.")
    @required
    allowedTablesCount: Double
}

map IngestionLimitSettingsTableSettings {
    key: String
    value: IngestionTableSetting
}

@documentation("Live or Latest version of pack")
enum IngestionPackReleaseChannel {
    @enumValue("LIVE")
    LIVE

    @enumValue("LATEST")
    LATEST
}

@documentation("An ingestion parent item and its execution state (either full or incremental).")
structure IngestionParentItem {
    @documentation("The attempt number of the ingestion child execution.")
    attemptNumber: Double

    @documentation("Completion time of the ingestion child execution in seconds since epoch.")
    @required
    completionTimestamp: Double

    @required
    errorMessage: String

    @required
    executionType: IngestionChildExecutionType

    @documentation("Current execution index for this parent item's child execution.")
    ingestionChildExecutionIndex: Double

    @documentation("The ID of the ingestion child execution.")
    @required
    ingestionExecutionId: String

    @documentation("The name of the ingestion child execution.")
    @required
    ingestionName: String

    ingestionStatus: IngestionStatus

    @documentation("The ID of the parent item.")
    @required
    parentItemId: String

    @documentation("Start time of the ingestion child execution in seconds since epoch.")
    @required
    startTimestamp: Double

    @documentation("The number of rows processed so far in the current ingestion child execution.")
    rowCount: Double

    @documentation("The timestamp of the latest checkpoint of the ingestion child execution.")
    latestCheckpointTimestamp: Double
}

@documentation("List of Ingestion Parent Items.")
structure IngestionParentItemsList {
    @required
    items: IngestionParentItemsListItems

    nextPageToken: NextPageToken
}

list IngestionParentItemsListItems {
    member: IngestionParentItem
}

@documentation("Status of the ingestion execution.")
enum IngestionStatus {
    @enumValue("QUEUED")
    QUEUED

    @enumValue("STARTED")
    STARTED

    @enumValue("CANCELLED")
    CANCELLED

    @enumValue("UP_FOR_RETRY")
    UP_FOR_RETRY

    @enumValue("COMPLETED")
    COMPLETED

    @enumValue("FAILED")
    FAILED
}

@documentation("Ingestion settings for a specific table")
structure IngestionTableSetting {
    @documentation("The bytes limit when ingesting data for this table. null means no limit.")
    maxBytesPerSyncTableOverride: Double

    @documentation("Whether to exclude this table from ingestions by default.")
    excludeIngestionByDefault: Boolean

    @documentation("Limits for allowed parameter values.")
    parameterLimits: IngestionTableSettingParameterLimits
}

map IngestionTableSettingParameterLimits {
    key: String
    value: ParameterSetting
}

structure InternalAccessPrincipal {
    @documentation("The type of this principal.")
    @required
    type: InternalAccessPrincipalType

    @documentation("The type of internal access (e.g., support).")
    @required
    internalAccessType: String
}

@documentation("The type of this principal.")
enum InternalAccessPrincipalType {
    @enumValue("internalAccess")
    INTERNAL_ACCESS
}

@documentation("Layout type of the table or view.")
enum Layout {
    @enumValue("default")
    DEFAULT

    @enumValue("areaChart")
    AREA_CHART

    @enumValue("barChart")
    BAR_CHART

    @enumValue("bubbleChart")
    BUBBLE_CHART

    @enumValue("calendar")
    CALENDAR

    @enumValue("card")
    CARD

    @enumValue("detail")
    DETAIL

    @enumValue("form")
    FORM

    @enumValue("ganttChart")
    GANTT_CHART

    @enumValue("lineChart")
    LINE_CHART

    @enumValue("masterDetail")
    MASTER_DETAIL

    @enumValue("pieChart")
    PIE_CHART

    @enumValue("scatterChart")
    SCATTER_CHART

    @enumValue("slide")
    SLIDE

    @enumValue("wordCloud")
    WORD_CLOUD
}

@documentation("Format of a link column.")
structure LinkColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    display: LinkDisplayType

    @documentation("Force embeds to render on the client instead of the server (for sites that require user login).")
    force: Boolean
}

@documentation("How a link should be displayed in the user interface.")
enum LinkDisplayType {
    @enumValue("iconOnly")
    ICON_ONLY

    @enumValue("url")
    URL

    @enumValue("title")
    TITLE

    @enumValue("card")
    CARD

    @enumValue("embed")
    EMBED
}

@documentation("Base type for a JSON-LD (Linked Data) object.")
structure LinkedDataObject {
    @documentation("A url describing the schema context for this object, typically \"http://schema.org/\".")
    @required
    @jsonName("@context")
    context: String

    @required
    @jsonName("@type")
    type: LinkedDataType

    @documentation("An identifier of additional type info specific to Coda that may not be present in a schema.org taxonomy,")
    additionalType: String
}

@documentation("A schema.org identifier for the object.")
enum LinkedDataType {
    @enumValue("ImageObject")
    IMAGE_OBJECT

    @enumValue("MonetaryAmount")
    MONETARY_AMOUNT

    @enumValue("Person")
    PERSON

    @enumValue("WebPage")
    WEB_PAGE

    @enumValue("StructuredValue")
    STRUCTURED_VALUE
}

@documentation("Confirmation of successfully retrieving Pack categories.")
structure ListPackCategoriesResponse {
    @documentation("The names of categories associated with a Pack.")
    @required
    categories: ListPackCategoriesResponseCategories
}

@documentation("The names of categories associated with a Pack.")
list ListPackCategoriesResponseCategories {
    member: PublishingCategory
}

@documentation("Confirmation of successfully retrieving Pack makers.")
structure ListPackMakersResponse {
    @required
    makers: ListPackMakersResponseMakers
}

list ListPackMakersResponseMakers {
    member: Maker
}

@documentation("Response containing pack reviews")
structure ListPackReviewsResponse {
    @documentation("List of pack reviews")
    @required
    items: ListPackReviewsResponseItems

    @documentation("Token for fetching the next page of results")
    nextPageToken: String

    @documentation("Link for fetching the next page of results")
    nextPageLink: String
}

@documentation("List of pack reviews")
list ListPackReviewsResponseItems {
    member: PackReview
}

enum LogLevel {
    @enumValue("error")
    ERROR

    @enumValue("warn")
    WARN

    @enumValue("info")
    INFO

    @enumValue("debug")
    DEBUG

    @enumValue("trace")
    TRACE

    @enumValue("unknown")
    UNKNOWN
}

@documentation("Info about the maker")
structure Maker {
    @documentation("Name of the maker.")
    @required
    name: String

    @documentation("Browser-friendly link to the maker's avatar image.")
    pictureLink: String

    @documentation("Maker profile identifier for the maker.")
    slug: String

    @documentation("Job title for maker.")
    jobTitle: String

    @documentation("Employer for maker.")
    employer: String

    @documentation("Description for the maker.")
    description: String

    @documentation("Email address of the user.")
    @required
    loginId: String
}

@documentation("Summary about a maker")
structure MakerSummary {
    @documentation("Name of the maker.")
    @required
    name: String

    @documentation("Browser-friendly link to the maker's avatar image.")
    pictureLink: String

    @documentation("Maker profile identifier for the maker.")
    slug: String

    @documentation("Job title for maker.")
    jobTitle: String

    @documentation("Employer for maker.")
    employer: String

    @documentation("Description for the maker.")
    description: String
}

@documentation("Pricing used when workspaces can subscribe to the Pack for a monthly cost per Doc Maker.")
structure MonthlyDocMakerPackPlanPricing {
    @required
    type: MonthlyDocMakerPackPlanPricingType

    @documentation("The monthly cost of the Pack per Doc Maker.")
    @required
    amount: Double

    @required
    currency: PackPlanCurrency
}

enum MonthlyDocMakerPackPlanPricingType {
    @enumValue("MonthlyDocMaker")
    MONTHLY_DOC_MAKER
}

@documentation("The status of an asynchronous mutation.")
structure MutationStatus {
    @documentation("Returns whether the mutation has completed.")
    @required
    completed: Boolean

    @documentation("A warning if the mutation completed but with caveats.")
    warning: String
}

@documentation("Information indicating the next Pack version definition.")
structure NextPackVersionInfo {
    @documentation("The next valid version for the Pack.")
    @required
    nextVersion: String

    @documentation("List of changes from the previous version.")
    @required
    findings: NextPackVersionInfoFindings

    @required
    findingDetails: NextPackVersionInfoFindingDetails
}

list NextPackVersionInfoFindingDetails {
    member: NextPackVersionInfoFindingDetailsMember
}

structure NextPackVersionInfoFindingDetailsMember {
    @required
    finding: String

    @required
    path: String
}

@documentation("List of changes from the previous version.")
list NextPackVersionInfoFindings {
    member: String
}

@documentation("If specified, a link that can be used to fetch the next page of results.")
string NextPageLink

@documentation("If specified, an opaque token used to fetch the next page of results.")
string NextPageToken

@documentation("If specified, an opaque token that can be passed back later to retrieve new results that match the parameters specified when the sync token was created.")
string NextSyncToken

@documentation("A number or a string representing a formula that evaluates to a number.")
union NumberOrNumberFormula {
    variant1: Double
    variant2: String
}

@documentation("Format of a numeric column.")
structure NumericColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @documentation("The decimal precision.")
    precision: Integer

    @documentation("Whether to use a thousands separator (like \",\") to format the numeric value.")
    useThousandsSeparator: Boolean
}

@documentation("Details about a Pack.")
structure Pack {
    @documentation("ID of the Pack.")
    @required
    id: Double

    @documentation("The link to the logo of the Pack.")
    logoUrl: String

    @documentation("The link to the cover photo of the Pack.")
    coverUrl: String

    @documentation("The example images for the Pack.")
    exampleImages: PackExampleImages

    @documentation("The agent images for the Pack.")
    agentImages: PackAgentImages

    @documentation("The parent workspace for the Pack.")
    @required
    workspaceId: String

    @documentation("Publishing categories associated with this Pack.")
    @required
    categories: PackCategories

    @documentation("Denotes if the pack is certified by Coda.")
    certified: Boolean

    @documentation("Denotes if the pack is certified by Grammarly to be optimized for agent usage.")
    certifiedAgent: Boolean

    sourceCodeVisibility: PackSourceCodeVisibility

    @documentation("Pack entrypoints where this pack is available")
    packEntrypoints: PackPackEntrypoints

    @documentation("The latest released pack version that has been verified (approved) for use. For agent packs, this is the most recent release that passed review. For non-agent packs or legacy releases, this is the most recent release.")
    verifiedVersion: String

    @documentation("The name of the Pack.")
    @required
    name: String

    @documentation("The full description of the Pack.")
    @required
    description: String

    @documentation("A short version of the description of the Pack.")
    @required
    shortDescription: String

    @documentation("A short description for the pack as an agent.")
    agentShortDescription: String

    @documentation("A full description for the pack as an agent.")
    agentDescription: String

    @documentation("A contact email for the Pack.")
    supportEmail: String

    @documentation("A Terms of Service URL for the Pack.")
    termsOfServiceUrl: String

    @documentation("A Privacy Policy URL for the Pack.")
    privacyPolicyUrl: String

    overallRateLimit: PackRateLimit

    perConnectionRateLimit: PackRateLimit

    featuredDocStatus: FeaturedDocStatus

    additionalInformation: PackListingAdditionalInformation
}

enum PackAccessType {
    @enumValue("none")
    NONE

    @enumValue("view")
    VIEW

    @enumValue("test")
    TEST

    @enumValue("edit")
    EDIT

    @enumValue("admin")
    ADMIN
}

@documentation("Access types for a Pack.")
list PackAccessTypes {
    member: PackAccessType
}

@documentation("The agent images for the Pack.")
list PackAgentImages {
    member: PackImageFile
}

@documentation("Pack log generated by an executing agent runtime.")
structure PackAgentRuntimeLog {
    @required
    type: PackAgentRuntimeLogType

    @required
    context: PackLogContext

    @documentation("The type of LLM agent turn that this log is for.")
    @required
    turnType: String

    @documentation("The duration of the turn in milliseconds.")
    durationMs: Double

    @documentation("The name of the turn target.")
    name: String

    @documentation("The model used for the turn.")
    model: String

    @documentation("The token usage for the turn.")
    tokenUsage: String

    @documentation("The instructions for the turn.")
    instructions: String

    @documentation("The name of the agent that initiated the turn.")
    fromAgent: String

    @documentation("The name of the agent that received the turn.")
    toAgent: String
}

@documentation("Details for pack agent runtime logs")
structure PackAgentRuntimeLogDetails {
    @required
    type: PackAgentRuntimeLogDetailsType

    @documentation("The input to the turn.")
    input: String

    @documentation("The output from the turn.")
    output: String
}

enum PackAgentRuntimeLogDetailsType {
    @enumValue("agentRuntime")
    AGENT_RUNTIME
}

enum PackAgentRuntimeLogType {
    @enumValue("agentRuntime")
    AGENT_RUNTIME
}

@documentation("List of analytics for Coda Packs over a date range.")
structure PackAnalyticsCollection {
    @required
    items: PackAnalyticsCollectionItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PackAnalyticsCollectionItems {
    member: PackAnalyticsItem
}

@documentation("Metadata about a Pack relevant to analytics.")
structure PackAnalyticsDetails {
    @documentation("ID of the Pack.")
    @required
    id: Double

    @documentation("The name of the Pack.")
    @required
    name: String

    @documentation("The link to the logo of the Pack.")
    logoUrl: String

    @documentation("Creation time of the Pack.")
    @required
    createdAt: String
}

@documentation("Analytics data for a Coda Pack.")
structure PackAnalyticsItem {
    @required
    pack: PackAnalyticsDetails

    @required
    metrics: PackAnalyticsItemMetrics
}

list PackAnalyticsItemMetrics {
    member: PackAnalyticsMetrics
}

@documentation("Analytics metrics for a Coda Pack.")
structure PackAnalyticsMetrics {
    @documentation("Date of the analytics data.")
    @required
    date: String

    @documentation("Number of unique documents that have installed this Pack.")
    @required
    docInstalls: Integer

    @documentation("Number of unique workspaces that have installed this Pack.")
    @required
    workspaceInstalls: Integer

    @documentation("Number of times regular formulas have been called.")
    @required
    numFormulaInvocations: Integer

    @documentation("Number of times action formulas have been called.")
    @required
    numActionInvocations: Integer

    @documentation("Number of times sync table formulas have been called.")
    @required
    numSyncInvocations: Integer

    @documentation("Number of times metadata formulas have been called.")
    @required
    numMetadataInvocations: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack in the past day.")
    @required
    docsActivelyUsing: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack in the past 7 days.")
    @required
    docsActivelyUsing7Day: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack in the past 30 days.")
    @required
    docsActivelyUsing30Day: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack in the past 90 days.")
    @required
    docsActivelyUsing90Day: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack ever.")
    @required
    docsActivelyUsingAllTime: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack in the past day.")
    @required
    workspacesActivelyUsing: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack in the past 7 days.")
    @required
    workspacesActivelyUsing7Day: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack in the past 30 days.")
    @required
    workspacesActivelyUsing30Day: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack in the past 90 days.")
    @required
    workspacesActivelyUsing90Day: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack ever.")
    @required
    workspacesActivelyUsingAllTime: Integer

    @documentation("Number of unique workspaces that are currently involved in a trial.")
    @required
    workspacesActivelyTrialing: Integer

    @documentation("Number of unique workspaces that have been involved in a trial in the last 7 days.")
    @required
    workspacesActivelyTrialing7Day: Integer

    @documentation("Number of unique workspaces that have been involved in a trial in the last 30 days.")
    @required
    workspacesActivelyTrialing30Day: Integer

    @documentation("Number of unique workspaces that have been involved in a trial in the last 90 days.")
    @required
    workspacesActivelyTrialing90Day: Integer

    @documentation("Number of unique workspaces that have been involved in a trial ever.")
    @required
    workspacesActivelyTrialingAllTime: Integer

    @documentation("Number of unique workspaces that have recently subscribed to the Pack.")
    @required
    workspacesNewlySubscribed: Integer

    @documentation("Number of unique workspaces that are currently subscribed to the Pack.")
    @required
    workspacesWithActiveSubscriptions: Integer

    @documentation("Number of unique workspaces that subscribed after undertaking a Pack trial.")
    @required
    workspacesWithSuccessfulTrials: Integer

    @documentation("Amount of revenue (in USD) that the Pack has produced.")
    @required
    revenueUsd: String
}

@documentation("Determines how the Pack analytics returned are sorted.")
enum PackAnalyticsOrderBy {
    @enumValue("date")
    DATE

    @enumValue("packId")
    PACK_ID

    @enumValue("name")
    NAME

    @enumValue("createdAt")
    CREATED_AT

    @enumValue("docInstalls")
    DOC_INSTALLS

    @enumValue("workspaceInstalls")
    WORKSPACE_INSTALLS

    @enumValue("numFormulaInvocations")
    NUM_FORMULA_INVOCATIONS

    @enumValue("numActionInvocations")
    NUM_ACTION_INVOCATIONS

    @enumValue("numSyncInvocations")
    NUM_SYNC_INVOCATIONS

    @enumValue("numMetadataInvocations")
    NUM_METADATA_INVOCATIONS

    @enumValue("docsActivelyUsing")
    DOCS_ACTIVELY_USING

    @enumValue("docsActivelyUsing7Day")
    DOCS_ACTIVELY_USING7_DAY

    @enumValue("docsActivelyUsing30Day")
    DOCS_ACTIVELY_USING30_DAY

    @enumValue("docsActivelyUsing90Day")
    DOCS_ACTIVELY_USING90_DAY

    @enumValue("docsActivelyUsingAllTime")
    DOCS_ACTIVELY_USING_ALL_TIME

    @enumValue("workspacesActivelyUsing")
    WORKSPACES_ACTIVELY_USING

    @enumValue("workspacesActivelyUsing7Day")
    WORKSPACES_ACTIVELY_USING7_DAY

    @enumValue("workspacesActivelyUsing30Day")
    WORKSPACES_ACTIVELY_USING30_DAY

    @enumValue("workspacesActivelyUsing90Day")
    WORKSPACES_ACTIVELY_USING90_DAY

    @enumValue("workspacesActivelyUsingAllTime")
    WORKSPACES_ACTIVELY_USING_ALL_TIME

    @enumValue("workspacesWithActiveSubscriptions")
    WORKSPACES_WITH_ACTIVE_SUBSCRIPTIONS

    @enumValue("workspacesWithSuccessfulTrials")
    WORKSPACES_WITH_SUCCESSFUL_TRIALS

    @enumValue("revenueUsd")
    REVENUE_USD
}

@documentation("Summary analytics for Packs.")
structure PackAnalyticsSummary {
    @documentation("The number of times this Pack was installed in docs.")
    @required
    totalDocInstalls: Integer

    @documentation("The number of times this Pack was installed in workspaces.")
    @required
    totalWorkspaceInstalls: Integer

    @documentation("The number of times formulas in this Pack were invoked.")
    @required
    totalInvocations: Integer
}

enum PackAssetType {
    @enumValue("logo")
    LOGO

    @enumValue("cover")
    COVER

    @enumValue("exampleImage")
    EXAMPLE_IMAGE

    @enumValue("agentImage")
    AGENT_IMAGE
}

@documentation("Payload for noting a Pack asset upload is complete.")
structure PackAssetUploadCompletePayload {
    @required
    packAssetType: PackAssetType
}

@documentation("Response for noting a Pack asset upload is complete.")
structure PackAssetUploadCompleteResponse {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("An identifier of this uploaded asset.")
    @required
    assetId: String
}

@documentation("Information indicating where to upload the Pack asset, and an endpoint to mark the upload as complete.")
structure PackAssetUploadInfo {
    @documentation("A signed URL to be used for uploading a Pack asset.")
    @required
    uploadUrl: String

    @documentation("An endpoint to mark the upload as complete.")
    @required
    packAssetUploadedPathName: String

    @documentation("Key-value pairs of authorization headers to include in the upload request.")
    @required
    headers: PackAssetUploadInfoHeaders
}

map PackAssetUploadInfoHeaders {
    key: String
    value: String
}

@documentation("System logs of Pack authentication requests.")
structure PackAuthLog {
    @required
    type: PackAuthLogType

    @required
    context: PackLogContext

    @documentation("The request path.")
    @required
    path: String

    @documentation("The error message.")
    errorMessage: String

    @documentation("The error stacktrace (internal only).")
    errorStack: String
}

enum PackAuthLogType {
    @enumValue("auth")
    AUTH
}

@documentation("Publishing categories associated with this Pack.")
list PackCategories {
    member: PublishingCategory
}

@documentation("The category of a Pack.")
enum PackCategoryType {
    @enumValue("connector")
    CONNECTOR

    @enumValue("agent")
    AGENT

    @enumValue("customAgent")
    CUSTOM_AGENT
}

@documentation("Basic details about a configuration that can be used in conjunction with a pack")
structure PackConfigurationEntry {
    @required
    configurationId: String

    @documentation("Name of the configuration")
    @required
    name: String

    @documentation("Policy associated with the configuration")
    policy: PackConfigurationEntryPolicy
}

@documentation("Policy associated with the configuration")
structure PackConfigurationEntryPolicy {}

structure PackConnectionAwsAccessKeyCredentials {
    @required
    type: PackConnectionAwsAccessKeyCredentialsType

    @required
    accessKeyId: String

    @required
    secretAccessKey: String
}

enum PackConnectionAwsAccessKeyCredentialsType {
    @enumValue("awsAccessKey")
    AWS_ACCESS_KEY
}

structure PackConnectionAwsAccessKeyMetadata {
    @required
    type: PackConnectionAwsAccessKeyMetadataType

    @required
    @jsonName("service")
    serviceValue: String

    @required
    maskedAccessKeyId: String

    @required
    maskedSecretAccessKey: String
}

enum PackConnectionAwsAccessKeyMetadataType {
    @enumValue("awsAccessKey")
    AWS_ACCESS_KEY
}

structure PackConnectionAwsAccessKeyPatch {
    @required
    type: PackConnectionAwsAccessKeyPatchType

    accessKeyId: String

    secretAccessKey: String
}

enum PackConnectionAwsAccessKeyPatchType {
    @enumValue("awsAccessKey")
    AWS_ACCESS_KEY
}

structure PackConnectionAwsAssumeRoleCredentials {
    @required
    type: PackConnectionAwsAssumeRoleCredentialsType

    @required
    roleArn: String

    @required
    externalId: String
}

enum PackConnectionAwsAssumeRoleCredentialsType {
    @enumValue("awsAssumeRole")
    AWS_ASSUME_ROLE
}

structure PackConnectionAwsAssumeRoleMetadata {
    @required
    type: PackConnectionAwsAssumeRoleMetadataType

    @required
    @jsonName("service")
    serviceValue: String

    @required
    roleArn: String

    @required
    externalId: String
}

enum PackConnectionAwsAssumeRoleMetadataType {
    @enumValue("awsAssumeRole")
    AWS_ASSUME_ROLE
}

structure PackConnectionAwsAssumeRolePatch {
    @required
    type: PackConnectionAwsAssumeRolePatchType

    roleArn: String

    externalId: String
}

enum PackConnectionAwsAssumeRolePatchType {
    @enumValue("awsAssumeRole")
    AWS_ASSUME_ROLE
}

structure PackConnectionCustomCredentials {
    @required
    type: PackConnectionCustomCredentialsType

    @required
    params: PackConnectionCustomCredentialsParams
}

list PackConnectionCustomCredentialsParams {
    member: PackConnectionCustomCredentialsParamsMember
}

structure PackConnectionCustomCredentialsParamsMember {
    @required
    key: String

    @required
    value: String
}

enum PackConnectionCustomCredentialsType {
    @enumValue("custom")
    CUSTOM
}

structure PackConnectionCustomMetadata {
    @required
    type: PackConnectionCustomMetadataType

    @documentation("An array of objects containing the parameter key and masked value.")
    @required
    params: PackConnectionCustomMetadataParams

    @documentation("The domain corresponding to the pre-authorized network domain in the pack.")
    @required
    domain: String

    @documentation("An array containing the keys of parameters specified by the authentication config.")
    @required
    presetKeys: PackConnectionCustomMetadataPresetKeys
}

@documentation("An array of objects containing the parameter key and masked value.")
list PackConnectionCustomMetadataParams {
    member: PackConnectionCustomMetadataParamsMember
}

structure PackConnectionCustomMetadataParamsMember {
    @required
    key: String

    @required
    maskedValue: String
}

@documentation("An array containing the keys of parameters specified by the authentication config.")
list PackConnectionCustomMetadataPresetKeys {
    member: String
}

enum PackConnectionCustomMetadataType {
    @enumValue("custom")
    CUSTOM
}

structure PackConnectionCustomPatch {
    @required
    type: PackConnectionCustomPatchType

    paramsToPatch: PackConnectionCustomPatchParamsToPatch
}

list PackConnectionCustomPatchParamsToPatch {
    member: PackConnectionCustomPatchParamsToPatchMember
}

structure PackConnectionCustomPatchParamsToPatchMember {
    @required
    key: String

    @required
    value: String
}

enum PackConnectionCustomPatchType {
    @enumValue("custom")
    CUSTOM
}

structure PackConnectionGoogleServiceAccountCredentials {
    @required
    type: PackConnectionGoogleServiceAccountCredentialsType

    @required
    serviceAccountKey: String
}

enum PackConnectionGoogleServiceAccountCredentialsType {
    @enumValue("googleServiceAccount")
    GOOGLE_SERVICE_ACCOUNT
}

structure PackConnectionGoogleServiceAccountMetadata {
    @required
    type: PackConnectionGoogleServiceAccountMetadataType

    @required
    maskedServiceAccountKey: String
}

enum PackConnectionGoogleServiceAccountMetadataType {
    @enumValue("googleServiceAccount")
    GOOGLE_SERVICE_ACCOUNT
}

structure PackConnectionGoogleServiceAccountPatch {
    @required
    type: PackConnectionGoogleServiceAccountPatchType

    serviceAccountKey: String
}

enum PackConnectionGoogleServiceAccountPatchType {
    @enumValue("googleServiceAccount")
    GOOGLE_SERVICE_ACCOUNT
}

structure PackConnectionHeaderCredentials {
    @required
    type: PackConnectionHeaderCredentialsType

    @required
    token: String
}

enum PackConnectionHeaderCredentialsType {
    @enumValue("header")
    HEADER
}

structure PackConnectionHeaderMetadata {
    @required
    type: PackConnectionHeaderMetadataType

    maskedToken: String

    @required
    headerName: String

    @required
    tokenPrefix: String
}

enum PackConnectionHeaderMetadataType {
    @enumValue("header")
    HEADER
}

structure PackConnectionHeaderPatch {
    @required
    type: PackConnectionHeaderPatchType

    token: String
}

enum PackConnectionHeaderPatchType {
    @enumValue("header")
    HEADER
}

structure PackConnectionHttpBasicCredentials {
    @required
    type: PackConnectionHttpBasicCredentialsType

    @required
    username: String

    password: String
}

enum PackConnectionHttpBasicCredentialsType {
    @enumValue("httpBasic")
    HTTP_BASIC
}

structure PackConnectionHttpBasicMetadata {
    @required
    type: PackConnectionHttpBasicMetadataType

    maskedUsername: String

    maskedPassword: String
}

enum PackConnectionHttpBasicMetadataType {
    @enumValue("httpBasic")
    HTTP_BASIC
}

structure PackConnectionHttpBasicPatch {
    @required
    type: PackConnectionHttpBasicPatchType

    username: String

    password: String
}

enum PackConnectionHttpBasicPatchType {
    @enumValue("httpBasic")
    HTTP_BASIC
}

structure PackConnectionMultiHeaderCredentials {
    @required
    type: PackConnectionMultiHeaderCredentialsType

    @required
    tokens: PackConnectionMultiHeaderCredentialsTokens
}

list PackConnectionMultiHeaderCredentialsTokens {
    member: PackConnectionMultiHeaderCredentialsTokensMember
}

structure PackConnectionMultiHeaderCredentialsTokensMember {
    @required
    key: String

    @required
    value: String
}

enum PackConnectionMultiHeaderCredentialsType {
    @enumValue("multiHeader")
    MULTI_HEADER
}

structure PackConnectionMultiHeaderMetadata {
    @required
    type: PackConnectionMultiHeaderMetadataType

    @required
    headers: PackConnectionMultiHeaderMetadataHeaders

    @required
    presets: PackConnectionMultiHeaderMetadataPresets
}

list PackConnectionMultiHeaderMetadataHeaders {
    member: PackConnectionMultiHeaderMetadataHeadersMember
}

structure PackConnectionMultiHeaderMetadataHeadersMember {
    @required
    headerName: String

    @required
    maskedToken: String

    tokenPrefix: String
}

list PackConnectionMultiHeaderMetadataPresets {
    member: PackConnectionMultiHeaderMetadataPresetsMember
}

structure PackConnectionMultiHeaderMetadataPresetsMember {
    @required
    headerName: String

    tokenPrefix: String
}

enum PackConnectionMultiHeaderMetadataType {
    @enumValue("multiHeader")
    MULTI_HEADER
}

structure PackConnectionMultiHeaderPatch {
    @required
    type: PackConnectionMultiHeaderPatchType

    tokensToPatch: PackConnectionMultiHeaderPatchTokensToPatch
}

list PackConnectionMultiHeaderPatchTokensToPatch {
    member: PackConnectionMultiHeaderPatchTokensToPatchMember
}

structure PackConnectionMultiHeaderPatchTokensToPatchMember {
    @required
    key: String

    @required
    value: String
}

enum PackConnectionMultiHeaderPatchType {
    @enumValue("multiHeader")
    MULTI_HEADER
}

structure PackConnectionOauth2ClientCredentials {
    @required
    type: PackConnectionOauth2ClientCredentialsType

    @required
    clientId: String

    @required
    clientSecret: String
}

structure PackConnectionOauth2ClientCredentialsMetadata {
    @required
    type: PackConnectionOauth2ClientCredentialsMetadataType

    @required
    location: PackOAuth2ClientCredentialsLocation

    @required
    maskedClientId: String

    @required
    maskedClientSecret: String
}

enum PackConnectionOauth2ClientCredentialsMetadataType {
    @enumValue("oauth2ClientCredentials")
    OAUTH2_CLIENT_CREDENTIALS
}

structure PackConnectionOauth2ClientCredentialsPatch {
    @required
    type: PackConnectionOauth2ClientCredentialsPatchType

    clientId: String

    clientSecret: String
}

enum PackConnectionOauth2ClientCredentialsPatchType {
    @enumValue("oauth2ClientCredentials")
    OAUTH2_CLIENT_CREDENTIALS
}

enum PackConnectionOauth2ClientCredentialsType {
    @enumValue("oauth2ClientCredentials")
    OAUTH2_CLIENT_CREDENTIALS
}

@documentation("Type of Pack connections.")
enum PackConnectionType {
    @enumValue("header")
    HEADER

    @enumValue("multiHeader")
    MULTI_HEADER

    @enumValue("urlParam")
    URL_PARAM

    @enumValue("httpBasic")
    HTTP_BASIC

    @enumValue("custom")
    CUSTOM

    @enumValue("oauth2ClientCredentials")
    OAUTH2_CLIENT_CREDENTIALS

    @enumValue("googleServiceAccount")
    GOOGLE_SERVICE_ACCOUNT

    @enumValue("awsAssumeRole")
    AWS_ASSUME_ROLE

    @enumValue("awsAccessKey")
    AWS_ACCESS_KEY
}

structure PackConnectionUrlParamCredentials {
    @required
    type: PackConnectionUrlParamCredentialsType

    @required
    params: PackConnectionUrlParamCredentialsParams
}

list PackConnectionUrlParamCredentialsParams {
    member: PackConnectionUrlParamCredentialsParamsMember
}

structure PackConnectionUrlParamCredentialsParamsMember {
    @required
    key: String

    @required
    value: String
}

enum PackConnectionUrlParamCredentialsType {
    @enumValue("urlParam")
    URL_PARAM
}

structure PackConnectionUrlParamMetadata {
    @required
    type: PackConnectionUrlParamMetadataType

    @required
    params: PackConnectionUrlParamMetadataParams

    @required
    domain: String

    @required
    presetKeys: PackConnectionUrlParamMetadataPresetKeys
}

list PackConnectionUrlParamMetadataParams {
    member: PackConnectionUrlParamMetadataParamsMember
}

structure PackConnectionUrlParamMetadataParamsMember {
    @required
    key: String

    @required
    maskedValue: String
}

list PackConnectionUrlParamMetadataPresetKeys {
    member: String
}

enum PackConnectionUrlParamMetadataType {
    @enumValue("urlParam")
    URL_PARAM
}

structure PackConnectionUrlParamPatch {
    @required
    type: PackConnectionUrlParamPatchType

    paramsToPatch: PackConnectionUrlParamPatchParamsToPatch
}

list PackConnectionUrlParamPatchParamsToPatch {
    member: PackConnectionUrlParamPatchParamsToPatchMember
}

structure PackConnectionUrlParamPatchParamsToPatchMember {
    @required
    key: String

    @required
    value: String
}

enum PackConnectionUrlParamPatchType {
    @enumValue("urlParam")
    URL_PARAM
}

@documentation("Pack log generated by developer's custom logging with context.logger.")
structure PackCustomLog {
    @required
    type: PackCustomLogType

    @required
    context: PackLogContext

    @documentation("The message that's passed into context.logger.")
    @required
    message: String

    @required
    level: LogLevel
}

enum PackCustomLogType {
    @enumValue("custom")
    CUSTOM
}

@documentation("Widest principal a Pack is available to.")
enum PackDiscoverability {
    @enumValue("public")
    PUBLIC

    @enumValue("nomosOrganization")
    NOMOS_ORGANIZATION

    @enumValue("group")
    GROUP

    @enumValue("grammarlyInstitution")
    GRAMMARLY_INSTITUTION

    @enumValue("workspace")
    WORKSPACE

    @enumValue("private")
    PRIVATE
}

enum PackEntrypoint {
    @enumValue("go")
    GO

    @enumValue("docs")
    DOCS
}

@documentation("The example images for the Pack.")
list PackExampleImages {
    member: PackImageFile
}

@documentation("A Pack's featured doc.")
structure PackFeaturedDoc {
    @required
    doc: DocReference

    @documentation("Whether or not this featured doc is pinned.")
    @required
    isPinned: Boolean

    docStatus: FeaturedDocStatus

    @documentation("The URL of the published doc, if available.")
    publishedUrl: String
}

@documentation("Item representing a featured doc in the update Pack featured docs request.")
structure PackFeaturedDocRequestItem {
    @documentation("A URL to a doc.")
    @required
    url: String

    @documentation("Whether or not the current doc should be pinned.")
    isPinned: Boolean
}

@documentation("List of a Pack's featured docs.")
structure PackFeaturedDocsResponse {
    @documentation("A list of featured docs for the Pack.")
    @required
    items: PackFeaturedDocsResponseItems
}

@documentation("A list of featured docs for the Pack.")
list PackFeaturedDocsResponseItems {
    member: PackFeaturedDoc
}

@documentation("System logs of Pack calls to context.fetcher.")
structure PackFetcherLog {
    @required
    type: PackFetcherLogType

    @required
    context: PackLogContext

    @documentation("The number of bytes in the HTTP request sent")
    requestSizeBytes: Double

    responseCode: Double

    @documentation("The number of bytes in the HTTP response received")
    responseSizeBytes: Double

    method: PackFetcherLogMethod

    @documentation("base URL of the fetcher request, with all query parameters stripped off.")
    baseUrl: String

    @documentation("true if the fetcher request hits catche instead of actually requesting the remote service.")
    cacheHit: Boolean

    @documentation("Duration of the fetcher request in miliseconds.")
    duration: Double
}

@documentation("Details for pack fetcher logs")
structure PackFetcherLogDetails {
    @required
    type: PackFetcherLogDetailsType

    @required
    request: String

    response: String
}

enum PackFetcherLogDetailsType {
    @enumValue("fetcher")
    FETCHER
}

enum PackFetcherLogMethod {
    @enumValue("GET")
    GET

    @enumValue("POST")
    POST

    @enumValue("PUT")
    PUT

    @enumValue("DELETE")
    DELETE

    @enumValue("PATCH")
    PATCH

    @enumValue("HEAD")
    HEAD
}

enum PackFetcherLogType {
    @enumValue("fetcher")
    FETCHER
}

@documentation("A collection of analytics for Coda Packs formulas over a date range.")
structure PackFormulaAnalyticsCollection {
    @required
    items: PackFormulaAnalyticsCollectionItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PackFormulaAnalyticsCollectionItems {
    member: PackFormulaAnalyticsItem
}

@documentation("Analytics data for a Coda Pack formula.")
structure PackFormulaAnalyticsItem {
    @required
    formula: PackFormulaIdentifier

    @required
    metrics: PackFormulaAnalyticsItemMetrics
}

list PackFormulaAnalyticsItemMetrics {
    member: PackFormulaAnalyticsMetrics
}

@documentation("Analytics metrics for a Coda Pack formula.")
structure PackFormulaAnalyticsMetrics {
    @documentation("Date of the analytics data.")
    @required
    date: String

    @documentation("Number of times this formula has been invoked.")
    @required
    formulaInvocations: Integer

    @documentation("Number of errors from invocations.")
    @required
    errors: Integer

    @documentation("Median latency of an invocation in milliseconds. Only present for daily metrics.")
    medianLatencyMs: Integer

    @documentation("Median response size in bytes. Only present for daily metrics.")
    medianResponseSizeBytes: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack in the past day.")
    @required
    docsActivelyUsing: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack in the past 7 days.")
    @required
    docsActivelyUsing7Day: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack in the past 30 days.")
    @required
    docsActivelyUsing30Day: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack in the past 90 days.")
    @required
    docsActivelyUsing90Day: Integer

    @documentation("Number of unique docs that have invoked a formula from this Pack ever.")
    @required
    docsActivelyUsingAllTime: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack in the past day.")
    @required
    workspacesActivelyUsing: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack in the past 7 days.")
    @required
    workspacesActivelyUsing7Day: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack in the past 30 days.")
    @required
    workspacesActivelyUsing30Day: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack in the past 90 days.")
    @required
    workspacesActivelyUsing90Day: Integer

    @documentation("Number of unique workspaces that have invoked a formula from this Pack ever.")
    @required
    workspacesActivelyUsingAllTime: Integer

    @documentation("Number of unique workspaces that are currently involved in a trial.")
    workspacesActivelyTrialing: Integer

    @documentation("Number of unique workspaces that have been involved in a trial in the last 7 days.")
    workspacesActivelyTrialing7Day: Integer

    @documentation("Number of unique workspaces that have been involved in a trial in the last 30 days.")
    workspacesActivelyTrialing30Day: Integer

    @documentation("Number of unique workspaces that have been involved in a trial in the last 90 days.")
    workspacesActivelyTrialing90Day: Integer

    @documentation("Number of unique workspaces that have been involved in a trial ever.")
    workspacesActivelyTrialingAllTime: Integer

    @documentation("Number of unique workspaces that have recently subscribed to the Pack.")
    workspacesNewlySubscribed: Integer

    @documentation("Number of unique workspaces that are currently subscribed to the Pack.")
    workspacesWithActiveSubscriptions: Integer

    @documentation("Number of unique workspaces that subscribed after undertaking a Pack trial.")
    workspacesWithSuccessfulTrials: Integer

    @documentation("Amount of revenue (in USD) that the Pack has produced.")
    revenueUsd: String
}

@documentation("Determines how the Pack formula analytics returned are sorted.")
enum PackFormulaAnalyticsOrderBy {
    @enumValue("date")
    DATE

    @enumValue("formulaName")
    FORMULA_NAME

    @enumValue("formulaType")
    FORMULA_TYPE

    @enumValue("formulaInvocations")
    FORMULA_INVOCATIONS

    @enumValue("medianLatencyMs")
    MEDIAN_LATENCY_MS

    @enumValue("medianResponseSizeBytes")
    MEDIAN_RESPONSE_SIZE_BYTES

    @enumValue("errors")
    ERRORS

    @enumValue("docsActivelyUsing")
    DOCS_ACTIVELY_USING

    @enumValue("docsActivelyUsing7Day")
    DOCS_ACTIVELY_USING7_DAY

    @enumValue("docsActivelyUsing30Day")
    DOCS_ACTIVELY_USING30_DAY

    @enumValue("docsActivelyUsing90Day")
    DOCS_ACTIVELY_USING90_DAY

    @enumValue("docsActivelyUsingAllTime")
    DOCS_ACTIVELY_USING_ALL_TIME

    @enumValue("workspacesActivelyUsing")
    WORKSPACES_ACTIVELY_USING

    @enumValue("workspacesActivelyUsing7Day")
    WORKSPACES_ACTIVELY_USING7_DAY

    @enumValue("workspacesActivelyUsing30Day")
    WORKSPACES_ACTIVELY_USING30_DAY

    @enumValue("workspacesActivelyUsing90Day")
    WORKSPACES_ACTIVELY_USING90_DAY

    @enumValue("workspacesActivelyUsingAllTime")
    WORKSPACES_ACTIVELY_USING_ALL_TIME
}

structure PackFormulaIdentifier {
    @documentation("The Pack formula name.")
    @required
    name: String

    @required
    type: PackFormulaType
}

enum PackFormulaType {
    @enumValue("action")
    ACTION

    @enumValue("formula")
    FORMULA

    @enumValue("sync")
    SYNC

    @enumValue("metadata")
    METADATA
}

structure PackGlobalPrincipal {
    @required
    type: PackGlobalPrincipalType
}

enum PackGlobalPrincipalType {
    @enumValue("worldwide")
    WORLDWIDE
}

structure PackGrammarlyInstitutionPrincipal {
    @required
    type: PackGrammarlyInstitutionPrincipalType

    @required
    grammarlyInstitutionId: Long
}

enum PackGrammarlyInstitutionPrincipalType {
    @enumValue("grammarlyInstitution")
    GRAMMARLY_INSTITUTION
}

structure PackGroupPrincipal {
    @required
    type: PackGroupPrincipalType

    @required
    groupId: String

    groupName: String
}

enum PackGroupPrincipalType {
    @enumValue("group")
    GROUP
}

@documentation("A Pack image file.")
structure PackImageFile {
    @documentation("The name of the image file.")
    @required
    filename: String

    @documentation("The URL to the image file.")
    @required
    imageUrl: String

    @documentation("The asset id of the Pack's image.")
    @required
    assetId: String

    @documentation("The alt text for the image.")
    altText: String

    @documentation("The media type of the image.")
    mimeType: String
}

@documentation("Pack log generated by an executing ingestion. Contains metadata helpful for debugging")
structure PackIngestionDebugLog {
    @required
    type: PackIngestionDebugLogType

    @required
    context: PackLogContext

    @documentation("The message that's passed into context.logger.")
    @required
    message: String

    @required
    level: LogLevel
}

enum PackIngestionDebugLogType {
    @enumValue("ingestionDebug")
    INGESTION_DEBUG
}

@documentation("Pack log generated by an executing ingestion.")
structure PackIngestionLifecycleLog {
    @required
    type: PackIngestionLifecycleLogType

    @required
    context: PackLogContext

    @documentation("The message that's passed into context.logger.")
    @required
    message: String

    @required
    level: LogLevel
}

enum PackIngestionLifecycleLogType {
    @enumValue("ingestionLifecycle")
    INGESTION_LIFECYCLE
}

@documentation("Coda internal logs from the packs infrastructure. Only visible to Codans.")
structure PackInternalLog {
    @required
    type: PackInternalLogType

    @required
    context: PackLogContext

    @documentation("The log message.")
    @required
    message: String

    @required
    level: LogLevel
}

enum PackInternalLogType {
    @enumValue("internal")
    INTERNAL
}

@documentation("Metadata about a Pack invitation.")
structure PackInvitation {
    @documentation("ID of the invitation")
    @required
    invitationId: String

    @documentation("ID of the Pack")
    @required
    packId: Double

    @documentation("Email address of the invited user")
    @required
    inviteeEmail: String

    @documentation("User ID of the user who created this invitation")
    @required
    inviterUserId: Integer

    @required
    access: PackAccessType

    @documentation("Timestamp when the invitation was created")
    @required
    createdAt: String

    @documentation("Timestamp when the invitation expires")
    @required
    expiresAt: String
}

@documentation("List of Pack invitations.")
structure PackInvitationList {
    @required
    items: PackInvitationListItems

    @documentation("Token for fetching the next page of results")
    nextPageToken: String

    @documentation("URL for fetching the next page of results")
    nextPageLink: String
}

list PackInvitationListItems {
    member: PackInvitation
}

@documentation("Pack invitation with Pack metadata.")
structure PackInvitationWithPack {
    @required
    invitation: PackInvitation

    @required
    pack: PackSummary

    @required
    makers: PackInvitationWithPackMakers

    @documentation("Network domain of the Pack")
    @required
    networkDomains: PackInvitationWithPackNetworkDomains
}

@documentation("List of Pack invitations with Pack metadata.")
structure PackInvitationWithPackList {
    @required
    items: PackInvitationWithPackListItems

    @documentation("Token for fetching the next page of results")
    nextPageToken: String

    @documentation("URL for fetching the next page of results")
    nextPageLink: String
}

list PackInvitationWithPackListItems {
    member: PackInvitationWithPack
}

list PackInvitationWithPackMakers {
    member: Maker
}

@documentation("Network domain of the Pack")
list PackInvitationWithPackNetworkDomains {
    member: String
}

@documentation("System logs of the invocations of the Pack.")
structure PackInvocationLog {
    @required
    type: PackInvocationLogType

    @required
    context: PackLogContext

    @documentation("True if the formula returned a prior result without executing.")
    cacheHit: Boolean

    @documentation("Duration of the formula exeuction in miliseconds.")
    duration: Double

    @documentation("Error info if this invocation resulted in an error.")
    error: PackInvocationLogError
}

@documentation("Details for pack invocation logs")
structure PackInvocationLogDetails {
    @required
    type: PackInvocationLogDetailsType

    result: PackInvocationLogDetailsResult

    @documentation("Supplementary information about the result.")
    resultDetail: String

    @documentation("Only used by sync invocations.")
    continuationJson: String

    @documentation("Only used by sync invocations.")
    completionJson: String

    @documentation("Only used by sync invocations.")
    deletedItemIdsJson: String

    @documentation("Only used by sync invocations.")
    permissionsContextJson: String
}

structure PackInvocationLogDetailsResult {
    @required
    stringVal: String

    @required
    int64Val: Double

    @required
    doubleVal: Double

    @required
    objectVal: String

    @required
    boolVal: Boolean

    @required
    dateVal: Double
}

enum PackInvocationLogDetailsType {
    @enumValue("invocation")
    INVOCATION
}

@documentation("Error info if this invocation resulted in an error.")
structure PackInvocationLogError {
    @required
    message: String

    stack: String
}

enum PackInvocationLogType {
    @enumValue("invocation")
    INVOCATION
}

@documentation("A Pack listing.")
structure PackListing {
    @documentation("ID of the Pack.")
    @required
    packId: Double

    @documentation("The version of the Pack.")
    @required
    packVersion: String

    @documentation("The current release number of the Pack if released, otherwise undefined.")
    releaseId: Double

    @documentation("The timestamp of the latest release of this Pack.")
    lastReleasedAt: String

    @documentation("The link to the logo of the Pack.")
    @required
    logoUrl: String

    @required
    logo: PackImageFile

    @documentation("The link to the cover photo of the Pack.")
    coverUrl: String

    cover: PackImageFile

    @documentation("The example images for the Pack.")
    exampleImages: PackListingExampleImages

    @documentation("The agent images for the Pack.")
    agentImages: PackListingAgentImages

    @documentation("The name of the Pack.")
    @required
    name: String

    @documentation("The full description of the Pack.")
    @required
    description: String

    @documentation("A short version of the description of the Pack.")
    @required
    shortDescription: String

    @documentation("A short description for the pack as an agent.")
    agentShortDescription: String

    @documentation("A full description for the pack as an agent.")
    agentDescription: String

    @documentation("A contact email for the Pack.")
    supportEmail: String

    @documentation("A Terms of Service URL for the Pack.")
    termsOfServiceUrl: String

    @documentation("A Privacy Policy URL for the Pack.")
    privacyPolicyUrl: String

    @documentation("Publishing Categories associated with this Pack.")
    @required
    categories: PackListingCategories

    @documentation("Makers associated with this Pack.")
    @required
    makers: PackListingMakers

    @documentation("Denotes if the pack is certified by Coda.")
    certified: Boolean

    @documentation("Denotes if the pack is certified by Grammarly to be optimized for agent usage.")
    certifiedAgent: Boolean

    minimumFeatureSet: FeatureSet

    unrestrictedFeatureSet: FeatureSet

    @documentation("The URL where complete metadata about the contents of the Pack version can be downloaded.")
    @required
    externalMetadataUrl: String

    standardPackPlan: StandardPackPlan

    bundledPackPlan: BundledPackPlan

    sourceCodeVisibility: PackSourceCodeVisibility

    @documentation("What Packs SDK version was this version built on.")
    @required
    sdkVersion: String

    @required
    packCategoryType: PackCategoryType
}

@documentation("Additional information saved with the pack listing draft")
structure PackListingAdditionalInformation {
    @documentation("Whether the agent or third-party partners collect personal information.")
    privacyCollectsPersonalInfo: Boolean

    @documentation("Categories of personal information collected by the agent.")
    privacyPersonalInfoCategories: PackListingAdditionalInformationPrivacyPersonalInfoCategories

    @documentation("Purposes for which collected data is used by the agent or third-party partners.")
    privacyDataUsagePurposes: PackListingAdditionalInformationPrivacyDataUsagePurposes

    @documentation("Whether data is collected by the developer, a third party, or both.")
    privacyDataCollectedBy: PackListingAdditionalInformationPrivacyDataCollectedBy
}

@documentation("Whether data is collected by the developer, a third party, or both.")
list PackListingAdditionalInformationPrivacyDataCollectedBy {
    member: String
}

@documentation("Purposes for which collected data is used by the agent or third-party partners.")
list PackListingAdditionalInformationPrivacyDataUsagePurposes {
    member: String
}

@documentation("Categories of personal information collected by the agent.")
list PackListingAdditionalInformationPrivacyPersonalInfoCategories {
    member: String
}

@documentation("The agent images for the Pack.")
list PackListingAgentImages {
    member: PackImageFile
}

@documentation("Publishing Categories associated with this Pack.")
list PackListingCategories {
    member: PublishingCategory
}

@documentation("A detailed Pack listing.")
structure PackListingDetail {
    @documentation("ID of the Pack.")
    @required
    packId: Double

    @documentation("The version of the Pack.")
    @required
    packVersion: String

    @documentation("The current release number of the Pack if released, otherwise undefined.")
    releaseId: Double

    @documentation("The timestamp of the latest release of this Pack.")
    lastReleasedAt: String

    @documentation("The link to the logo of the Pack.")
    @required
    logoUrl: String

    @required
    logo: PackImageFile

    @documentation("The link to the cover photo of the Pack.")
    coverUrl: String

    cover: PackImageFile

    @documentation("The example images for the Pack.")
    exampleImages: PackListingDetailExampleImages

    @documentation("The agent images for the Pack.")
    agentImages: PackListingDetailAgentImages

    @documentation("The name of the Pack.")
    @required
    name: String

    @documentation("The full description of the Pack.")
    @required
    description: String

    @documentation("A short version of the description of the Pack.")
    @required
    shortDescription: String

    @documentation("A short description for the pack as an agent.")
    agentShortDescription: String

    @documentation("A full description for the pack as an agent.")
    agentDescription: String

    @documentation("A contact email for the Pack.")
    supportEmail: String

    @documentation("A Terms of Service URL for the Pack.")
    termsOfServiceUrl: String

    @documentation("A Privacy Policy URL for the Pack.")
    privacyPolicyUrl: String

    @documentation("Publishing Categories associated with this Pack.")
    @required
    categories: PackListingDetailCategories

    @documentation("Makers associated with this Pack.")
    @required
    makers: PackListingDetailMakers

    @documentation("Denotes if the pack is certified by Coda.")
    certified: Boolean

    @documentation("Denotes if the pack is certified by Grammarly to be optimized for agent usage.")
    certifiedAgent: Boolean

    minimumFeatureSet: FeatureSet

    unrestrictedFeatureSet: FeatureSet

    @documentation("The URL where complete metadata about the contents of the Pack version can be downloaded.")
    @required
    externalMetadataUrl: String

    standardPackPlan: StandardPackPlan

    bundledPackPlan: BundledPackPlan

    sourceCodeVisibility: PackSourceCodeVisibility

    @documentation("What Packs SDK version was this version built on.")
    @required
    sdkVersion: String

    @required
    packCategoryType: PackCategoryType

    @required
    discoverability: PackDiscoverability

    @required
    userAccess: PackUserAccess

    @documentation("The URL of a Coda Help Center article with documentation about the Pack. This will only exist for select Coda-authored Packs.")
    codaHelpCenterUrl: String

    configuration: PackConfigurationEntry
}

@documentation("The agent images for the Pack.")
list PackListingDetailAgentImages {
    member: PackImageFile
}

@documentation("Publishing Categories associated with this Pack.")
list PackListingDetailCategories {
    member: PublishingCategory
}

@documentation("The example images for the Pack.")
list PackListingDetailExampleImages {
    member: PackImageFile
}

@documentation("Makers associated with this Pack.")
list PackListingDetailMakers {
    member: MakerSummary
}

@documentation("Draft listing data for a Pack. All fields are optional.")
structure PackListingDraftData {
    @documentation("The name of the Pack.")
    name: String

    @documentation("The full description of the Pack.")
    description: String

    @documentation("A short version of the description of the Pack.")
    shortDescription: String

    logo: PackImageFile

    cover: PackImageFile

    exampleImages: PackListingDraftDataExampleImages

    agentImages: PackListingDraftDataAgentImages

    categoryIds: PackListingDraftDataCategoryIds

    supportEmail: String

    termsOfServiceUrl: String

    privacyPolicyUrl: String

    sourceCodeVisibility: PackSourceCodeVisibility

    agentShortDescription: String

    agentDescription: String

    additionalInformation: PackListingAdditionalInformation
}

list PackListingDraftDataAgentImages {
    member: PackImageFile
}

list PackListingDraftDataCategoryIds {
    member: String
}

list PackListingDraftDataExampleImages {
    member: PackImageFile
}

@documentation("Input data for creating or updating a Pack listing draft. Agent images only require assetId and filename; the server resolves the full image URL.")
structure PackListingDraftInputData {
    @documentation("The name of the Pack.")
    name: String

    @documentation("The full description of the Pack.")
    description: String

    @documentation("A short version of the description of the Pack.")
    shortDescription: String

    logo: PackImageFile

    cover: PackImageFile

    exampleImages: PackListingDraftInputDataExampleImages

    agentImages: PackListingDraftInputDataAgentImages

    categoryIds: PackListingDraftInputDataCategoryIds

    supportEmail: String

    termsOfServiceUrl: String

    privacyPolicyUrl: String

    sourceCodeVisibility: PackSourceCodeVisibility

    agentShortDescription: String

    agentDescription: String

    additionalInformation: PackListingAdditionalInformation
}

list PackListingDraftInputDataAgentImages {
    member: ImageFileForUpdatePackRequest
}

list PackListingDraftInputDataCategoryIds {
    member: String
}

list PackListingDraftInputDataExampleImages {
    member: PackImageFile
}

@documentation("The example images for the Pack.")
list PackListingExampleImages {
    member: PackImageFile
}

@documentation("Type of context in which a Pack is being installed.")
enum PackListingInstallContextType {
    @enumValue("workspace")
    WORKSPACE

    @enumValue("doc")
    DOC
}

@documentation("A list of Pack listings.")
structure PackListingList {
    @required
    items: PackListingListItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PackListingListItems {
    member: PackListing
}

@documentation("Makers associated with this Pack.")
list PackListingMakers {
    member: MakerSummary
}

@documentation("Determines how the Pack listings returned are sorted.")
enum PackListingsSortBy {
    @enumValue("packId")
    PACK_ID

    @enumValue("name")
    NAME

    @enumValue("packVersion")
    PACK_VERSION

    @enumValue("packVersionModifiedAt")
    PACK_VERSION_MODIFIED_AT

    @enumValue("agentDirectorySort")
    AGENT_DIRECTORY_SORT
}

@documentation("A record of Pack log.")
union PackLog {
    packCustomLog: PackCustomLog
    packInvocationLog: PackInvocationLog
    packFetcherLog: PackFetcherLog
    packInternalLog: PackInternalLog
    packAuthLog: PackAuthLog
    packIngestionLifecycleLog: PackIngestionLifecycleLog
    packIngestionDebugLog: PackIngestionDebugLog
    packAgentRuntimeLog: PackAgentRuntimeLog
    packMcpLog: PackMcpLog
}

@documentation("Logging context that comes with a Pack log.")
structure PackLogContext {
    @required
    docId: String

    @required
    packId: String

    @required
    packVersion: String

    @required
    formulaName: String

    @required
    userId: String

    @required
    connectionId: String

    connectionName: String

    @documentation("A unique identifier of the Pack invocation that can be used to associate all log types generated in one call of a Pack formula.")
    @required
    requestId: String

    @required
    requestType: PackLogRequestType

    @documentation("Creation time of the log.")
    @required
    createdAt: String

    @documentation("Unique identifier of this log record.")
    @required
    logId: String

    @documentation("Doc canvas object id where the formula was fired from.")
    docObjectId: String

    @documentation("Doc canvas row id where the formula was fired from.")
    docRowId: String

    @documentation("Doc canvas column id where the formula was fired from.")
    docColumnId: String

    @documentation("True if this is a formula invocation loading a page of a sync table, or metadata for a sync table (like creating a dynamic schema).")
    isSyncTable: Boolean

    @documentation("True if this is an execution of a sync table which received a pagination parameter.")
    isContinuedSyncTable: Boolean

    @documentation("If this formula invocation was for a parameter auto-complete, this names the parameter.")
    autocompleteParameterName: String

    @documentation("If this formula was invoked by something other than a user action, this should say what that was.")
    invocationSource: String

    @documentation("Key to be used in fetching log details.")
    @required
    detailsKey: String

    @documentation("Child execution id for this ingestion log.")
    ingestionChildExecutionIndex: Double

    @documentation("Unique identifier of the ingestion that triggered this log.")
    ingestionId: String

    @documentation("Unique identifier of the root ingestion that triggered this log.")
    rootIngestionId: String

    @documentation("Unique identifier of the ingestion execution that triggered this log.")
    ingestionExecutionId: String

    @documentation("Stage along the ingestion lifecycle that this log was created in.")
    ingestionStage: String

    @documentation("An ingestion lifecycle stage that this ingestion log is bundled under.")
    ingestionParentStage: String

    @documentation("Execution attempt for this ingestion log.")
    ingestionExecutionAttempt: Integer

    @documentation("Parent item id for this ingestion log.")
    ingestionParentItemId: String

    @documentation("Unique identifier of the ingestion processing call that triggered this log.")
    ingestionProcessId: String

    @documentation("Additional metadata for the ingestion log.")
    additionalMetadata: PackLogContextAdditionalMetadata

    @documentation("Agent chat session id.")
    agentSessionId: String

    @documentation("Agent instance id.")
    agentInstanceId: String

    @documentation("Executing agent instance id.")
    executingAgentInstanceId: String
}

@documentation("Additional metadata for the ingestion log.")
structure PackLogContextAdditionalMetadata {}

@documentation("Details for a pack log.")
union PackLogDetails {
    packFetcherLogDetails: PackFetcherLogDetails
    packInvocationLogDetails: PackInvocationLogDetails
    packAgentRuntimeLogDetails: PackAgentRuntimeLogDetails
}

@documentation("The context request type where a Pack log is generated.")
enum PackLogRequestType {
    @enumValue("unknown")
    UNKNOWN

    @enumValue("connectionNameMetadataRequest")
    CONNECTION_NAME_METADATA_REQUEST

    @enumValue("parameterAutocompleteMetadataRequest")
    PARAMETER_AUTOCOMPLETE_METADATA_REQUEST

    @enumValue("postAuthSetupMetadataRequest")
    POST_AUTH_SETUP_METADATA_REQUEST

    @enumValue("propertyOptionsMetadataRequest")
    PROPERTY_OPTIONS_METADATA_REQUEST

    @enumValue("getSyncTableSchemaMetadataRequest")
    GET_SYNC_TABLE_SCHEMA_METADATA_REQUEST

    @enumValue("getDynamicSyncTableNameMetadataRequest")
    GET_DYNAMIC_SYNC_TABLE_NAME_METADATA_REQUEST

    @enumValue("listSyncTableDynamicUrlsMetadataRequest")
    LIST_SYNC_TABLE_DYNAMIC_URLS_METADATA_REQUEST

    @enumValue("searchSyncTableDynamicUrlsMetadataRequest")
    SEARCH_SYNC_TABLE_DYNAMIC_URLS_METADATA_REQUEST

    @enumValue("getDynamicSyncTableDisplayUrlMetadataRequest")
    GET_DYNAMIC_SYNC_TABLE_DISPLAY_URL_METADATA_REQUEST

    @enumValue("getIdentifiersForConnectionRequest")
    GET_IDENTIFIERS_FOR_CONNECTION_REQUEST

    @enumValue("invokeFormulaRequest")
    INVOKE_FORMULA_REQUEST

    @enumValue("invokeSyncFormulaRequest")
    INVOKE_SYNC_FORMULA_REQUEST

    @enumValue("invokeSyncUpdateFormulaRequest")
    INVOKE_SYNC_UPDATE_FORMULA_REQUEST

    @enumValue("invokeExecuteGetPermissionsRequest")
    INVOKE_EXECUTE_GET_PERMISSIONS_REQUEST

    @enumValue("validateParametersMetadataRequest")
    VALIDATE_PARAMETERS_METADATA_REQUEST

    @enumValue("mcp")
    MCP
}

enum PackLogType {
    @enumValue("custom")
    CUSTOM

    @enumValue("fetcher")
    FETCHER

    @enumValue("invocation")
    INVOCATION

    @enumValue("internal")
    INTERNAL

    @enumValue("auth")
    AUTH

    @enumValue("ingestionLifecycle")
    INGESTION_LIFECYCLE

    @enumValue("ingestionDebug")
    INGESTION_DEBUG

    @enumValue("agentRuntime")
    AGENT_RUNTIME

    @enumValue("mcp")
    MCP
}

@documentation("List of Pack logs.")
structure PackLogsList {
    @required
    items: PackLogsListItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PackLogsListItems {
    member: PackLog
}

@documentation("Pack log generated by an MCP (Model Context Protocol) operation.")
structure PackMcpLog {
    @required
    type: PackMcpLogType

    @required
    context: PackLogContext

    @documentation("A descriptive message about the MCP operation.")
    message: String

    @documentation("Error info if this invocation resulted in an error.")
    error: PackMcpLogError
}

@documentation("Error info if this invocation resulted in an error.")
structure PackMcpLogError {
    @required
    message: String

    stack: String
}

enum PackMcpLogType {
    @enumValue("mcp")
    MCP
}

structure PackNomosOrganizationPrincipal {
    @required
    type: PackNomosOrganizationPrincipalType

    @required
    nomosOrganizationId: String
}

enum PackNomosOrganizationPrincipalType {
    @enumValue("nomosOrganization")
    NOMOS_ORGANIZATION
}

@documentation("Location of including OAuth2 client credentials in a request.")
enum PackOAuth2ClientCredentialsLocation {
    @enumValue("automatic")
    AUTOMATIC

    @enumValue("body")
    BODY

    @enumValue("header")
    HEADER
}

@documentation("The Pack OAuth configuration metadata.")
structure PackOauthConfigMetadata {
    @documentation("Masked OAuth client id. If not set, empty string will be returned.")
    @required
    maskedClientId: String

    @documentation("Masked OAuth client secret. If not set, empty string will be returned.")
    @required
    maskedClientSecret: String

    @documentation("Authorization URL of the OAuth provider.")
    @required
    authorizationUrl: String

    @documentation("Token URL of the OAuth provider.")
    @required
    tokenUrl: String

    @documentation("Optional token prefix that's used to make the API request.")
    tokenPrefix: String

    @documentation("Optional scopes of the OAuth client.")
    scopes: String

    @documentation("Redirect URI of the Pack.")
    @required
    redirectUri: String

    @documentation("Whether this Pack uses Dynamic Client Registration for OAuth.")
    useDynamicClientRegistration: Boolean
}

@documentation("Describes restrictions that a user's organization has placed on a pack for Coda Brain ingestions")
structure PackOrganizationAccessForCodaBrain {
    @required
    canRequestAccess: Boolean

    @required
    hasRequestedAccess: Boolean

    @required
    requiresConfiguration: Boolean

    allowedConfigurations: PackOrganizationAccessForCodaBrainAllowedConfigurations

    allowedPackIds: PackOrganizationAccessForCodaBrainAllowedPackIds
}

list PackOrganizationAccessForCodaBrainAllowedConfigurations {
    member: PackConfigurationEntry
}

list PackOrganizationAccessForCodaBrainAllowedPackIds {
    member: Double
}

@documentation("Describes restrictions that a user's organization has placed on a pack")
structure PackOrganizationAccessForDocs {
    @required
    canRequestAccess: Boolean

    @required
    hasRequestedAccess: Boolean

    @required
    requiresConfiguration: Boolean

    allowedConfigurations: PackOrganizationAccessForDocsAllowedConfigurations

    allowedPackIds: PackOrganizationAccessForDocsAllowedPackIds

    incompatibleDocPermissions: PackOrganizationAccessForDocsIncompatibleDocPermissions

    incompatibleDocOwner: UserSummary

    incompatibleDocFolder: FolderReference

    isDocOwner: Boolean
}

list PackOrganizationAccessForDocsAllowedConfigurations {
    member: PackConfigurationEntry
}

list PackOrganizationAccessForDocsAllowedPackIds {
    member: Double
}

list PackOrganizationAccessForDocsIncompatibleDocPermissions {
    member: Permission
}

@documentation("Pack entrypoints where this pack is available")
list PackPackEntrypoints {
    member: PackEntrypoint
}

@documentation("Metadata about a Pack permission.")
structure PackPermission {
    @documentation("Id for the Permission")
    @required
    id: String

    @required
    principal: PackPrincipal

    @required
    access: PackAccessType
}

@documentation("List of Pack permissions.")
structure PackPermissionList {
    @required
    items: PackPermissionListItems

    @required
    permissionUsers: PackPermissionListPermissionUsers
}

list PackPermissionListItems {
    member: PackPermission
}

list PackPermissionListPermissionUsers {
    member: UserSummary
}

@documentation("Currency needed to subscribe to the Pack.")
enum PackPlanCurrency {
    @enumValue("USD")
    USD
}

@documentation("Type of pricing used to subscribe to a Pack.")
enum PackPlanPricingType {
    @enumValue("Free")
    FREE

    @enumValue("MonthlyDocMaker")
    MONTHLY_DOC_MAKER

    @enumValue("BundledWithTier")
    BUNDLED_WITH_TIER
}

@documentation("Metadata about a Pack principal.")
union PackPrincipal {
    packUserPrincipal: PackUserPrincipal
    packWorkspacePrincipal: PackWorkspacePrincipal
    packGlobalPrincipal: PackGlobalPrincipal
    packNomosOrganizationPrincipal: PackNomosOrganizationPrincipal
    packGroupPrincipal: PackGroupPrincipal
    packGrammarlyInstitutionPrincipal: PackGrammarlyInstitutionPrincipal
}

@documentation("Type of Pack permissions.")
enum PackPrincipalType {
    @enumValue("user")
    USER

    @enumValue("workspace")
    WORKSPACE

    @enumValue("worldwide")
    WORLDWIDE

    @enumValue("nomosOrganization")
    NOMOS_ORGANIZATION

    @enumValue("group")
    GROUP

    @enumValue("grammarlyInstitution")
    GRAMMARLY_INSTITUTION
}

@documentation("Rate limit in Pack settings.")
structure PackRateLimit {
    @documentation("The rate limit interval in seconds.")
    @required
    intervalSeconds: Integer

    @documentation("The maximum number of Pack operations that can be performed in a given interval.")
    @required
    operationsPerInterval: Integer
}

@documentation("Details about a Pack release.")
structure PackRelease {
    @documentation("ID of the Packs.")
    @required
    packId: Double

    @documentation("Developer notes.")
    @required
    releaseNotes: String

    @documentation("Timestamp for when the release was created.")
    @required
    createdAt: String

    @documentation("The release number of the Pack version if it has one.")
    @required
    releaseId: Double

    @documentation("The semantic format of the Pack version.")
    @required
    packVersion: String

    @documentation("What Packs SDK version was this version built on.")
    @required
    sdkVersion: String
}

@documentation("List of Pack releases.")
structure PackReleaseList {
    @required
    items: PackReleaseListItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PackReleaseListItems {
    member: PackRelease
}

@documentation("A pack review submission")
structure PackReview {
    @documentation("ID of the review")
    @required
    packReviewId: String

    @documentation("ID of the pack being reviewed")
    @required
    packId: Integer

    @documentation("Pack version being reviewed (for code reviews)")
    packVersion: String

    @documentation("Whether listing info was included in the review scope")
    includesListingReview: Boolean

    @required
    packReviewStatus: PackReviewStatus

    @documentation("User ID of the person who submitted the review")
    @required
    submittedByUserId: Integer

    @documentation("When the review was submitted")
    @required
    submissionTimestamp: String

    additionalInformation: PackReviewAdditionalInformation
}

@documentation("Additional information about the pack review")
structure PackReviewAdditionalInformation {
    @documentation("Whether the agent or third-party partners collect personal information.")
    privacyCollectsPersonalInfo: Boolean

    @documentation("Categories of personal information collected by the agent.")
    privacyPersonalInfoCategories: PackReviewAdditionalInformationPrivacyPersonalInfoCategories

    @documentation("Purposes for which collected data is used by the agent or third-party partners.")
    privacyDataUsagePurposes: PackReviewAdditionalInformationPrivacyDataUsagePurposes

    @documentation("Whether data is collected by the developer, a third party, or both.")
    privacyDataCollectedBy: PackReviewAdditionalInformationPrivacyDataCollectedBy
}

@documentation("Whether data is collected by the developer, a third party, or both.")
list PackReviewAdditionalInformationPrivacyDataCollectedBy {
    member: String
}

@documentation("Purposes for which collected data is used by the agent or third-party partners.")
list PackReviewAdditionalInformationPrivacyDataUsagePurposes {
    member: String
}

@documentation("Categories of personal information collected by the agent.")
list PackReviewAdditionalInformationPrivacyPersonalInfoCategories {
    member: String
}

@documentation("The status of a pack review")
enum PackReviewStatus {
    @enumValue("pending")
    PENDING

    @enumValue("approved")
    APPROVED

    @enumValue("denied")
    DENIED

    @enumValue("canceled")
    CANCELED

    @enumValue("superseded")
    SUPERSEDED
}

enum PackSource {
    @enumValue("web")
    WEB

    @enumValue("cli")
    CLI
}

@documentation("Details about a Pack's source code.")
structure PackSourceCode {
    @documentation("name of the file")
    @required
    filename: String

    @documentation("The URL to download the source code from")
    @required
    url: String
}

@documentation("Information indicating where to upload the Pack source code, and an endpoint to mark the upload as complete.")
structure PackSourceCodeInfo {
    @required
    files: PackSourceCodeInfoFiles
}

list PackSourceCodeInfoFiles {
    member: PackSourceCode
}

@documentation("Payload for noting a Pack source code upload is complete.")
structure PackSourceCodeUploadCompletePayload {
    @required
    filename: String

    @documentation("A SHA-256 hash of the source code used to identify duplicate uploads.")
    @required
    codeHash: String
}

@documentation("Response for noting a Pack source code upload is complete.")
structure PackSourceCodeUploadCompleteResponse {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String
}

@documentation("Information indicating where to upload the Pack source code, and an endpoint to mark the upload as complete.")
structure PackSourceCodeUploadInfo {
    @documentation("A signed URL to be used for uploading a Pack source code.")
    @required
    uploadUrl: String

    @documentation("An endpoint to mark the upload as complete.")
    @required
    uploadedPathName: String

    @documentation("Key-value pairs of authorization headers to include in the upload request.")
    @required
    headers: PackSourceCodeUploadInfoHeaders
}

map PackSourceCodeUploadInfoHeaders {
    key: String
    value: String
}

@documentation("Visibility of a pack's source code.")
enum PackSourceCodeVisibility {
    @enumValue("private")
    PRIVATE

    @enumValue("shared")
    SHARED
}

@documentation("Summary of a Pack.")
structure PackSummary {
    @documentation("ID of the Pack.")
    @required
    id: Double

    @documentation("The link to the logo of the Pack.")
    logoUrl: String

    @documentation("The link to the cover photo of the Pack.")
    coverUrl: String

    @documentation("The example images for the Pack.")
    exampleImages: PackSummaryExampleImages

    @documentation("The agent images for the Pack.")
    agentImages: PackSummaryAgentImages

    @documentation("The parent workspace for the Pack.")
    @required
    workspaceId: String

    @documentation("Publishing categories associated with this Pack.")
    @required
    categories: PackSummaryCategories

    @documentation("Denotes if the pack is certified by Coda.")
    certified: Boolean

    @documentation("Denotes if the pack is certified by Grammarly to be optimized for agent usage.")
    certifiedAgent: Boolean

    sourceCodeVisibility: PackSourceCodeVisibility

    @documentation("Pack entrypoints where this pack is available")
    packEntrypoints: PackSummaryPackEntrypoints

    @documentation("The latest released pack version that has been verified (approved) for use. For agent packs, this is the most recent release that passed review. For non-agent packs or legacy releases, this is the most recent release.")
    verifiedVersion: String

    @documentation("The name of the Pack.")
    @required
    name: String

    @documentation("The full description of the Pack.")
    @required
    description: String

    @documentation("A short version of the description of the Pack.")
    @required
    shortDescription: String

    @documentation("A short description for the pack as an agent.")
    agentShortDescription: String

    @documentation("A full description for the pack as an agent.")
    agentDescription: String

    @documentation("A contact email for the Pack.")
    supportEmail: String

    @documentation("A Terms of Service URL for the Pack.")
    termsOfServiceUrl: String

    @documentation("A Privacy Policy URL for the Pack.")
    privacyPolicyUrl: String
}

@documentation("The agent images for the Pack.")
list PackSummaryAgentImages {
    member: PackImageFile
}

@documentation("Publishing categories associated with this Pack.")
list PackSummaryCategories {
    member: PublishingCategory
}

@documentation("The example images for the Pack.")
list PackSummaryExampleImages {
    member: PackImageFile
}

@documentation("List of Pack summaries.")
structure PackSummaryList {
    @required
    items: PackSummaryListItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PackSummaryListItems {
    member: PackSummary
}

@documentation("Pack entrypoints where this pack is available")
list PackSummaryPackEntrypoints {
    member: PackEntrypoint
}

@documentation("Credentials of a Pack connection.")
union PackSystemConnectionCredentials {
    packConnectionHeaderCredentials: PackConnectionHeaderCredentials
    packConnectionMultiHeaderCredentials: PackConnectionMultiHeaderCredentials
    packConnectionUrlParamCredentials: PackConnectionUrlParamCredentials
    packConnectionHttpBasicCredentials: PackConnectionHttpBasicCredentials
    packConnectionCustomCredentials: PackConnectionCustomCredentials
    packConnectionOauth2ClientCredentials: PackConnectionOauth2ClientCredentials
    packConnectionGoogleServiceAccountCredentials: PackConnectionGoogleServiceAccountCredentials
    packConnectionAwsAssumeRoleCredentials: PackConnectionAwsAssumeRoleCredentials
    packConnectionAwsAccessKeyCredentials: PackConnectionAwsAccessKeyCredentials
}

@documentation("Metadata of a Pack system connection.")
union PackSystemConnectionMetadata {
    packConnectionHeaderMetadata: PackConnectionHeaderMetadata
    packConnectionMultiHeaderMetadata: PackConnectionMultiHeaderMetadata
    packConnectionUrlParamMetadata: PackConnectionUrlParamMetadata
    packConnectionHttpBasicMetadata: PackConnectionHttpBasicMetadata
    packConnectionCustomMetadata: PackConnectionCustomMetadata
    packConnectionOauth2ClientCredentialsMetadata: PackConnectionOauth2ClientCredentialsMetadata
    packConnectionGoogleServiceAccountMetadata: PackConnectionGoogleServiceAccountMetadata
    packConnectionAwsAssumeRoleMetadata: PackConnectionAwsAssumeRoleMetadata
    packConnectionAwsAccessKeyMetadata: PackConnectionAwsAccessKeyMetadata
}

@documentation("The access capabilities the current user has for this Pack.")
structure PackUserAccess {
    @required
    canEdit: Boolean

    @required
    canTest: Boolean

    @required
    canView: Boolean

    @required
    canInstall: Boolean

    @required
    canPurchase: Boolean

    @required
    requiresTrial: Boolean

    @required
    canConnectAccount: Boolean

    organization: PackUserAccessOrganization

    ingestionLimitSettings: IngestionLimitSettings
}

union PackUserAccessOrganization {
    packOrganizationAccessForDocs: PackOrganizationAccessForDocs
    packOrganizationAccessForCodaBrain: PackOrganizationAccessForCodaBrain
}

structure PackUserPrincipal {
    @required
    type: PackUserPrincipalType

    @required
    email: String
}

enum PackUserPrincipalType {
    @enumValue("user")
    USER
}

@documentation("Details about a Pack version.")
structure PackVersion {
    @documentation("ID of the Pack.")
    @required
    packId: Double

    @documentation("Developer notes.")
    @required
    buildNotes: String

    @documentation("Timestamp for when the version was created.")
    @required
    createdAt: String

    @documentation("The login ID of creation user of the Pack version.")
    @required
    creationUserLoginId: String

    @documentation("The release number of the Pack version if it has one.")
    releaseId: Double

    @documentation("The semantic format of the Pack version.")
    @required
    packVersion: String

    @documentation("What Packs SDK version was this version built on.")
    sdkVersion: String

    source: PackSource
}

@documentation("Info about the diff between two Pack versions.")
structure PackVersionDiffs {
    @documentation("List of changes from the previous version to the next version.")
    @required
    findings: PackVersionDiffsFindings

    @required
    findingDetails: PackVersionDiffsFindingDetails
}

list PackVersionDiffsFindingDetails {
    member: PackVersionDiffsFindingDetailsMember
}

structure PackVersionDiffsFindingDetailsMember {
    @required
    finding: String

    @required
    path: String
}

@documentation("List of changes from the previous version to the next version.")
list PackVersionDiffsFindings {
    member: String
}

@documentation("List of Pack versions.")
structure PackVersionList {
    @required
    items: PackVersionListItems

    @required
    creationUsers: PackVersionListCreationUsers

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PackVersionListCreationUsers {
    member: UserSummary
}

list PackVersionListItems {
    member: PackVersion
}

@documentation("Information indicating where to upload the Pack version definition.")
structure PackVersionUploadInfo {
    @documentation("A URL to be used for uploading a Pack version definition.")
    @required
    uploadUrl: String

    @documentation("Key-value pairs of authorization headers to include in the upload request.")
    @required
    headers: PackVersionUploadInfoHeaders
}

map PackVersionUploadInfoHeaders {
    key: String
    value: String
}

structure PackWorkspacePrincipal {
    @required
    type: PackWorkspacePrincipalType

    @required
    workspaceId: String
}

enum PackWorkspacePrincipalType {
    @enumValue("workspace")
    WORKSPACE
}

@documentation("Determines how the Packs returned are sorted.")
enum PacksSortBy {
    @enumValue("title")
    TITLE

    @enumValue("createdAt")
    CREATED_AT

    @enumValue("updatedAt")
    UPDATED_AT
}

@documentation("Metadata about a page.")
structure Page {
    @documentation("ID of the page.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: PageType2

    @documentation("API link to the page.")
    @required
    href: String

    @documentation("Browser-friendly link to the page.")
    @required
    browserLink: String

    @documentation("Name of the page.")
    @required
    name: String

    @documentation("Subtitle of the page.")
    subtitle: String

    icon: Icon

    image: Image

    @required
    contentType: PageType

    @documentation("Whether the page is hidden in the UI.")
    @required
    isHidden: Boolean

    @documentation("Whether the page or any of its parents is hidden in the UI.")
    @required
    isEffectivelyHidden: Boolean

    parent: PageReference

    @required
    children: PageChildren

    @documentation("Authors of the page")
    authors: PageAuthors

    @documentation("Timestamp for when the page was created.")
    createdAt: String

    createdBy: PersonValue

    @documentation("Timestamp for when page content was last modified.")
    updatedAt: String

    updatedBy: PersonValue
}

@documentation("List of analytics for pages within a Coda doc over a date range.")
structure PageAnalyticsCollection {
    @required
    items: PageAnalyticsCollectionItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PageAnalyticsCollectionItems {
    member: PageAnalyticsItem
}

@documentation("Metadata about a page relevant to analytics.")
structure PageAnalyticsDetails {
    @documentation("ID of the page.")
    @required
    id: String

    @documentation("Name of the page.")
    @required
    name: String

    icon: Icon
}

@documentation("Analytics data for a page within a Coda doc.")
structure PageAnalyticsItem {
    @required
    page: PageAnalyticsDetails

    @required
    metrics: PageAnalyticsItemMetrics
}

list PageAnalyticsItemMetrics {
    member: PageAnalyticsMetrics
}

@documentation("Analytics metrics for a page within a Coda doc.")
structure PageAnalyticsMetrics {
    @documentation("Date of the analytics data.")
    @required
    date: String

    @documentation("Number of times the page was viewed within the given day.")
    @required
    views: Integer

    @documentation("Number of unique browsers that viewed the page on the given day.")
    @required
    sessions: Integer

    @documentation("Number of unique Coda users that viewed the page on the given day.")
    @required
    users: Integer

    @documentation("Average number of seconds that the page was viewed on the given day.")
    @required
    averageSecondsViewed: Integer

    @documentation("Median number of seconds that the page was viewed on the given day.")
    @required
    medianSecondsViewed: Integer

    @documentation("Number of unique tabs that opened the doc on the given day.")
    @required
    tabs: Integer
}

@documentation("Authors of the page")
list PageAuthors {
    member: PersonValue
}

list PageChildren {
    member: PageReference
}

@documentation("Content to be added or replaced with in a page (canvas).")
structure PageContent {
    @required
    format: PageContentFormat

    @documentation("The actual page content.")
    @required
    content: String
}

@documentation("Payload for deleting content from a page.")
structure PageContentDelete {
    @documentation("IDs of the elements to delete from the page. If omitted or empty, all content will be deleted.")
    elementIds: PageContentDeleteElementIds
}

@documentation("IDs of the elements to delete from the page. If omitted or empty, all content will be deleted.")
list PageContentDeleteElementIds {
    member: String
}

@documentation("The result of a page content deletion.")
structure PageContentDeleteResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("ID of the page whose content was deleted.")
    @required
    id: String
}

@documentation("Status of a page content export.")
enum PageContentExportStatus {
    @enumValue("inProgress")
    IN_PROGRESS

    @enumValue("failed")
    FAILED

    @enumValue("complete")
    COMPLETE
}

@documentation("Response when requesting the status of a page content export.")
structure PageContentExportStatusResponse {
    @documentation("The identifier of this export request.")
    @required
    id: String

    @documentation("The status of this export.")
    @required
    status: String

    @documentation("The URL that reports the status of this export.")
    @required
    href: String

    @documentation("Once the export completes, the location where the resulting export file can be downloaded; this link typically expires after a short time. Call this method again to get a fresh link.")
    downloadLink: String

    @documentation("Message describing an error, if this export failed.")
    error: String
}

@documentation("Supported content types for page (canvas) content.")
enum PageContentFormat {
    @enumValue("html")
    HTML

    @enumValue("markdown")
    MARKDOWN
}

@documentation("Mode for updating the content on an existing page.")
enum PageContentInsertionMode {
    @enumValue("append")
    APPEND

    @enumValue("prepend")
    PREPEND

    @enumValue("replace")
    REPLACE
}

@documentation("Content item in a page (canvas).")
structure PageContentItem {
    @documentation("ID of the content item.")
    @required
    id: String

    @required
    type: PageContentItemType

    itemContent: PageContentItemContent
}

@documentation("Content details of the item.")
structure PageContentItemContent {
    @required
    style: PageLineStyle

    @required
    format: PageContentItemContentFormat

    @documentation("Content of the item in the specified format.")
    @required
    content: String

    @documentation("Indentation level of the element. Present for indentable elements (paragraphs, blockquotes, and list items).")
    lineLevel: Integer
}

@documentation("Content format for the item.")
enum PageContentItemContentFormat {
    @enumValue("plainText")
    PLAIN_TEXT
}

@documentation("The type of content item in a page.")
enum PageContentItemType {
    @enumValue("line")
    LINE
}

@documentation("List of page content elements.")
structure PageContentList {
    @required
    items: PageContentListItems

    @documentation("API link to these results")
    @required
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PageContentListItems {
    member: PageContentItem
}

@documentation("Supported output content formats that can be requested for getting content for an existing page.")
enum PageContentOutputFormat {
    @enumValue("html")
    HTML

    @enumValue("markdown")
    MARKDOWN
}

@documentation("Payload for updating the content of an existing page.")
structure PageContentUpdate {
    @required
    insertionMode: PageContentInsertionMode

    @documentation("ID of the element on the page to use as a reference point for editing content. If provided, the operation will be relative to this element (e.g., append after it, prepend before it, replace it). If omitted, the operation will be performed on the entire page (e.g., append to end, prepend to beginning, replace all).")
    elementId: String

    @required
    canvasContent: PageContent
}

@documentation("Payload for creating a new page in a doc.")
structure PageCreate {
    @documentation("Name of the page.")
    name: String

    @documentation("Subtitle of the page.")
    subtitle: String

    @documentation("Name of the icon.")
    iconName: String

    @documentation("Url of the cover image to use.")
    imageUrl: String

    @documentation("The ID of this new page's parent, if creating a subpage.")
    parentPageId: String

    pageContent: PageCreateContent
}

@documentation("Content that can be added to a page at creation time, either text (or rich text) or a URL to create a full-page embed.")
union PageCreateContent {
    variant1: PageCreateContentVariant1
    variant2: PageCreateContentVariant2
    variant3: PageCreateContentVariant3
}

structure PageCreateContentVariant1 {
    @documentation("Indicates a page containing canvas content.")
    @required
    type: PageCreateContentVariant1Type

    @required
    canvasContent: PageContent
}

@documentation("Indicates a page containing canvas content.")
enum PageCreateContentVariant1Type {
    @enumValue("canvas")
    CANVAS
}

structure PageCreateContentVariant2 {
    @documentation("Indicates a page that embeds other content.")
    @required
    type: PageCreateContentVariant2Type

    @documentation("The URL of the content to embed.")
    @required
    url: String

    renderMethod: PageEmbedRenderMethod
}

@documentation("Indicates a page that embeds other content.")
enum PageCreateContentVariant2Type {
    @enumValue("embed")
    EMBED
}

union PageCreateContentVariant3 {
    variant1: PageCreateContentVariant3Variant1
    variant2: PageCreateContentVariant3Variant2
}

structure PageCreateContentVariant3Variant1 {
    @documentation("Indicates a page that embeds other Coda content.")
    @required
    type: PageCreateContentVariant3Variant1Type

    @documentation("Indicates a single-page sync page.")
    @required
    mode: PageCreateContentVariant3Variant1Mode

    @documentation("Include subpages in the sync page.")
    @required
    includeSubpages: Boolean

    @documentation("The page id to insert as a sync page.")
    @required
    sourcePageId: String

    @documentation("The id of the document to insert as a sync page.")
    @required
    sourceDocId: String
}

@documentation("Indicates a single-page sync page.")
enum PageCreateContentVariant3Variant1Mode {
    @enumValue("page")
    PAGE
}

@documentation("Indicates a page that embeds other Coda content.")
enum PageCreateContentVariant3Variant1Type {
    @enumValue("syncPage")
    SYNC_PAGE
}

structure PageCreateContentVariant3Variant2 {
    @documentation("Indicates a page that embeds other content.")
    @required
    type: PageCreateContentVariant3Variant2Type

    @documentation("Indicates a full doc sync page.")
    @required
    mode: PageCreateContentVariant3Variant2Mode

    @documentation("The id of the document to insert as a sync page.")
    @required
    sourceDocId: String
}

@documentation("Indicates a full doc sync page.")
enum PageCreateContentVariant3Variant2Mode {
    @enumValue("document")
    DOCUMENT
}

@documentation("Indicates a page that embeds other content.")
enum PageCreateContentVariant3Variant2Type {
    @enumValue("syncPage")
    SYNC_PAGE
}

@documentation("The result of a page creation.")
structure PageCreateResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("ID of the created page.")
    @required
    id: String
}

@documentation("The result of a page deletion.")
structure PageDeleteResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("ID of the page to be deleted.")
    @required
    id: String
}

@documentation("Render mode for a page using the Embed page type.")
enum PageEmbedRenderMethod {
    @enumValue("compatibility")
    COMPATIBILITY

    @enumValue("standard")
    STANDARD
}

@documentation("The style of a line element in a canvas page.")
enum PageLineStyle {
    @enumValue("blockQuote")
    BLOCK_QUOTE

    @enumValue("bulletedList")
    BULLETED_LIST

    @enumValue("checkboxList")
    CHECKBOX_LIST

    @enumValue("code")
    CODE

    @enumValue("collapsibleList")
    COLLAPSIBLE_LIST

    @enumValue("h1")
    H1

    @enumValue("h2")
    H2

    @enumValue("h3")
    H3

    @enumValue("numberedList")
    NUMBERED_LIST

    @enumValue("paragraph")
    PARAGRAPH

    @enumValue("pullQuote")
    PULL_QUOTE
}

@documentation("List of pages.")
structure PageList {
    @required
    items: PageListItems

    @documentation("API link to these results")
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list PageListItems {
    member: Page
}

@documentation("Reference to a page.")
structure PageReference {
    @documentation("ID of the page.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: PageReferenceType

    @documentation("API link to the page.")
    @required
    href: String

    @documentation("Browser-friendly link to the page.")
    @required
    browserLink: String

    @documentation("Name of the page.")
    @required
    name: String
}

@documentation("The type of this resource.")
enum PageReferenceType {
    @enumValue("page")
    PAGE
}

@documentation("The type of a page in a doc.")
enum PageType {
    @enumValue("canvas")
    CANVAS

    @enumValue("embed")
    EMBED

    @enumValue("syncPage")
    SYNC_PAGE
}

@documentation("The type of this resource.")
enum PageType2 {
    @enumValue("page")
    PAGE
}

@documentation("Payload for updating a page.")
structure PageUpdate {
    @documentation("Name of the page.")
    name: String

    @documentation("Subtitle of the page.")
    subtitle: String

    @documentation("Name of the icon.")
    iconName: String

    @documentation("Url of the cover image to use.")
    imageUrl: String

    @documentation("Whether the page is hidden or not. Note that for pages that cannot be hidden, like the sole top-level page in a doc, this will be ignored.")
    isHidden: Boolean

    contentUpdate: PageContentUpdate
}

@documentation("The result of a page update.")
structure PageUpdateResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("ID of the updated page.")
    @required
    id: String
}

@documentation("Workspace feature set excluding free.")
enum PaidFeatureSet {
    @enumValue("Pro")
    PRO

    @enumValue("Team")
    TEAM

    @enumValue("Enterprise")
    ENTERPRISE
}

@documentation("Setting for a specific parameter")
structure ParameterSetting {
    @documentation("Default value for the parameter")
    @required
    default: String

    @required
    allowed: ParameterSettingAllowed
}

list ParameterSettingAllowed {
    member: String
}

@documentation("The request to patch pack system connection credentials.")
union PatchPackSystemConnectionPayload {
    packConnectionHeaderPatch: PackConnectionHeaderPatch
    packConnectionMultiHeaderPatch: PackConnectionMultiHeaderPatch
    packConnectionUrlParamPatch: PackConnectionUrlParamPatch
    packConnectionHttpBasicPatch: PackConnectionHttpBasicPatch
    packConnectionCustomPatch: PackConnectionCustomPatch
    packConnectionOauth2ClientCredentialsPatch: PackConnectionOauth2ClientCredentialsPatch
    packConnectionGoogleServiceAccountPatch: PackConnectionGoogleServiceAccountPatch
    packConnectionAwsAssumeRolePatch: PackConnectionAwsAssumeRolePatch
    packConnectionAwsAccessKeyPatch: PackConnectionAwsAccessKeyPatch
}

@documentation("A specific permission granted to a principal.")
structure Permission {
    @required
    principal: Principal

    @documentation("Id for the Permission")
    @required
    id: String

    @required
    access: AccessType
}

@documentation("A named reference to a person, where the person is identified by email address.")
structure PersonValue {
    @documentation("A url describing the schema context for this object, typically \"http://schema.org/\".")
    @required
    @jsonName("@context")
    context: String

    @required
    @jsonName("@type")
    type: PersonValueType

    @documentation("An identifier of additional type info specific to Coda that may not be present in a schema.org taxonomy,")
    additionalType: String

    @documentation("The full name of the person.")
    @required
    name: String

    @documentation("The email address of the person.")
    email: String
}

enum PersonValueType {
    @enumValue("Person")
    PERSON
}

@documentation("Metadata about a principal.")
union Principal {
    emailPrincipal: EmailPrincipal
    groupPrincipal: GroupPrincipal
    domainPrincipal: DomainPrincipal
    workspacePrincipal: WorkspacePrincipal
    anyonePrincipal: AnyonePrincipal
    internalAccessPrincipal: InternalAccessPrincipal
}

@documentation("Type of principal.")
enum PrincipalType {
    @enumValue("email")
    EMAIL

    @enumValue("group")
    GROUP

    @enumValue("domain")
    DOMAIN

    @enumValue("workspace")
    WORKSPACE

    @enumValue("anyone")
    ANYONE

    @enumValue("internalAccess")
    INTERNAL_ACCESS
}

@documentation("The result of publishing a doc.")
structure PublishResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String
}

@documentation("Info about a publishing category")
structure PublishingCategory {
    @documentation("The ID for this category.")
    @required
    categoryId: String

    @documentation("The name of the category.")
    @required
    categoryName: String

    @documentation("The URL identifier of the category.")
    categorySlug: String
}

@documentation("The result of a push button.")
structure PushButtonResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("ID of the row where the button exists.")
    @required
    rowId: String

    @documentation("ID of the column where the button exists.")
    @required
    columnId: String
}

@documentation("Format of a column that refers to another table.")
structure ReferenceColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @required
    table: TableReference
}

@documentation("Payload for registering a Pack version.")
structure RegisterPackVersionPayload {
    @documentation("The SHA-256 hash of the file to be uploaded.")
    @required
    bundleHash: String
}

@documentation("A value that contains rich structured data. Cell values are composed of these values or arrays of these values.")
union RichSingleValue {
    scalarValue: ScalarValue
    currencyValue: CurrencyValue
    imageUrlValue: ImageUrlValue
    personValue: PersonValue
    urlValue: UrlValue
    rowValue: RowValue
}

@documentation("A cell value that contains rich structured data.")
union RichValue {
    richSingleValue: RichSingleValue
    variant2: RichValueVariant2
}

list RichValueVariant2 {
    member: RichValueVariant2Member
}

union RichValueVariant2Member {
    richSingleValue: RichSingleValue
    variant2: RichValueVariant2MemberVariant2
}

list RichValueVariant2MemberVariant2 {
    member: RichSingleValue
}

@documentation("Info about a row.")
structure Row {
    @documentation("ID of the row.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: RowType

    @documentation("API link to the row.")
    @required
    href: String

    @documentation("The display name of the row, based on its identifying column.")
    @required
    name: String

    @documentation("Index of the row within the table.")
    @required
    index: Integer

    @documentation("Browser-friendly link to the row.")
    @required
    browserLink: String

    @documentation("Timestamp for when the row was created.")
    @required
    createdAt: String

    @documentation("Timestamp for when the row was last modified.")
    @required
    updatedAt: String

    @documentation("Values for a specific row, represented as a hash of column IDs (or names with `useColumnNames`) to values.")
    @required
    values: RowValues
}

@documentation("The result of a row deletion.")
structure RowDeleteResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("ID of the row to be deleted.")
    @required
    id: String
}

@documentation("Details about a row.")
structure RowDetail {
    @documentation("ID of the row.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: RowDetailType

    @documentation("API link to the row.")
    @required
    href: String

    @documentation("The display name of the row, based on its identifying column.")
    @required
    name: String

    @documentation("Index of the row within the table.")
    @required
    index: Integer

    @documentation("Browser-friendly link to the row.")
    @required
    browserLink: String

    @documentation("Timestamp for when the row was created.")
    @required
    createdAt: String

    @documentation("Timestamp for when the row was last modified.")
    @required
    updatedAt: String

    @documentation("Values for a specific row, represented as a hash of column IDs (or names with `useColumnNames`) to values.")
    @required
    values: RowDetailValues

    @required
    parent: TableReference
}

@documentation("The type of this resource.")
enum RowDetailType {
    @enumValue("row")
    ROW
}

map RowDetailValues {
    key: String
    value: CellValue
}

@documentation("An edit made to a particular row.")
structure RowEdit {
    @required
    cells: RowEditCells
}

list RowEditCells {
    member: CellEdit
}

@documentation("List of rows.")
structure RowList {
    @required
    items: RowListItems

    @documentation("API link to these results")
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink

    nextSyncToken: NextSyncToken
}

list RowListItems {
    member: Row
}

@documentation("The type of this resource.")
enum RowType {
    @enumValue("row")
    ROW
}

@documentation("Payload for updating a row in a table.")
structure RowUpdate {
    @required
    row: RowEdit
}

@documentation("The result of a row update.")
structure RowUpdateResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("ID of the updated row.")
    @required
    id: String
}

@documentation("A value representing a Coda row.")
structure RowValue {
    @documentation("A url describing the schema context for this object, typically \"http://schema.org/\".")
    @required
    @jsonName("@context")
    context: String

    @required
    @jsonName("@type")
    type: RowValueType

    @documentation("The type of this resource.")
    @required
    additionalType: RowValueAdditionalType

    @documentation("The display name of the row, based on its identifying column.")
    @required
    name: String

    @documentation("The url of the row.")
    @required
    url: String

    @documentation("The ID of the table")
    @required
    tableId: String

    @documentation("The ID of the table")
    @required
    rowId: String

    @documentation("The url of the table.")
    @required
    tableUrl: String
}

@documentation("The type of this resource.")
enum RowValueAdditionalType {
    @enumValue("row")
    ROW
}

enum RowValueType {
    @enumValue("StructuredValue")
    STRUCTURED_VALUE
}

map RowValues {
    key: String
    value: CellValue
}

@documentation("Payload for deleting rows from a table.")
structure RowsDelete {
    @documentation("Row IDs to delete.")
    @required
    rowIds: RowsDeleteRowIds
}

@documentation("The result of a rows delete operation.")
structure RowsDeleteResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("Row IDs to delete.")
    @required
    rowIds: RowsDeleteResultRowIds
}

@documentation("Row IDs to delete.")
list RowsDeleteResultRowIds {
    member: String
}

@documentation("Row IDs to delete.")
list RowsDeleteRowIds {
    member: String
}

@documentation("Determines how the rows returned are sorted")
enum RowsSortBy {
    @enumValue("createdAt")
    CREATED_AT

    @enumValue("natural")
    NATURAL

    @enumValue("updatedAt")
    UPDATED_AT
}

@documentation("Payload for upserting rows in a table.")
structure RowsUpsert {
    @required
    rows: RowsUpsertRows

    @documentation("Optional column IDs, URLs, or names (fragile and discouraged), specifying columns to be used as upsert keys.")
    keyColumns: RowsUpsertKeyColumns
}

@documentation("Optional column IDs, URLs, or names (fragile and discouraged), specifying columns to be used as upsert keys.")
list RowsUpsertKeyColumns {
    member: String
}

@documentation("The result of a rows insert/upsert operation.")
structure RowsUpsertResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String

    @documentation("Row IDs for rows that will be added. Only applicable when keyColumns is not set or empty.")
    addedRowIds: RowsUpsertResultAddedRowIds
}

@documentation("Row IDs for rows that will be added. Only applicable when keyColumns is not set or empty.")
list RowsUpsertResultAddedRowIds {
    member: String
}

list RowsUpsertRows {
    member: RowEdit
}

@documentation("A Coda result or entity expressed as a primitive type.")
union ScalarValue {
    variant1: String
    variant2: Double
    variant3: Boolean
}

@documentation("Format of a numeric column that renders as a scale, like star ratings.")
structure ScaleColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @documentation("The maximum number allowed for this scale.")
    @required
    maximum: Double

    @required
    icon: IconSet
}

@documentation("Metadata about the principals that match the given query.")
structure SearchPrincipalsResponse {
    @required
    users: SearchPrincipalsResponseUsers

    @required
    groups: SearchPrincipalsResponseGroups
}

list SearchPrincipalsResponseGroups {
    member: GroupPrincipal
}

list SearchPrincipalsResponseUsers {
    member: UserSummary
}

@documentation("Format of a select column.")
structure SelectColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @documentation("For select format columns, the list of available options. Only returned for select lists that used a fixed set of options. Returns the first 5000 options.")
    options: SelectColumnFormatOptions
}

@documentation("For select format columns, the list of available options. Only returned for select lists that used a fixed set of options. Returns the first 5000 options.")
list SelectColumnFormatOptions {
    member: SelectOption
}

@documentation("An option for a select column.")
structure SelectOption {
    @documentation("The name of the option.")
    @required
    name: String

    @documentation("The background color of the option.")
    backgroundColor: String

    @documentation("The foreground color of the option.")
    foregroundColor: String
}

@documentation("Request to set the Pack OAuth configuration.")
structure SetPackOauthConfigPayload {
    clientId: String
    clientSecret: String
    redirectUri: String
}

@documentation("The request to set pack system connection credentials.")
structure SetPackSystemConnectionPayload {
    @required
    credentials: PackSystemConnectionCredentials
}

@documentation("Format of a simple column.")
structure SimpleColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean
}

@documentation("Format of a numeric column that renders as a slider.")
structure SliderColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    minimum: NumberOrNumberFormula

    maximum: NumberOrNumberFormula

    step: NumberOrNumberFormula

    displayType: SliderDisplayType

    @documentation("Whether the underyling numeric value is also displayed.")
    showValue: Boolean
}

@documentation("How the slider should be rendered.")
enum SliderDisplayType {
    @enumValue("slider")
    SLIDER

    @enumValue("progress")
    PROGRESS
}

@documentation("A sort applied to a table or view.")
structure Sort {
    @required
    column: ColumnReference

    @required
    direction: SortDirection
}

@documentation("Determines how the objects returned are sorted")
enum SortBy {
    @enumValue("name")
    NAME
}

@documentation("Direction of a sort for a table or view.")
enum SortDirection {
    @enumValue("ascending")
    ASCENDING

    @enumValue("descending")
    DESCENDING
}

@documentation("The Pack plan to show the Pack can be subscribed to at a monthly cost per Doc Maker or for free.")
structure StandardPackPlan {
    @required
    packPlanId: String

    @required
    packId: Double

    @documentation("Pricing to show how workspaces can subscribe to the Pack.")
    @required
    pricing: StandardPackPlanPricing

    @documentation("Timestamp for when the Pack plan was created.")
    @required
    createdAt: String
}

@documentation("Pricing to show how workspaces can subscribe to the Pack.")
union StandardPackPlanPricing {
    freePackPlanPricing: FreePackPlanPricing
    monthlyDocMakerPackPlanPricing: MonthlyDocMakerPackPlanPricing
}

@documentation("The type of sync page in a doc")
enum SyncPageType {
    @enumValue("page")
    PAGE

    @enumValue("document")
    DOCUMENT
}

@documentation("Metadata about a table.")
structure Table {
    @documentation("ID of the table.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: TableType2

    @required
    tableType: TableType

    @documentation("API link to the table.")
    @required
    href: String

    @documentation("Browser-friendly link to the table.")
    @required
    browserLink: String

    @documentation("Name of the table.")
    @required
    name: String

    @required
    parent: PageReference

    parentTable: TableReference

    @required
    displayColumn: ColumnReference

    @documentation("Total number of rows in the table.")
    @required
    rowCount: Integer

    @documentation("Any sorts applied to the table.")
    @required
    sorts: TableSorts

    @required
    layout: Layout

    filter: FormulaDetail

    @documentation("Timestamp for when the table was created.")
    @required
    createdAt: String

    @documentation("Timestamp for when the table was last modified.")
    @required
    updatedAt: String
}

@documentation("List of tables.")
structure TableList {
    @required
    items: TableListItems

    @documentation("API link to these results")
    href: String

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list TableListItems {
    member: TableReference
}

@documentation("Reference to a table or view.")
structure TableReference {
    @documentation("ID of the table.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: TableReferenceType

    @required
    tableType: TableType

    @documentation("API link to the table.")
    @required
    href: String

    @documentation("Browser-friendly link to the table.")
    @required
    browserLink: String

    @documentation("Name of the table.")
    @required
    name: String

    parent: PageReference
}

@documentation("The type of this resource.")
enum TableReferenceType {
    @enumValue("table")
    TABLE
}

@documentation("Any sorts applied to the table.")
list TableSorts {
    member: Sort
}

enum TableType {
    @enumValue("table")
    TABLE

    @enumValue("view")
    VIEW
}

@documentation("The type of this resource.")
enum TableType2 {
    @enumValue("table")
    TABLE
}

@documentation("Format of a time column.")
structure TimeColumnFormat {
    @required
    type: ColumnFormatType

    @documentation("Whether or not this column is an array.")
    @required
    isArray: Boolean

    @documentation("A format string using Moment syntax: https://momentjs.com/docs/#/displaying/")
    format: String
}

@documentation("A constant identifying the type of the resource.")
enum Type {
    @enumValue("aclMetadata")
    ACL_METADATA

    @enumValue("aclPermissions")
    ACL_PERMISSIONS

    @enumValue("aclSettings")
    ACL_SETTINGS

    @enumValue("agentPackLog")
    AGENT_PACK_LOG

    @enumValue("analyticsLastUpdated")
    ANALYTICS_LAST_UPDATED

    @enumValue("apiLink")
    API_LINK

    @enumValue("automation")
    AUTOMATION

    @enumValue("column")
    COLUMN

    @enumValue("control")
    CONTROL

    @enumValue("doc")
    DOC

    @enumValue("customDocDomain")
    CUSTOM_DOC_DOMAIN

    @enumValue("customDocDomainProvider")
    CUSTOM_DOC_DOMAIN_PROVIDER

    @enumValue("docAnalytics")
    DOC_ANALYTICS

    @enumValue("docAnalyticsSummary")
    DOC_ANALYTICS_SUMMARY

    @enumValue("docAnalyticsV2")
    DOC_ANALYTICS_V2

    @enumValue("folder")
    FOLDER

    @enumValue("formula")
    FORMULA

    @enumValue("goLink")
    GO_LINK

    @enumValue("ingestionBatchExecution")
    INGESTION_BATCH_EXECUTION

    @enumValue("ingestionExecution")
    INGESTION_EXECUTION

    @enumValue("ingestionExecutionAttempt")
    INGESTION_EXECUTION_ATTEMPT

    @enumValue("ingestionPackLog")
    INGESTION_PACK_LOG

    @enumValue("ingestionParentItem")
    INGESTION_PARENT_ITEM

    @enumValue("mutationStatus")
    MUTATION_STATUS

    @enumValue("pack")
    PACK

    @enumValue("packAclPermissions")
    PACK_ACL_PERMISSIONS

    @enumValue("packAnalytics")
    PACK_ANALYTICS

    @enumValue("packAnalyticsSummary")
    PACK_ANALYTICS_SUMMARY

    @enumValue("packAsset")
    PACK_ASSET

    @enumValue("packCategory")
    PACK_CATEGORY

    @enumValue("packConfigurationSchema")
    PACK_CONFIGURATION_SCHEMA

    @enumValue("packFeaturedDocs")
    PACK_FEATURED_DOCS

    @enumValue("packFormulaAnalytics")
    PACK_FORMULA_ANALYTICS

    @enumValue("packInvitation")
    PACK_INVITATION

    @enumValue("packListingDraft")
    PACK_LISTING_DRAFT

    @enumValue("packLog")
    PACK_LOG

    @enumValue("packMaker")
    PACK_MAKER

    @enumValue("packOauthConfig")
    PACK_OAUTH_CONFIG

    @enumValue("packRelease")
    PACK_RELEASE

    @enumValue("packReview")
    PACK_REVIEW

    @enumValue("packSourceCode")
    PACK_SOURCE_CODE

    @enumValue("packSystemConnection")
    PACK_SYSTEM_CONNECTION

    @enumValue("packVersion")
    PACK_VERSION

    @enumValue("page")
    PAGE

    @enumValue("pageContentExport")
    PAGE_CONTENT_EXPORT

    @enumValue("pageContentExportStatus")
    PAGE_CONTENT_EXPORT_STATUS

    @enumValue("principal")
    PRINCIPAL

    @enumValue("row")
    ROW

    @enumValue("table")
    TABLE

    @enumValue("user")
    USER

    @enumValue("workspace")
    WORKSPACE
}

@documentation("The result of unpublishing a doc.")
structure UnpublishResult {}

@documentation("Request to update ACL settings for a doc.")
structure UpdateAclSettingsPayload {
    @documentation("When true, allows editors to change doc permissions. When false, only doc owner can change doc permissions.")
    allowEditorsToChangePermissions: Boolean

    @documentation("When true, allows doc viewers to copy the doc.")
    allowCopying: Boolean

    @documentation("When true, allows doc viewers to request editing permissions.")
    allowViewersToRequestEditing: Boolean
}

@documentation("Payload for updating the properties of a custom published doc domain.")
structure UpdateCustomDocDomainPayload {}

@documentation("The result of updating a custom domain for a published doc.")
structure UpdateCustomDocDomainResponse {}

@documentation("Request for updating a folder.")
structure UpdateFolderPayload {
    @documentation("Name of the folder.")
    name: String

    @documentation("Description of the folder.")
    description: String
}

@documentation("Payload for updating featured docs for a Pack.")
structure UpdatePackFeaturedDocsPayload {
    @documentation("A list of docs to set as the featured docs for a Pack.")
    @required
    items: UpdatePackFeaturedDocsPayloadItems
}

@documentation("A list of docs to set as the featured docs for a Pack.")
list UpdatePackFeaturedDocsPayloadItems {
    member: PackFeaturedDocRequestItem
}

@documentation("Confirmation of successful Pack featured docs update.")
structure UpdatePackFeaturedDocsResponse {}

@documentation("Payload for updating a Pack invitation.")
structure UpdatePackInvitationPayload {
    @required
    access: PackAccessType
}

@documentation("Confirmation of successfully updating a Pack invitation.")
structure UpdatePackInvitationResponse {}

@documentation("Payload for updating a Pack.")
structure UpdatePackPayload {
    @documentation("Rate limit in Pack settings.")
    overallRateLimit: UpdatePackPayloadOverallRateLimit

    @documentation("Rate limit in Pack settings.")
    perConnectionRateLimit: UpdatePackPayloadPerConnectionRateLimit

    @documentation("Information about an image file for an update Pack request.")
    logo: UpdatePackPayloadLogo

    @documentation("Information about an image file for an update Pack request.")
    cover: UpdatePackPayloadCover

    @documentation("The example images for the Pack.")
    exampleImages: UpdatePackPayloadExampleImages

    @documentation("The agent images for the Pack.")
    agentImages: UpdatePackPayloadAgentImages

    sourceCodeVisibility: PackSourceCodeVisibility

    @documentation("Pack entrypoints where this pack is available")
    packEntrypoints: UpdatePackPayloadPackEntrypoints

    @documentation("The name of the Pack.")
    name: String

    @documentation("The full description of the Pack.")
    description: String

    @documentation("A short version of the description of the Pack.")
    shortDescription: String

    @documentation("A short description for the pack as an agent.")
    agentShortDescription: String

    @documentation("A full description for the pack as an agent.")
    agentDescription: String

    @documentation("A contact email for the Pack.")
    supportEmail: String

    @documentation("A Terms of Service URL for the Pack.")
    termsOfServiceUrl: String

    @documentation("A Privacy Policy URL for the Pack.")
    privacyPolicyUrl: String
}

@documentation("The agent images for the Pack.")
list UpdatePackPayloadAgentImages {
    member: ImageFileForUpdatePackRequest
}

@documentation("Information about an image file for an update Pack request.")
structure UpdatePackPayloadCover {
    @documentation("The asset id of the Pack's image, returned by [`#PackAssetUploadComplete`](#operation/packAssetUploadComplete) endpoint.")
    @required
    assetId: String

    @documentation("The filename for the image.")
    @required
    filename: String

    @documentation("The media type of the image being sent.")
    mimeType: String
}

@documentation("The example images for the Pack.")
list UpdatePackPayloadExampleImages {
    member: ImageFileForUpdatePackRequest
}

@documentation("Information about an image file for an update Pack request.")
structure UpdatePackPayloadLogo {
    @documentation("The asset id of the Pack's image, returned by [`#PackAssetUploadComplete`](#operation/packAssetUploadComplete) endpoint.")
    @required
    assetId: String

    @documentation("The filename for the image.")
    @required
    filename: String

    @documentation("The media type of the image being sent.")
    mimeType: String
}

@documentation("Rate limit in Pack settings.")
structure UpdatePackPayloadOverallRateLimit {
    @documentation("The rate limit interval in seconds.")
    @required
    intervalSeconds: Integer

    @documentation("The maximum number of Pack operations that can be performed in a given interval.")
    @required
    operationsPerInterval: Integer
}

@documentation("Pack entrypoints where this pack is available")
list UpdatePackPayloadPackEntrypoints {
    member: PackEntrypoint
}

@documentation("Rate limit in Pack settings.")
structure UpdatePackPayloadPerConnectionRateLimit {
    @documentation("The rate limit interval in seconds.")
    @required
    intervalSeconds: Integer

    @documentation("The maximum number of Pack operations that can be performed in a given interval.")
    @required
    operationsPerInterval: Integer
}

@documentation("Payload for updating a new Pack release.")
structure UpdatePackReleasePayload {
    @documentation("Notes about key features or changes in this release that the Pack maker wants to communicate to users.")
    releaseNotes: String
}

@documentation("Payload for a Pack asset upload.")
structure UploadPackAssetPayload {
    @required
    packAssetType: PackAssetType

    @documentation("The SHA-256 hash of the image to be uploaded.")
    @required
    imageHash: String

    @documentation("The media type of the image being sent.")
    @required
    mimeType: String

    @required
    filename: String
}

@documentation("Payload for a Pack asset upload.")
structure UploadPackSourceCodePayload {
    @documentation("The SHA-256 hash of the image to be uploaded.")
    @required
    payloadHash: String

    @required
    filename: String

    packVersion: String
}

@documentation("Request to create or update a Pack listing draft")
structure UpsertPackListingDraftPayload {
    @required
    listingData: PackListingDraftInputData
}

@documentation("Response containing the upserted Pack listing draft")
structure UpsertPackListingDraftResponse {
    @documentation("ID of the listing draft")
    @required
    packListingDraftId: String

    @documentation("ID of the Pack")
    @required
    packId: Double

    @required
    listingData: PackListingDraftData
}

@documentation("A named hyperlink to an arbitrary url.")
structure UrlValue {
    @documentation("A url describing the schema context for this object, typically \"http://schema.org/\".")
    @required
    @jsonName("@context")
    context: String

    @required
    @jsonName("@type")
    type: UrlValueType

    @documentation("An identifier of additional type info specific to Coda that may not be present in a schema.org taxonomy,")
    additionalType: String

    @documentation("The user-visible text of the hyperlink.")
    name: String

    @documentation("The url of the hyperlink.")
    @required
    url: String
}

enum UrlValueType {
    @enumValue("WebPage")
    WEB_PAGE
}

@documentation("Info about the user.")
structure User {
    @documentation("Name of the user.")
    @required
    name: String

    @documentation("Email address of the user.")
    @required
    loginId: String

    @documentation("The type of this resource.")
    @required
    type: UserType

    @documentation("Browser-friendly link to the user's avatar image.")
    pictureLink: String

    @documentation("True if the token used to make this request has restricted/scoped access to the API.")
    @required
    scoped: Boolean

    @documentation("Returns the name of the token used for this request.")
    @required
    tokenName: String

    @documentation("API link to the user.")
    @required
    href: String

    @required
    workspace: WorkspaceReference
}

@documentation("Summary about the user.")
structure UserSummary {
    @documentation("Name of the user.")
    @required
    name: String

    @documentation("Email address of the user.")
    @required
    loginId: String

    @documentation("The type of this resource.")
    @required
    type: UserSummaryType

    @documentation("Browser-friendly link to the user's avatar image.")
    pictureLink: String
}

@documentation("The type of this resource.")
enum UserSummaryType {
    @enumValue("user")
    USER
}

@documentation("The type of this resource.")
enum UserType {
    @enumValue("user")
    USER
}

@documentation("Detail about why a particular field failed request validation.")
structure ValidationError {
    @documentation("A path indicating the affected field, in OGNL notation.")
    @required
    path: String

    @documentation("An error message.")
    @required
    message: String
}

@documentation("A Coda result or entity expressed as a primitive type, or array of primitive types.")
union Value {
    scalarValue: ScalarValue
    variant2: ValueVariant2
}

@documentation("The format that cell values are returned as.")
enum ValueFormat {
    @enumValue("simple")
    SIMPLE

    @enumValue("simpleWithArrays")
    SIMPLE_WITH_ARRAYS

    @enumValue("rich")
    RICH
}

list ValueVariant2 {
    member: ValueVariant2Member
}

union ValueVariant2Member {
    scalarValue: ScalarValue
    variant2: ValueVariant2MemberVariant2
}

list ValueVariant2MemberVariant2 {
    member: ScalarValue
}

@documentation("Payload for webhook trigger")
structure WebhookTriggerPayload {}

@documentation("The result of triggering a webhook")
structure WebhookTriggerResult {
    @documentation("An arbitrary unique identifier for this request.")
    @required
    requestId: String
}

@documentation("Metadata about a Coda workspace.")
structure Workspace {
    @documentation("ID of the Coda workspace.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: WorkspaceType

    @documentation("ID of the organization bound to this workspace, if any.")
    organizationId: String

    @documentation("Browser-friendly link to the Coda workspace.")
    @required
    browserLink: String

    @documentation("Name of the workspace.")
    @required
    name: String

    @documentation("Description of the workspace.")
    description: String
}

@documentation("Response for listing workspace users.")
structure WorkspaceMembersList {
    @required
    items: WorkspaceMembersListItems

    nextPageToken: NextPageToken

    nextPageLink: NextPageLink
}

list WorkspaceMembersListItems {
    member: WorkspaceUser
}

structure WorkspacePrincipal {
    @documentation("The type of this principal.")
    @required
    type: WorkspacePrincipalType

    @documentation("WorkspaceId for the principal.")
    @required
    workspaceId: String
}

@documentation("The type of this principal.")
enum WorkspacePrincipalType {
    @enumValue("workspace")
    WORKSPACE
}

@documentation("Reference to a Coda workspace.")
structure WorkspaceReference {
    @documentation("ID of the Coda workspace.")
    @required
    id: String

    @documentation("The type of this resource.")
    @required
    type: WorkspaceReferenceType

    @documentation("ID of the organization bound to this workspace, if any.")
    organizationId: String

    @documentation("Browser-friendly link to the Coda workspace.")
    @required
    browserLink: String

    @documentation("Name of the workspace; included if the user has access to the workspace.")
    name: String
}

@documentation("The type of this resource.")
enum WorkspaceReferenceType {
    @enumValue("workspace")
    WORKSPACE
}

@documentation("Metadata for workspace role activity.")
structure WorkspaceRoleActivity {
    @documentation("Month corresponding to the data.")
    @required
    month: String

    @documentation("Number of active Admins.")
    @required
    activeAdminCount: Double

    @documentation("Number of active Doc Makers.")
    @required
    activeDocMakerCount: Double

    @documentation("Number of active Editors.")
    @required
    activeEditorCount: Double

    @documentation("Number of inactive Admins.")
    @required
    inactiveAdminCount: Double

    @documentation("Number of inactive Doc Makers.")
    @required
    inactiveDocMakerCount: Double

    @documentation("Number of inactive Editor users.")
    @required
    inactiveEditorCount: Double
}

@documentation("The type of this resource.")
enum WorkspaceType {
    @enumValue("workspace")
    WORKSPACE
}

@documentation("Metadata of a workspace user.")
structure WorkspaceUser {
    @documentation("Email of the user.")
    @required
    email: String

    @documentation("Name of the user.")
    @required
    name: String

    @required
    role: WorkspaceUserRole

    @documentation("Picture url of the user.")
    pictureUrl: String

    @documentation("Timestamp for when the user registered in this workspace")
    @required
    registeredAt: String

    @documentation("Timestamp for when the user's role last changed in this workspace.")
    roleChangedAt: String

    @documentation("Date when the user last took an action in any workspace.")
    lastActiveAt: String

    @documentation("Number of docs the user owns in this workspace.")
    ownedDocs: Double

    @documentation("Date when anyone last accessed a doc that the user owns in this workspace.")
    docsLastActiveAt: String

    @documentation("Number of collaborators that have interacted with docs owned by the user in the last 90 days.")
    docCollaboratorCount: Double

    @documentation("Number of docs the user owns, manages, or to which they have added pages in the last 90 days.")
    totalDocs: Double

    @documentation("Date when anyone last accessed a doc the member owns or contributed to.")
    totalDocsLastActiveAt: String

    @documentation("Number of unique users that have viewed any doc the user owns, manages, or has added pages to in the last 90 days.")
    totalDocCollaboratorsLast90Days: Double
}

enum WorkspaceUserRole {
    @enumValue("Admin")
    ADMIN

    @enumValue("DocMaker")
    DOC_MAKER

    @enumValue("Editor")
    EDITOR
}
