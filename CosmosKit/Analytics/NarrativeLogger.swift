import Foundation

class NarratiiveLogger {
    let baseUrl: String
    let host: String
    let hostKey: String
    weak var errorDelegate: CosmosErrorDelegate?
    var currentToken: String?
    var session = URLSession.shared

    private var userAgent: String = {
        "Mozilla/5.0 iOS/\(UIDevice.current.systemVersion) (Mobile)"
    }()

    private var contentType: String = {
        "application/json; charset=utf-8"
    }()

    init(config: NarratiiveConfig) {
        self.baseUrl = config.baseUrl
        self.host = config.host
        self.hostKey = config.hostKey
    }

    func getToken(completion: BooleanCallback?) {
        if let url = URL(string: baseUrl + "/tokens") {
            let data = TokenRequestBody(host: host, hostKey: hostKey)
            createTask(url: url, data: data, completion: completion)
        }
    }

    func sendEvent(path: String, completion: BooleanCallback?) {
        if let url = URL(string: baseUrl + "/hits"),
            let currentToken = currentToken {
            let data = EventRequestBody(token: currentToken, host: host, hostKey: hostKey, path: path)
            createTask(url: url, data: data, completion: completion)
        }
    }

    private func createTask<T: Encodable>(url: URL, data: T, completion: BooleanCallback?) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(data)
        session.dataTask(with: request) { [weak self] responseData, _, error in
            if let responseData = responseData {
                do {
                    let token = try JSONDecoder().decode(TokenResponse.self, from: responseData)
                    self?.currentToken = token.token
                    completion?(true)
                    return
                } catch {
                    self?.errorDelegate?.cosmos(raise: error, endpointUrl: url.absoluteString)
                }
            } else if let error = error {
                self?.errorDelegate?.cosmos(raise: error, endpointUrl: url.absoluteString)
            }
            completion?(false)
        }.resume()
    }

    // MARK: Models

    struct TokenRequestBody: Codable {
        let host: String
        let hostKey: String
    }

    struct EventRequestBody: Codable {
        let token: String
        let host: String
        let hostKey: String
        let path: String
    }

    struct TokenResponse: Codable {
        let token: String
    }
}
