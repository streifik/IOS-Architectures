//
//  ProductDetailViewModel.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import Foundation

class ProductDetailViewModel {
    
    // MARK: Variables
    
    var selectedProduct: Product?
    var appCoordinator: Coordinator!
    var coreDataService: CoreDataService!
    var isAddToCartButtonHidden = false
    var cartProduct = Dynamic<CartProduct?>(nil)

    // MARK: Methods
    
    func checkProductExistInCart(product: Product?, completion: @escaping (Result<CartProduct?, ProductDetailError>) -> Void) {
        guard let product = product else {
            completion(.failure(.productNotFound))
            return
        }
        if let cartProduct = self.coreDataService.fetchProduct(id: product.id) {
            completion(.success(cartProduct))
        } else {
            completion(.failure(.cartProductNotFound))
        }
    }
    
    func addToCart(product: Product?, completion: @escaping (Result<CartProduct, ProductDetailError>) -> Void) {
        guard let product = product else {
            completion(.failure(.productNotFound))
            return
        }
        self.checkProductExistInCart(product: product) { result in
            switch result {
            case .success(let cartProduct):
                // Increase quantity of existing cart product
                if let cartProduct = cartProduct {
                    cartProduct.quantity += 1
                    self.coreDataService.saveContext()
                    completion(.success(cartProduct))
                } else {
                    completion(.failure(.cartProductNotFound))
                }
            case .failure:
                // Add new product
                if let newProduct = self.coreDataService.addProduct(id: product.id, about: product.description, title: product.title, category: product.category, price: product.price, quantity: 1, imageStringURL: product.image) {
                    completion(.success(newProduct))
                } else {
                    completion(.failure(.coreDataError))
                    return
                }
            }
        }
    }
    
    func editProductQuantity(product: CartProduct?, quantity: Int, completion: @escaping (Result<CartProduct, ProductDetailError>) -> Void) {
        guard let cartProduct = product else {
            completion(.failure(.cartProductNotFound))
            return
        }
        cartProduct.quantity = Int64(quantity)
        self.coreDataService.saveContext()
        
        if cartProduct.quantity == 0 {
            let deletionSuccess = self.coreDataService.deleteProductFromCart(product: cartProduct)
            if !deletionSuccess {
                completion(.failure(.quantityEditingError))
                return
            } else {
                completion(.success(cartProduct))
            }
        } else {
            completion(.success(cartProduct))
        }
    }
}

enum ProductDetailError: Error {
    case productNotFound
    case cartProductNotFound
    case coreDataError
    case quantityEditingError
}
