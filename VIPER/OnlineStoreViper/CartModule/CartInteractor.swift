//
//  CartInteractor.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

// MARK: Protocols

protocol CartInteractorProtocol: AnyObject {
    func getCartProducts()
    func editCartProductQuantity(product: CartProduct?, quantity: Int)
    func convertToProduct(cartProduct: CartProduct) -> Product?
}

class CartInteractor: CartInteractorProtocol {
    
    // MARK: Variables
    
    weak var presenter: CartPresenterProtocol?
    let coreDataService: CoreDataServiceProtocol
    
    // MARK: Initialisers
    
    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }
    
    // MARK: Methods

    func getCartProducts() {
        if let cartProducts = coreDataService.fetchProductsData() {
            presenter?.cartProductsLoaded(cartProducts: cartProducts)
        } else {
            presenter?.handleError(error: .coreDataError)
        }
    }
    
    func convertToProduct(cartProduct: CartProduct) -> Product? {
        return Product(
            id: Int(cartProduct.id),
            title: cartProduct.title ?? "",
            price: cartProduct.price,
            description: cartProduct.about ?? "",
            category: cartProduct.category ?? "",
            image: cartProduct.imageStringURL ?? "",
            quantity: Int(cartProduct.quantity)
        )
    }
    
    func editCartProductQuantity(product: CartProduct?, quantity: Int) {
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

enum CoreDataError: Error {
    case productNotFound
    case cartProductNotFound
    case coreDataError
    case quantityEditingError
}
