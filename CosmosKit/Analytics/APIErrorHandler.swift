// swiftlint:disable line_length
import Foundation

public class APIErrorHandler {

    public static func handle(_ error: CosmosError?, _ context: ScreenContext) -> String {
        var errorString: String?

        switch error {
        case .apiError(let apiError)?:
            errorString = handleAPIError(apiError, context)
        default:
            errorString = error?.localizedDescription
        }
        return errorString ?? LanguageManager.shared.translate(key: .errorGeneric)
    }

    private static func handleAPIError(_ error: DecodableError, _ context: ScreenContext) -> String? {
        switch (error.code, context) {
        case (11, _):
            return LanguageManager.shared.translate(key: .errorAccountTaken)
        case (220, .login):
            return LanguageManager.shared.translate(key: .errorIncorrectEmailOrPasswordTryRegisterReset)
        case (220, _):
            return LanguageManager.shared.translate(key: .errorIncorrectEmailOrPassword)
        case (10, .register):
            return LanguageManager.shared.translate(key: .errorInvalidEmail)
        case (10, .login):
            return LanguageManager.shared.translate(key: .errorIncorrectEmailOrPasswordTryRegisterReset)
        case (10, .reset):
            return LanguageManager.shared.translate(key: .errorIncorrectEmailTryRegister)
        case (100, _):
            return LanguageManager.shared.translate(key: .errorActivationRequired)
        default:
            return LanguageManager.shared.translate(key: .errorGeneric)
        }
    }
}
