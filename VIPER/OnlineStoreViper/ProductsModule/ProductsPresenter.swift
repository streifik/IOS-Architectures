//
//  ProductsPresenter.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 08.08.23
//

// MARK: Protocols

protocol ProductsPresenterProtocol: AnyObject {
    func viewLoaded()
    func productsLoaded(products: [Product]?)
    func handleError(error: ProductError)
    func categorySelected(category: String)
    func productSelected(product: Product)
    var products: [Product]? { get }
}

class ProductsPresenter {
    
    // MARK: Variables
    
    weak var view: ProductsViewProtocol?
    var router: ProductsRouterProtocol
    var interactor: ProductsInteractorProtocol
    var products: [Product]? = []
    
    // MARK: Ininitialiser

    init(interactor: ProductsInteractorProtocol, router: ProductsRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: ProductPresenterProtocol

extension ProductsPresenter: ProductsPresenterProtocol {
    func handleError(error: ProductError) {
        view?.handleError(error: error)
    }
    
    func productSelected(product: Product) {
        router.showProductDetail(product: product)
    }
    
    func categorySelected(category: String) {
        interactor.getProductsByCategory(category: category)
    }
    
    func productsLoaded(products: [Product]?) {
        self.products = products
        view?.fillTableView(products: products)
    }
    
    func viewLoaded() {
        interactor.loadProducts()
    }
}
