//
//  DetailProductsPresenter.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

// MARK: Variables

protocol DetailProductsPresenterProtocol: AnyObject {
    func viewLoaded()
    func productAddedToCart()
    func changeProductQuantity(newQuantity: Int)
    func cartProductQuantityUpdated(data: Result<CartProduct?, CoreDataError>)
    func checkIsAddToCartStackViewHidden() -> Bool
}

class DetailProductsPresenter {
    
    // MARK: Variables
    
    weak var view: DetailProductsViewProtocol?
    var router: DetailProductsRouterProtocol
    var interactor: DetailProductsInteractorProtocol

    // MARK: Initialiser
    
    init(interactor: DetailProductsInteractorProtocol, router: DetailProductsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: DetailProductsPresenterProtocol

extension DetailProductsPresenter: DetailProductsPresenterProtocol {
    func checkIsAddToCartStackViewHidden() -> Bool {
        return interactor.isAddToCartStackViewHidden ? true : false
    }
    
    func changeProductQuantity(newQuantity: Int) {
        interactor.editProductQuantity(newQuantity: newQuantity)
    }
    
    func cartProductQuantityUpdated(data: Result<CartProduct?, CoreDataError>) {
        switch data {
        case .success(let cartProduct):
            view?.fillCartProductData(cartProduct: cartProduct)
        case .failure(let error):
            view?.handleError(error: error)
        }
    }
    
    func productAddedToCart() {
        interactor.addProductToCart()
    }
    
    func viewLoaded() {
        let product = interactor.product
        view?.fillProductData(product: product)
        
        interactor.checkProductExistInCart(product: product) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cartProduct):
                self.view?.fillCartProductData(cartProduct: cartProduct)
            case .failure(let error):
                self.view?.handleError(error: error)
            }
        }
    }
}



