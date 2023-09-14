//
//  DetailProductsModuleBuilder.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

import UIKit

class DetailProductsModuleBuilder {
    static func build(product: Product,isAddToCartStackViewHidden: Bool) -> DetailProductsViewController {
        let interactor = DetailProductsInteractor(product: product, coreDataService: CoreDataService.shared, isAddToCartStackViewHidden: isAddToCartStackViewHidden)
        let router = DetailProductsRouter()
        let presenter = DetailProductsPresenter(interactor: interactor, router: router)
        let viewController = DetailProductsViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
