//
//  NetworkController.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 11.04.23.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {
    typealias Headers = [String: Any]
    
    func execute<T: Decodable>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, NetworkError> where T: Decodable
}


final class NetworkService: NetworkServiceProtocol {
    func execute<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, NetworkError> where T : Decodable {
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        print(urlRequest)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return NetworkError.networkError
        }
        .eraseToAnyPublisher()
    }
}

