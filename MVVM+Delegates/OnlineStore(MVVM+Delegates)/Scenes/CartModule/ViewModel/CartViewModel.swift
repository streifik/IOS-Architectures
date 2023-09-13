//
//  CartViewModel.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 02.08.23.
//

import Foundation

// MARK: Protocols

protocol CartViewModelDelegate {
    func updateViewWithCartProducts(_ cartProducts: [CartProduct])
    func handleError(error: CoreDataError)
}

class CartViewModel {
    
    // MARK: Variables
    
    var cartViewModelDelegate: CartViewModelDelegate?
    var appCoordinator: Coordinator!
    var cartProducts : [CartProduct]?
    var coreDataService: CoreDataService!
    
    // MARK: Methods
    
    func cartProductCellTapped(cartProduct: CartProduct?) {
        if let product = cartProduct?.toProduct() {
           appCoordinator.showDetail(product: product, isAddToCartStackViewHidden: true)
        }
    }
    
    func getCartProducts() {
        coreDataService.fetchProductsData { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.cartProducts = products
                    self.cartViewModelDelegate?.updateViewWithCartProducts(products)
                case .failure(let error):
                    self.cartViewModelDelegate?.handleError(error: error)
                }
            }
        }
    }
    
    func editProductQuantity(product: CartProduct?, quantity: Int) {
        if let cartProduct = product {
            cartProduct.quantity = Int64(quantity)
            coreDataService.saveContext()
            
            if cartProduct.quantity == 0 {
                coreDataService.deleteProductFromCart(product: cartProduct)
            }
            getCartProducts()
        }
    }
}

