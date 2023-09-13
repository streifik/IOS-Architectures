//
//  NetworkManager.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 21.07.23.
//

import Foundation

protocol NetworkServiceProtocol {
    func getProducts(category: String?, onCompletion: @escaping (Result<[Product]?, NetworkError>) -> ())
}

enum NetworkError: Error {
    case noInternet
    case apiFailure
    case invalidResponse
    case decodingError
}

fileprivate enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

typealias Parameters = [String : Any]

fileprivate enum URLEncoding {
    case queryString
    case none
    
    func encode(_ request: inout URLRequest, with parameters: Parameters)  {
        switch self {
        case .queryString:
            guard let url = request.url else { return }
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
               !parameters.isEmpty {
                urlComponents.queryItems = [URLQueryItem]()
                for (k, v) in parameters {
                    let queryItem = URLQueryItem(name: k, value: "\(v)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                    urlComponents.queryItems?.append(queryItem)
                }
                request.url = urlComponents.url
            }
        case .none:
            break
        }
    }
}

protocol APIRequestProtocol {
    static func makeRequest<S: Codable>(session: URLSession, request: URLRequest, model: S.Type, onCompletion: @escaping(S?, NetworkError?) -> ())
     static func makeGetRequest<T: Codable> (path: String, category: String?, queries: Parameters, onCompletion: @escaping(T?, NetworkError?) -> ())
    static func makePostRequest<T: Codable> (path: String, body: Parameters, onCompletion: @escaping (T?, NetworkError?) -> ())
}


fileprivate enum APIRequestManager: APIRequestProtocol {
    
    case getAPI(path: String, data: Parameters)
    case postAPI(path: String, data: Parameters)
    
    static var baseURL: URL = URL(string: "https://fakestoreapi.com/")!
    
    private var path: String {
        switch self {
        case .getAPI(let path, _):
            return path
        case .postAPI(let path, _):
            return path
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getAPI:
            return .get
        case .postAPI:
            return .post
        }
    }
    
    
    // MARK:- functions
    fileprivate func addHeaders(request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    fileprivate func asURLRequest() -> URLRequest {
        /// appends the path passed to either of the enum case with the base URL
        var request = URLRequest(url: Self.baseURL.appendingPathComponent(path))
        /// appends the httpMethod based on the enum case
        request.httpMethod = method.rawValue
        
        var parameters = Parameters()
        
        switch self {
        case .getAPI(_, let queries):
            queries.forEach({parameters[$0] = $1})
            URLEncoding.queryString.encode(&request, with: parameters)
        case .postAPI(_, let queries):
            queries.forEach({parameters[$0] = $1})
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters) {
                request.httpBody = jsonData
            }
        }
        self.addHeaders(request: &request)
        return request
    }
    
    fileprivate static func makeRequest<S: Codable>(session: URLSession, request: URLRequest, model: S.Type, onCompletion: @escaping(S?, NetworkError?) -> ()) {
        session.dataTask(with: request) { data, response, error in
            guard error == nil, let responseData = data else { onCompletion(nil, NetworkError.apiFailure) ; return }
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    as? Parameters  {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(S.self, from: jsonData)
                    onCompletion(response, nil)
                } else if let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            as? [Parameters] {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(S.self, from: jsonData)
                    onCompletion(response, nil)
                }
                else {
                    onCompletion(nil,  NetworkError.invalidResponse)
                    return
                }
            } catch {
                onCompletion(nil, NetworkError.decodingError)
                return
            }
        }.resume()
    }
    
    /// Generic GET Request
  
    fileprivate static func makeGetRequest<T: Codable> (path: String, category: String?, queries: Parameters, onCompletion: @escaping(T?, NetworkError?) -> ()) {
        let session = URLSession.shared
        let fullPath: String
        
        if let category = category {
            fullPath = "\(path)/category/\(category)"
        } else {
            fullPath = path
        }
        let request: URLRequest = Self.getAPI(path: fullPath, data: queries).asURLRequest()
        
        makeRequest(session: session, request: request, model: T.self) { (result, error) in
            onCompletion(result, error)
        }
    }
    
    /// Generic POST request
    fileprivate static func makePostRequest<T: Codable> (path: String, body: Parameters, onCompletion: @escaping (T?, NetworkError?) -> ()) {
        let session = URLSession.shared
        let request: URLRequest = Self.postAPI(path: path, data: body).asURLRequest()
        
        makeRequest(session: session, request: request, model: T.self) { (result, error) in
            onCompletion(result, error)
        }
    }
}


/// Wrapper for Network Requests, has functions for various API Requests, and passes the queries to the Generic GET/POST functions.
struct NetworkService: NetworkServiceProtocol {
    // MARK:- functions
    func getProducts(category: String?, onCompletion: @escaping (Result<[Product]?, NetworkError>) -> ()) {
        APIRequestManager.makeGetRequest(path: "products", category: category, queries: [:]) { (result: [Product]?, error) in
            if let error = error {
                onCompletion(.failure(error))
            } else {
                onCompletion(.success(result))
            }
        }
    }
}
