//
//  DetailProductsInteractor.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

// MARK: Protocols

protocol DetailProductsInteractorProtocol: AnyObject {
    var product: Product { get set }
    func addProductToCart()
    func checkProductExistInCart(product: Product?, completion: @escaping (Result<CartProduct?, CoreDataError>) -> Void)
    func editProductQuantity(newQuantity: Int)
    var isAddToCartStackViewHidden: Bool { get set }
}

class DetailProductsInteractor: DetailProductsInteractorProtocol {
    
    // MARK: Variables
    
    let coreDataService: CoreDataServiceProtocol
    var product: Product
    var isAddToCartStackViewHidden: Bool = false
    weak var presenter: DetailProductsPresenterProtocol?
    
    // MARK: initialisers
    
    init(product: Product, coreDataService: CoreDataServiceProtocol, isAddToCartStackViewHidden: Bool) {
        self.product = product
        self.coreDataService = coreDataService
        self.isAddToCartStackViewHidden = isAddToCartStackViewHidden
    }
    
    // MARK: Methods
    
    func addProductToCart() {
        // check if product exist
        if let cartProduct = coreDataService.fetchProduct(id: product.id) {
            // increase quantity
            cartProduct.quantity += 1
            coreDataService.saveContext()
            let data: Result<CartProduct?, CoreDataError> = .success(cartProduct)
            presenter?.cartProductQuantityUpdated(data: data)
        } else {
            // add new product
            if let product = coreDataService.addProduct(id: product.id, about: product.description, title: product.title, category: product.category, price: product.price, quantity: 1, imageStringURL: product.image) {
                let data: Result<CartProduct?, CoreDataError> = .success(product)
                presenter?.cartProductQuantityUpdated(data: data)
            }
        }
    }
    
    func editProductQuantity(newQuantity: Int) {
        if let cartProduct = coreDataService.fetchProduct(id: self.product.id){
            cartProduct.quantity += Int64(newQuantity)
            product.quantity = Int(cartProduct.quantity)
            if cartProduct.quantity == 0 {
                coreDataService.deleteProductFromCart(product: cartProduct)
            }
            coreDataService.saveContext()
            let data: Result<CartProduct?, CoreDataError> = .success(cartProduct)
            presenter?.cartProductQuantityUpdated(data: data)
        } else {
            let data: Result<CartProduct?, CoreDataError> = .failure(.cartProductNotFound)
            presenter?.cartProductQuantityUpdated(data: data)
        }
    }
    
    func checkProductExistInCart(product: Product?, completion: @escaping (Result<CartProduct?, CoreDataError>) -> Void) {
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
}

enum ProductDetailError: Error {
    case productNotFound
    case cartProductNotFound
    case coreDataError
    case quantityEditingError
}

