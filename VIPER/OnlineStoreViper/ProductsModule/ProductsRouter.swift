//
//  ProductsRouter.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 08.08.23
//
import UIKit

// MARK: Protocols

protocol ProductsRouterProtocol {
    func showProductDetail(product: Product)
}

class ProductsRouter: ProductsRouterProtocol {
    
    // MARK: Variables
    
    weak var viewController: ProductsViewController?
    
    // MARK: Methods
    
    func showProductDetail(product: Product) {
        let detailViewController = DetailProductsModuleBuilder.build(product: product, isAddToCartStackViewHidden: false)
        detailViewController.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    static func setUpTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        let productsViewController = ProductsModuleBuilder.build()
        let productsNavigationController = UINavigationController(rootViewController: productsViewController)
        let cartViewController = CartModuleBuilder.build()
        let cartNavigationController = UINavigationController(rootViewController: cartViewController)

        tabBarController.viewControllers = [productsNavigationController, cartNavigationController]
        productsNavigationController.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "list.clipboard.fill"), tag: 0)
        cartNavigationController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)
        
        return tabBarController
    }
}
