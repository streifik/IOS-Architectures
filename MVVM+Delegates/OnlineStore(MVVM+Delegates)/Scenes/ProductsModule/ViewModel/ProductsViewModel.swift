//
//  ProductsViewModel.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import Foundation

// MARK: Protocols

protocol ProductViewModelDelegate {
    func updateProducts(products: [Product]?)
    func handleError(error: ProductError)
}

class ProductsViewModel {
    
    // MARK: Variables
    
    var productViewModelDelegate: ProductViewModelDelegate?
    var networkService = NetworkManager()
    var products : [Product]?
    var appCoordinator: Coordinator!
    
    // MARK: Methods
    
    func getProducts() {
        networkService.getProducts(category: nil) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.products = products
                    self.productViewModelDelegate?.updateProducts(products: products)
                case .failure:
                    self.productViewModelDelegate?.handleError(error: .networkError)
                }
            }
        }
    }
    
    func productCellTapped(product: Product?) {
       appCoordinator.showDetail(product: product, isAddToCartStackViewHidden: false)
    }
    
    func getProductsyCategory(category: String) {
        networkService.getProducts(category: category) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.products = products
                    self.productViewModelDelegate?.updateProducts(products: products)
                case .failure:
                    self.productViewModelDelegate?.handleError(error: .networkError)
                }
            }
        }
    }
}

enum ProductError: Error {
    case networkError
    case productNotFound
}
