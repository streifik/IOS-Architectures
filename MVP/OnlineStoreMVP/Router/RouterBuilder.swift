//
//  RouterBuilder.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 21.07.23.
//

import Foundation
import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
    var tabBarController: UITabBarController? { get set }
    
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(product: Product?, isAddToCartButtonHidden: Bool)
    func showDetailFromCart(product: Product?, isAddToCartButtonHidden: Bool)
    func popToRoot()
    func createCartViewController()
    
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var cartNavigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    var tabBarController: UITabBarController?
    
    init(navigationController: UINavigationController, tabBarController: UITabBarController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.assemblyBuilder = assemblyBuilder
    }
    func initialViewController() {
            guard let productsViewController = assemblyBuilder?.createProductsModule(router: self) else { return }

            guard let cartViewController = assemblyBuilder?.createCartModule(router: self) else { return }
        
            let productsNavController = UINavigationController(rootViewController: productsViewController)
            let cartNavController = UINavigationController(rootViewController: cartViewController)

            guard let tabBarController = tabBarController else { return }
            tabBarController.viewControllers = [productsNavController , cartNavController]
        
            productsNavController.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "list.clipboard.fill"), tag: 0)
            cartNavController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)
        
            self.navigationController = productsNavController
            self.cartNavigationController = cartNavController
        }
    
    func showDetail(product: Product?, isAddToCartButtonHidden: Bool) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createDetailProductsModule(product: product, router: self, isAddToCartButtonHidden: isAddToCartButtonHidden) else { return }
            detailViewController.hidesBottomBarWhenPushed = true 
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func showDetailFromCart(product: Product?, isAddToCartButtonHidden: Bool) {
        if let cartNavigationController = cartNavigationController {
            guard let detailViewController = assemblyBuilder?.createDetailProductsModule(product: product, router: self, isAddToCartButtonHidden: isAddToCartButtonHidden) else { return }
            cartNavigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func createCartViewController() {
        
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
