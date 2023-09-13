//
//  AssemblyBuilder.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 21.07.23.
//

import Foundation
import UIKit


// MARK: Protocols

protocol AssemblyBuilderProtocol {
    func createProductsModule(router: RouterProtocol) -> UIViewController
    func createDetailProductsModule (product: Product?, router: RouterProtocol, isAddToCartButtonHidden: Bool) -> UIViewController
    func createCartModule (router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    // MARK: Methods
    
    func createCartModule(router: RouterProtocol) -> UIViewController {
        let view = CartViewController()
        let presenter = CartViewPresenter(view: view, coreDataService: CoreDataService.shared, router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createDetailProductsModule(product: Product?, router: RouterProtocol, isAddToCartButtonHidden: Bool) -> UIViewController {
        let view = DetailProductsViewController()
        let networkService = NetworkService()
        let presenter  = DetailProductsPresenter(view: view, networkService: networkService, coreDataService: CoreDataService.shared, router: router, product: product)
        presenter.isAddToCartButtonHidden = isAddToCartButtonHidden
        view.presenter = presenter
        
        return view
    }
    
    func createProductsModule(router: RouterProtocol) -> UIViewController {
        let view = ProductsViewController()
        let networkService = NetworkService()
        let presenter = ProductsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
}
