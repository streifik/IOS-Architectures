//
//  CartViewModel.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import Foundation
import CoreData

class CartViewModel: ObservableObject {
    @Published var cartProducts: [CartProduct] = []
    @Published var error: CoreDataError? = nil
    
    init() {
        self.fetchData()
    }
    
    func fetchData() {
        if let products = CoreDataManager.shared.fetchProductsData() {
            self.cartProducts = products
        } else {
            error = .cartProductNotFound
        }
    }
    
    func editProductQuantity(product: CartProduct, quantity: Int) {
        product.quantity = Int64(quantity)
        CoreDataManager.shared.saveContext()

        if product.quantity == 0 {
            let deletionSuccess =  CoreDataManager.shared.deleteProductFromCart(product: product)
            if !deletionSuccess {
                error = .deletionFromCartError
                return
            } else {
                product.quantity = 0
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
