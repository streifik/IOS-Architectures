//
//  CartViewModel.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 02.08.23.
//

import Foundation

class CartViewModel {
    
    // MARK: Variables
    
    var appCoordinator: Coordinator!
    var cartProducts = Dynamic<Result<[CartProduct]?, CartError>>(.success(nil))
    var coreDataService: CoreDataService!
    
    // MARK: Methods
    
    func getCartProducts() {
        if let cartProducts = coreDataService.fetchProductsData() {
            self.cartProducts.value = .success(cartProducts)
        } else {
            cartProducts.value = .failure(.coreDataError)
        }
    }
    
    func productCellTapped(cartProduct: CartProduct?) {
        let product = cartProduct?.toProduct()
        appCoordinator.showDetail(product: product, isAddToCartButtonHidden: true)
    }
    
    func editProductQuantity(product: CartProduct?, quantity: Int) {
         guard let cartProduct = product else {
             cartProducts.value = .failure(.cartProductNotFound)
             return
         }
         
         cartProduct.quantity = Int64(quantity)
         coreDataService.saveContext()
         
         if cartProduct.quantity == 0 {
             let deletionSuccess = coreDataService.deleteProductFromCart(product: cartProduct)
             if !deletionSuccess {
                 cartProducts.value = .failure(.quantityEditingError)
                 return
             }
         }
        
        // refactor
         
         getCartProducts()
     }
}

enum CartError: Error {
    case cartProductNotFound
    case coreDataError
    case quantityEditingError
}

