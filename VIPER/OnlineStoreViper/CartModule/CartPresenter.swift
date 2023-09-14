//
//  CartPresenter.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

// MARK: Protocol

protocol CartPresenterProtocol: AnyObject {
    func viewLoaded()
    func cartProductsLoaded(cartProducts: [CartProduct])
    func handleError(error: CoreDataError)
    var cartProducts: [CartProduct]? { get }
    func productQuantityUpdated(product: CartProduct?, quantity: Int)
    func productSelected(cartProduct: CartProduct)
}

class CartPresenter {
    
    // MARK: Variables
    
    weak var view: CartViewProtocol?
    var router: CartRouterProtocol
    var interactor: CartInteractorProtocol
    var cartProducts: [CartProduct]? = []
    
    // MARK: Initialisers
    
    init(interactor: CartInteractorProtocol, router: CartRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: CartPresenterProtocol

extension CartPresenter: CartPresenterProtocol {
    func handleError(error: CoreDataError) {
        view?.handleError(error: error)
    }
    
    func productSelected(cartProduct: CartProduct) {
        if let product = interactor.convertToProduct(cartProduct: cartProduct) {
            router.showProductDetail(product: product)
        }
    }

    func productQuantityUpdated(product: CartProduct?, quantity: Int) {
        interactor.editCartProductQuantity(product: product, quantity: quantity)
    }

    func cartProductsLoaded(cartProducts: [CartProduct]) {
       self.cartProducts = cartProducts
       view?.updateView()
    }
    
    func viewLoaded() {
        interactor.getCartProducts()
    }
}
