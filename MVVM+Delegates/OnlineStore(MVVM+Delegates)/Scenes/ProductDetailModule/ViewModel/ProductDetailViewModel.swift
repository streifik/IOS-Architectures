//
//  ProductDetailViewModel.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import Foundation

// MARK: Protocols

protocol ProductDetailViewModelDelegate {
    func productAddedToCart(cartProduct: CartProduct?, error: CoreDataError?)
}

class ProductDetailViewModel {
    
    // MARK: Variables
    
    var isAddToCartStackViewHidden: Bool = false
    var selectedProduct: Product?
    var appCoordinator: Coordinator!
    var coreDataService: CoreDataService!
    var productDetailViewModelDelegate: ProductDetailViewModelDelegate?
    
    // MARK: Methods
    
    func addToCart(product: Product?) {
        if let product = product {
            // check if product exist
            coreDataService.fetchProduct(id: product.id) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let cartProduct):
                 // increase quantity
                    guard let cartProduct = cartProduct else { return }
                    cartProduct.quantity += 1
                    self.coreDataService.saveContext()
                    self.productDetailViewModelDelegate?.productAddedToCart(cartProduct: cartProduct, error: nil)
                case .failure(let error):
                    if error == .cartProductNotFound {
                        //add new product
                        self.coreDataService.addProduct(id: product.id, about: product.description, title: product.title, category: product.category, price: product.price, quantity: 1, imageStringURL: product.image) { result in
                            switch result {
                            case .success(let product):
                                self.productDetailViewModelDelegate?.productAddedToCart(cartProduct: product, error: nil)
                            case .failure(let error): break
                                self.productDetailViewModelDelegate?.productAddedToCart(cartProduct: nil, error: error)
                            }
                        }
                    } else {
                        self.productDetailViewModelDelegate?.productAddedToCart(cartProduct: nil, error: .coreDataError)
                    }
                }
            }
        } else {
            productDetailViewModelDelegate?.productAddedToCart(cartProduct: nil, error: .productNotFound)
        }
    }
    
    
    func getCartProductQuantity(from product: Product?, completion: @escaping (Result<Int, CoreDataError>) -> Void) {
        guard let product = product else {
            completion(.failure(.productNotFound))
            return
        }
        
        coreDataService.fetchProduct(id: product.id) { result in
            switch result {
            case .success(let cartProduct):
                guard let cartProduct = cartProduct else {
                    completion(.failure(.cartProductNotFound))
                    return
                }
                completion(.success(Int(cartProduct.quantity)))
            case .failure:
                completion(.failure(.cartProductNotFound))
            }
        }
    }

    func editProductQuantity(product: Product?, newQuantity: Int) {
        if let product = product {
            coreDataService.fetchProduct(id: product.id) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let cartProduct):
                    // change quantity
                    guard let cartProduct = cartProduct else { return } // fix optional in manager?
                    cartProduct.quantity += Int64(newQuantity)
                        self.selectedProduct?.quantity = Int(cartProduct.quantity)
                        if cartProduct.quantity == 0 {
                            self.coreDataService.deleteProductFromCart(product: cartProduct)
                        }
                        self.coreDataService.saveContext()
                        self.productDetailViewModelDelegate?.productAddedToCart(cartProduct: cartProduct, error: nil)
                case .failure(let error):
                    self.productDetailViewModelDelegate?.productAddedToCart(cartProduct: nil, error: error)
                }
            }
        } else {
            productDetailViewModelDelegate?.productAddedToCart(cartProduct: nil, error: .productNotFound)
        }
    }
}

enum CoreDataError: Error {
    case productNotFound
    case cartProductNotFound
    case coreDataError
    case quantityEditingError
}

