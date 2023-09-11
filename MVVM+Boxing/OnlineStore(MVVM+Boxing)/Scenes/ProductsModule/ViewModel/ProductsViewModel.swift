//
//  ProductsViewModel.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import Foundation

class ProductsViewModel {
    
    // MARK: Variables
    
    var networkService = NetworkManager()
    var products = Dynamic<[Product]?>(nil)
    var appCoordinator: Coordinator!
    
    // MARK: Methods
    
    func getProducts(completion: @escaping (Result<[Product]?, ProductError>) -> Void) {
        networkService.getProducts(category: nil) { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func productCellTapped(product: Product?) {
        appCoordinator.showDetail(product: product, isAddToCartButtonHidden: false)
    }
    
    func getProductsyCategory(category: String, completion: @escaping (Result<[Product]?, ProductError>) -> Void) {
        self.networkService.getProducts(category: category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    completion(.success(products))
                case .failure:
                    completion(.failure(.networkError))
                }
            }
        }
    }
}

enum ProductError: Error {
    case networkError
    case productNotFound
}
