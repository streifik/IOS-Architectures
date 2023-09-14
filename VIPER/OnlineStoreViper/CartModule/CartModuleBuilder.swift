//
//  CartModuleBuilder.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

import UIKit

class CartModuleBuilder {
    static func build() -> CartViewController {
        let interactor = CartInteractor(coreDataService: CoreDataService.shared)
        let router = CartRouter()
        let presenter = CartPresenter(interactor: interactor, router: router)
        let viewController = CartViewController()
        presenter.view  = viewController
        viewController.presenter = presenter
        interactor.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
