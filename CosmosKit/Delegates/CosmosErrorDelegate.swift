import Foundation

public protocol CosmosErrorDelegate: AnyObject {
    func cosmos(received error: CosmosError?)
    func cosmos(raise error: Error, endpointUrl: String)
}

// MARK: Default implementations for CosmosErrorDelegate
extension Cosmos: CosmosErrorDelegate {

    public func cosmos(raise error: Error, endpointUrl: String) {
        var logError: NSError
        if let decodingError = error as? DecodingError {
            logError = NSError(domain: ErrorHelper.ERROR_DECODE_DOMAIN,
                                      code: ErrorHelper.ERROR_DECODE_CODE,
                                      userInfo: [ErrorHelper.PARAM_URL: endpointUrl,
                                                 ErrorHelper.PARAM_DECODE_ERROR: "\(decodingError)"])
        } else {
            logError = NSError(domain: ErrorHelper.ERROR_GENERAL_DOMAIN,
                                      code: ErrorHelper.ERROR_GENERAL_CODE,
                                      userInfo: [ErrorHelper.PARAM_URL: endpointUrl,
                                                 ErrorHelper.PARAM_ERROR: "\(error)"])
        }
        print(String(format: "🚨 Cosmos Error Raised: %@", logError.localizedDescription))
        logger?.log(error: logError)
    }

    public func cosmos(received error: CosmosError?) {
        guard let error = error else { return }
        print(String(format: "🚨 Cosmos Error: %@", error.localizedDescription))

        let errorString = APIErrorHandler.handle(error, .general)

        logger?.log(event: CosmosEvents.error(description: errorString))

        let alert = UIAlertController(title: "", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            UIApplication.shared.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
