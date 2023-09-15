//
//  APIService.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 11.04.23.
//

import Foundation
import Combine

protocol APIServiceProtocol: AnyObject {
    var networkService: NetworkServiceProtocol { get }
    
    func getProducts() -> AnyPublisher<[Product], NetworkError>
    func getProductsByCategory(category: String) -> AnyPublisher<[Product], NetworkError>
}

final class APIService: APIServiceProtocol {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
           self.networkService = networkService
       }
    
    func getProducts() -> AnyPublisher<[Product], NetworkError> {
        let endPoint = Endpoint.products()

        return networkService.execute(type: [Product].self, url: endPoint.url, headers: endPoint.headers)
    }
    
    func getProductsByCategory(category: String) -> AnyPublisher<[Product], NetworkError> {
        let endPoint = Endpoint.productsByCategory(category: category)

        return networkService.execute(type: [Product].self, url: endPoint.url, headers: endPoint.headers)
    }
}
