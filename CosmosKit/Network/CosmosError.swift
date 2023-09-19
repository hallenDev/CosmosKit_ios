import Foundation

public enum CosmosError: Error {
    case invalidURL
    case authenticationError
    case serverError
    case networkError(Error?)
    case noResponse
    case parsingError(String)
    case apiError(DecodableError)

    public var localizedDescription: String {
        switch self {
        case .authenticationError:
            return LanguageManager.shared.translate(key: .errorIncorrectEmailOrPassword)
        case .networkError, .noResponse:
            return LanguageManager.shared.translate(key: .errorNetwork)
        default:
            return LanguageManager.shared.translate(key: .errorGeneric)
        }
    }
}
