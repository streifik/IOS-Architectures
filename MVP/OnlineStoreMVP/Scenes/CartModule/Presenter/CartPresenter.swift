//
//  CartPresenter.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 26.07.23.
//

import Foundation

// MARK: Protocols

protocol CartViewProtocol: AnyObject {
    func updateViewWithCartProducts(_ cartProducts: [CartProduct])
    func handleError(error: CoreDataError)
}

protocol CartViewPresenterProtocol: AnyObject {
    init(view: CartViewProtocol, coreDataService: CoreDataServiceProtocol, router: RouterProtocol)
    var products: [Product]? { get set }
    var cartProducts: [CartProduct]? { get set }
    func productCellTapped(cartProduct: CartProduct?)
    
    func editProductQuantity(product: CartProduct?, quantity: Int)
    func getCartProducts()
}

class CartViewPresenter: CartViewPresenterProtocol {
    
    // MARK: Variables
    
    var router: RouterProtocol?
    var products: [Product]?
    var cartProducts: [CartProduct]?
    weak var view: CartViewProtocol?
    let coreDataService: CoreDataServiceProtocol!
    
    // MARK: Initializers
    
    required init(view: CartViewProtocol, coreDataService: CoreDataServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.coreDataService = coreDataService
        self.router = router
    }
    
    // MARK: Methods
    
    func productCellTapped(cartProduct: CartProduct?) {
        if let product = cartProduct?.toProduct() {
            router?.showDetailFromCart(product: product, isAddToCartButtonHidden: true)
        }
    }
    
    func getCartProducts() {
        if let cartProducts = coreDataService.fetchProductsData() {
            self.cartProducts = cartProducts
            view?.updateViewWithCartProducts(cartProducts)
        } else {
            view?.handleError(error: .coreDataError)
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
