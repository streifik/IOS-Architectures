//
//  ProductsModuleBuilder.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 08.08.23
//

import UIKit

class ProductsModuleBuilder {
    static func build() -> ProductsViewController {
        let interactor = ProductsInteractor()
        let router = ProductsRouter()
        let presenter = ProductsPresenter(interactor: interactor, router: router)
        let viewController = ProductsViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
