//
//  DetailProductsPresenter.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 21.07.23.
//

import Foundation

// MARK: Prootocols

protocol DetailProductsViewProtocol: AnyObject {
    func productAddedToCart(cartProduct: CartProduct?, error: CoreDataError?)
    func addToCart(product: Product?)
}

protocol DetailProductsViewPresenterProtocol: AnyObject {
    init(view: DetailProductsViewProtocol, networkService: NetworkServiceProtocol, coreDataService: CoreDataServiceProtocol, router: RouterProtocol, product: Product?)
    
    func addToCart(product: Product?)
}

class DetailProductsPresenter: DetailProductsViewPresenterProtocol {
    
    // MARK: Variables
    
    var isAddToCartButtonHidden = false
    var router: RouterProtocol?
    var product: Product?
    weak var view: DetailProductsViewProtocol?
    let networkService: NetworkServiceProtocol!
    let coreDataService: CoreDataServiceProtocol!
    
    // MARK: Initialisers
    
    required init(view: DetailProductsViewProtocol, networkService: NetworkServiceProtocol, coreDataService: CoreDataServiceProtocol, router: RouterProtocol, product: Product?) {
        self.view = view
        self.product = product
        self.router = router
        self.networkService = networkService
        self.coreDataService = coreDataService
    }

    // MARK: Methods
    
    func checkProductExistInCart(product: Product?, completion: @escaping (Result<CartProduct?, CoreDataError>) -> Void) {
        guard let product = product else {
            completion(.failure(.productNotFound))
            return
        }
        
        if let cartProduct = coreDataService.fetchProduct(id: product.id) {
            completion(.success(cartProduct))
        } else {
            completion(.failure(.cartProductNotFound))
        }
    }
    
    func addToCart(product: Product?) {
        // add error handling
        if let product = product {
            // check if product exist
            if let cartProduct = coreDataService.fetchProduct(id: product.id) {
                // increase quantity
                cartProduct.quantity += 1
                coreDataService.saveContext()
                view?.productAddedToCart(cartProduct: cartProduct, error: nil)
            } else {
                // add new product
                if let product = coreDataService.addProduct(id: product.id, about: product.description, title: product.title, category: product.category, price: product.price, quantity: 1, imageStringURL: product.image) {
                    view?.productAddedToCart(cartProduct: product, error: nil)
                }
            }
        }
    }
    
    func editProductQuantity(product: Product?, newQuantity: Int) {
        if let product = product {
            if let cartProduct = coreDataService.fetchProduct(id: product.id){
                cartProduct.quantity += Int64(newQuantity)
                self.product?.quantity = Int(cartProduct.quantity)
                if cartProduct.quantity == 0 {
                    coreDataService.deleteProductFromCart(product: cartProduct)
                }
                coreDataService.saveContext()
                view?.productAddedToCart(cartProduct: cartProduct, error: nil)
            } else {
                view?.productAddedToCart(cartProduct: nil, error: .cartProductNotFound)
            }
        } else {
            view?.productAddedToCart(cartProduct: nil, error: .productNotFound)
        }
    }
}

enum CoreDataError: Error {
    case productNotFound
    case cartProductNotFound
    case coreDataError
    case quantityEditingError
}
