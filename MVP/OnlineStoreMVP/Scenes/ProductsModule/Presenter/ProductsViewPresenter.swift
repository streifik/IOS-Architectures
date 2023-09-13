//
//  ProductsViewPresenter.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 21.07.23.
//

import Foundation

// MARK: Protocols

protocol ProductsViewProtocol: AnyObject {
    func sucess()
    func failure(error: ProductError)
}

protocol ProductsPresenterProtocol: AnyObject {
    init(view: ProductsViewProtocol, networkService: NetworkServiceProtocol , router: RouterProtocol)
    func getProducts()
    func getProductsyCategory(category: String)
    func productCellTapped(product: Product?)
    var products: [Product]? { get set}

}

class ProductsPresenter: ProductsPresenterProtocol {
    
    // MARK: Variables
    
    var router: RouterProtocol?
    var products: [Product]?
    weak var view: ProductsViewProtocol?
    let networkService: NetworkServiceProtocol!
    
    // MARK: Initializers
    
    required init(view: ProductsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        
        getProducts()
    }
    
    // MARK: Methods
    
    func productCellTapped(product: Product?) {
        router?.showDetail(product: product, isAddToCartButtonHidden: false)
    }
    
    func getProducts() {
        networkService.getProducts(category: nil) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.products = products
                    self.view?.sucess()
                case .failure:
                    self.view?.failure(error: .networkError)
                }
            }
        }
    }
    
    func getProductsyCategory(category: String) {
        networkService.getProducts(category: category) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.products = products
                    self.view?.sucess()
                case .failure:
                    self.view?.failure(error: .networkError)
                }
            }
        }
    }
}


enum ProductError: Error {
    case networkError
    case productNotFound
}
