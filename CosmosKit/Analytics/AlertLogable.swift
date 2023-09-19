import Foundation

public enum ScreenContext {
    case login
    case reset
    case register
    case general
}

struct Alerter {
    static func alert(translatedMessage: String) {
        let alert = UIAlertController(title: "", message: translatedMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LanguageManager.shared.translateUppercased(key: .ok), style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            UIApplication.shared.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }

    static func alert(error: CosmosError?, context: ScreenContext) {
        let errorMessage = APIErrorHandler.handle(error, context)
        self.alert(translatedMessage: errorMessage)
    }
}
