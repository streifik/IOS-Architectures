//
//  ProductsDetailViewModel.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import Foundation
import SwiftUI

class DetailProductsViewModel: ObservableObject {
    
    @Published var product: Product
    @Published var error: CoreDataError? = nil
    @State var cartProductQuantity: Int = 0
    
    init(product: Product) {
        self.product = product
    }
    
    init(cartProduct: CartProduct) {
        let product = Product(id: Int(cartProduct.id), title: cartProduct.title, price: cartProduct.price, description: cartProduct.about, category: cartProduct.category, image: cartProduct.image)
        self.product = product
    }
    
    func getCartProductQuantity() {
        if let cartProduct = CoreDataManager.shared.fetchProduct(id: product.id) {
            product.quantity = Int(cartProduct.quantity)
        } else {
            error = .cartProductNotFound
        }
    }
    
    func editCartProductQuantity(newQuantity: Int) {
        if let cartProduct = CoreDataManager.shared.fetchProduct(id: product.id) {
            // change quantity if product exist in cart
            cartProduct.quantity = Int64(newQuantity)
            CoreDataManager.shared.saveContext()

            if cartProduct.quantity == 0 {
                // delete product from cart when quantity equals 0
                let deletionSuccess = CoreDataManager.shared.deleteProductFromCart(product: cartProduct)
                if !deletionSuccess {
                    error = .deletionFromCartError
                    return
                } else {
                    product.quantity = 0
                }
            } else {
                product.quantity = Int(cartProduct.quantity)
            }
        } else {
            error = .cartProductNotFound
        }
    }
    
    func addToCart() {
        // if product exist in cart increase quantity
        if let cartProduct = CoreDataManager.shared.fetchProduct(id: product.id) {
            editCartProductQuantity(newQuantity: Int(cartProduct.quantity) + 1)
            product = cartProduct.toProduct()
        } else {
            // add new product to cart
            if let cartProduct = CoreDataManager.shared.addProduct(product: self.product, quantity: 1) {
                product = cartProduct.toProduct()
            } else {
                error = .addingToCartError
            }
        }
    }
    
     func errorMessage(for error: CoreDataError) -> String {
        switch error {
        case .cartProductNotFound:
            return "Cart product not found."
        case .coreDataError:
            return "An error occurred while fetching data."
        case .quantityEditingError:
            return "An error occurred while editing quantity."
        case .productNotFound:
            return "Product not found."
        case .addingToCartError:
            return "An error occurred while adding product to cart."
        case .deletionFromCartError:
            return "An error occurred while deletion product from cart."
        }
    }
}

enum CoreDataError: Error {
    case productNotFound
    case cartProductNotFound
    case coreDataError
    case quantityEditingError
    case addingToCartError
    case deletionFromCartError
}
