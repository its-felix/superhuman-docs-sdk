$version: "2"

namespace com.superhuman.docs.v1

use smithy.api#documentation
use smithy.api#error
use smithy.api#httpError
use smithy.api#required

@documentation("The request parameters did not conform to expectations.")
@error("client")
@httpError(400)
structure BadRequestError {
    @documentation("HTTP status code of the error.")
    @required
    statusCode: Double

    @documentation("HTTP status message of the error.")
    @required
    statusMessage: String

    @documentation("Any additional context on the error, or the same as `statusMessage` otherwise.")
    @required
    message: String
}

@documentation("The request parameters did not conform to expectations.")
@error("client")
@httpError(400)
structure BadRequestWithValidationErrors {
    @documentation("HTTP status code of the error.")
    @required
    statusCode: Double

    @documentation("HTTP status message of the error.")
    @required
    statusMessage: String

    @documentation("Any additional context on the error, or the same as `statusMessage` otherwise.")
    @required
    message: String

    @documentation("Detail about why this request was rejected.")
    codaDetail: BadRequestWithValidationErrorsCodaDetail
}

@documentation("The API token does not grant access to this resource.")
@error("client")
@httpError(403)
structure ForbiddenError {
    @documentation("HTTP status code of the error.")
    @required
    statusCode: Double

    @documentation("HTTP status message of the error.")
    @required
    statusMessage: String

    @documentation("Any additional context on the error, or the same as `statusMessage` otherwise.")
    @required
    message: String
}

@documentation("The resource has been deleted.")
@error("client")
@httpError(410)
structure GoneError {
    @documentation("HTTP status code of the error.")
    @required
    statusCode: Double

    @documentation("HTTP status message of the error.")
    @required
    statusMessage: String

    @documentation("Any additional context on the error, or the same as `statusMessage` otherwise.")
    @required
    message: String
}

@documentation("The resource could not be located with the current API token.")
@error("client")
@httpError(404)
structure NotFoundError {
    @documentation("HTTP status code of the error.")
    @required
    statusCode: Double

    @documentation("HTTP status message of the error.")
    @required
    statusMessage: String

    @documentation("Any additional context on the error, or the same as `statusMessage` otherwise.")
    @required
    message: String
}

@documentation("The client has sent too many requests.")
@error("client")
@httpError(429)
structure TooManyRequestsError {
    @documentation("HTTP status code of the error.")
    @required
    statusCode: Double

    @documentation("HTTP status message of the error.")
    @required
    statusMessage: String

    @documentation("Any additional context on the error, or the same as `statusMessage` otherwise.")
    @required
    message: String
}

@documentation("The API token is invalid or has expired.")
@error("client")
@httpError(401)
structure UnauthorizedError {
    @documentation("HTTP status code of the error.")
    @required
    statusCode: Double

    @documentation("HTTP status message of the error.")
    @required
    statusMessage: String

    @documentation("Any additional context on the error, or the same as `statusMessage` otherwise.")
    @required
    message: String
}

@documentation("Unable to process the request.")
@error("client")
@httpError(422)
structure UnprocessableEntityError {
    @documentation("HTTP status code of the error.")
    @required
    statusCode: Double

    @documentation("HTTP status message of the error.")
    @required
    statusMessage: String

    @documentation("Any additional context on the error, or the same as `statusMessage` otherwise.")
    @required
    message: String
}
