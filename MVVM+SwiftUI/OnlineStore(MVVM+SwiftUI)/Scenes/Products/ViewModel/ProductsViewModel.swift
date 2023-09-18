//
//  ProductsViewModel.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import Foundation
import Combine
import SwiftUI

class ProductsViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: NetworkError? = nil
    
    var categories = ["All", "Electronics", "Jewelery", "Men's clothing", "Women's clothing"]
    var subscriptions: Set<AnyCancellable> = []
    let apiService = APIService(networkService: NetworkService())
    
    func fetchProductsCombine() {
        isLoading = true
        error = nil
        
        apiService.getProducts()
            .sink { completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.error = error
                        self.isLoading = false
                    }
                }
            } receiveValue: { products in
                DispatchQueue.main.async {
                    if products.isEmpty {
                        self.error = .networkError
                    } else {
                        self.products = products
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    func fetchProductsByCategoryCombine(category: String) {
        isLoading = true
        apiService.getProductsByCategory(category: category)
            .sink { completion in
                switch completion {
                case .finished:
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                case .failure(let error):
                    self.error = error
                    self.isLoading = false
                }
            } receiveValue: { products in
                DispatchQueue.main.async {
                    if products.isEmpty {
                        self.error = .networkError
                    } else {
                        self.products = products
                    }
                }
            }.store(in: &subscriptions)
    }
    
    func errorMessage(for error: NetworkError) -> String {
        switch error {
        case .productNotFound:
            return "Product not found."
        case .networkError:
            return "Network error occurred while fetching data."
        }
    }
}

enum NetworkError: Error {
    case networkError
    case productNotFound
}
