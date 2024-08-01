import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case makeRequestError
    case urlRequestError(Error)
    case urlSessionError
    case decodingError(Error)
}
