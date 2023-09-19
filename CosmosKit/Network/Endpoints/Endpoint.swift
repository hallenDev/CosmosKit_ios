import Foundation

protocol Endpoint {
    var config: CosmosConfig { get }
    var urlString: String { get }
    func get(_ completion: @escaping (Data?, CosmosError?) -> Void)
    static func encodeURL(value: String, using characterSet: CharacterSet) -> String
}

extension Endpoint {

    var sanitizedUrl: String {
        var components = URLComponents(string: urlString)
        components?.queryItems?.removeAll { $0.name == "access_token" }
        return components?.url?.absoluteString ?? "NA"
    }

    func get(_ completion: @escaping (Data?, CosmosError?) -> Void) {
        if let url = URL(string: urlString) {
            createTask(URLRequest(url: url), completion: completion)
        } else {
            completion(nil, CosmosError.invalidURL)
        }
    }

    func post<T: Encodable>(data: T, _ completion: @escaping (Data?, CosmosError?) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let json = try? JSONEncoder().encode(data)
            request.httpBody = json
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            createTask(request, completion: completion)
        } else {
            completion(nil, CosmosError.invalidURL)
        }
    }

    fileprivate func createTask(_ request: URLRequest, completion: @escaping (Data?, CosmosError?) -> Void) {
        let task = config.session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299: completion(data, nil)
                case 400...499:
                    var error = CosmosError.authenticationError
                    if let data = data,
                        let parsedError = try? JSONDecoder().decode(DecodableError.self, from: data) {
                        error = CosmosError.apiError(parsedError)
                    }
                    completion(nil, error)
                case 500...599:
                    var error = CosmosError.serverError
                    if let data = data,
                        let parsedError = try? JSONDecoder().decode(DecodableError.self, from: data) {
                        error = CosmosError.apiError(parsedError)
                    }
                    completion(nil, error)
                default: completion(nil, CosmosError.networkError(error))
                }
            } else {
                completion(nil, CosmosError.noResponse)
            }
        }
        task.resume()
    }

    static func encodeURL(value: String, using characterSet: CharacterSet = CharacterSet.urlQueryAllowed) -> String {
        var coded = value.addingPercentEncoding(withAllowedCharacters: characterSet)!
        coded = coded.replacingOccurrences(of: "&", with: "%26")
        coded = coded.replacingOccurrences(of: "+", with: "%2B")
        coded = coded.replacingOccurrences(of: "~", with: "%7E")
        coded = coded.replacingOccurrences(of: "_", with: "%5F")
        coded = coded.replacingOccurrences(of: "=", with: "%3D")
        coded = coded.replacingOccurrences(of: ";", with: "%3B")
        coded = coded.replacingOccurrences(of: ".", with: "%2E")
        coded = coded.replacingOccurrences(of: "-", with: "%2D")
        coded = coded.replacingOccurrences(of: ",", with: "%2C")
        coded = coded.replacingOccurrences(of: "*", with: "%2A")
        coded = coded.replacingOccurrences(of: "!", with: "%21")
        coded = coded.replacingOccurrences(of: "$", with: "%24")
        coded = coded.replacingOccurrences(of: "'", with: "%27")
        coded = coded.replacingOccurrences(of: "(", with: "%28")
        coded = coded.replacingOccurrences(of: ")", with: "%29")
        return coded
    }
}
