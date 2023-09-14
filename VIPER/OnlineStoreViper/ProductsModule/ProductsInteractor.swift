//
//  ProductsInteractor.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 08.08.23
//
import Foundation

// MARK: Protocols

protocol ProductsInteractorProtocol: AnyObject {
    func loadProducts()
    func getProductsByCategory(category: String)
}

class ProductsInteractor: ProductsInteractorProtocol {
    
    // MARK: Variables
    
    weak var presenter: ProductsPresenterProtocol?
    let networkService = NetworkService()
    
    // MARK: Methods
    
    func getProductsByCategory(category: String) {
        networkService.getProducts(category: category) {  [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.presenter?.productsLoaded(products: products)
                case .failure:
                    self.presenter?.handleError(error: .networkError)
                }
            }
        }
    }
    
    func loadProducts() {
        networkService.getProducts(category: nil) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.presenter?.productsLoaded(products: products)
                case .failure:
                    self.presenter?.handleError(error: .networkError)
                }
            }
        }
    }
}

enum ProductError: Error {
    case networkError
    case productNotFound
}
