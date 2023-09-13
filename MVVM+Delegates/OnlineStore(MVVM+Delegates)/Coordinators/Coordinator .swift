//
//  Coordinator .swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
    func showDetail(product: Product?, isAddToCartStackViewHidden: Bool)
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var tabBarController: UITabBarController

    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }

    func start() {
        setupTabBar()
    }

    func setupTabBar() {
        let productsViewController = ProductsViewController()
        let productsViewModel = ProductsViewModel()
        productsViewModel.appCoordinator = self
        productsViewController.viewModel = productsViewModel
        let productsNavController = UINavigationController(rootViewController: productsViewController)
        productsNavController.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "list.clipboard.fill"), tag: 0)

        let cartViewController = CartViewController()
        let cartViewModel = CartViewModel()
        cartViewModel.appCoordinator = self
        cartViewController.viewModel = cartViewModel
        cartViewModel.coreDataService = CoreDataService.shared
        let cartNavController = UINavigationController(rootViewController: cartViewController)
        cartNavController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)

        tabBarController.viewControllers = [productsNavController, cartNavController]
    }

    func goToProductsPage() {
        let productsViewController = ProductsViewController()
        let productsViewModel = ProductsViewModel()
        productsViewModel.appCoordinator = self
        productsViewController.viewModel = productsViewModel
        navigationController.pushViewController(productsViewController, animated: true)
    }

    func showDetail(product: Product?, isAddToCartStackViewHidden: Bool) {
        let detailViewController = ProductDetailViewController()
        let detailViewModel = ProductDetailViewModel()
        detailViewModel.appCoordinator = self
        detailViewModel.selectedProduct = product
        detailViewController.viewModel = detailViewModel
        detailViewModel.coreDataService = CoreDataService.shared
        detailViewModel.isAddToCartStackViewHidden = isAddToCartStackViewHidden

        if let selectedViewController = tabBarController.selectedViewController as? UINavigationController {
            detailViewController.hidesBottomBarWhenPushed = true
            selectedViewController.pushViewController(detailViewController, animated: true)
        }
    }
}

