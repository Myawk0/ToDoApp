//
//  NetworkManager.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import Alamofire

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    // MARK: - private methods
    
    // Make dictionary of parameters for URL request
    // - Returns: Parameters in [String: String]
    private func makeParameters(for endpoint: Endpoint, with query: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["api_key"] = API.apiKey
        
        return parameters
    }
    
    // MARK: - public methods
    
    // Create URL for API method
    func createURL(for endPoint: Endpoint, with query: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = endPoint.path
        
        components.queryItems = makeParameters(for: endPoint, with: query).compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components.url
    }
    
    // Method for making task
    func makeTask<T: Decodable>(for url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(.transportError(error)))
            }
        }
    }
}

