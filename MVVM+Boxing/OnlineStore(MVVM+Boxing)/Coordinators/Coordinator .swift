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
    func showDetail(product: Product?, isAddToCartButtonHidden: Bool)
}

class AppCoordinator: Coordinator {
    
    // MARK: Variables

    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
    
    // MARK: Initialisers

    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        
    }
    
    // MARK: Methods

    func start() {
        setupTabBar()
    }
    
    func setupTabBar() {
        let productsViewController = storyboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        let productsViewModel = ProductsViewModel()
        productsViewModel.appCoordinator = self
        productsViewController.viewModel = productsViewModel
        
        // Set the label and icon for the tab bar item of the "Products" tab
        let productsNavController = UINavigationController(rootViewController: productsViewController)
        productsNavController.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "list.clipboard.fill"), tag: 0)
        productsNavController.navigationBar.prefersLargeTitles = true
        
        let cartViewController = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        let cartViewModel = CartViewModel()
        cartViewModel.appCoordinator = self
        cartViewController.viewModel = cartViewModel
        cartViewModel.coreDataService = CoreDataService.shared
        
        // Set the label and icon for the tab bar item of the "Products" tab
        let cartNavController = UINavigationController(rootViewController: cartViewController)
        cartNavController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)
        tabBarController.viewControllers = [productsNavController, cartNavController]
    }
    
    func goToProductsPage() {
        let productsViewController = storyboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        let productsViewModel = ProductsViewModel.init()
        productsViewModel.appCoordinator = self
        productsViewController.viewModel = productsViewModel
        navigationController.pushViewController(productsViewController, animated: true)
    }
    
    func showDetail(product: Product?, isAddToCartButtonHidden: Bool) {
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        let detailViewModel = ProductDetailViewModel.init()
        detailViewModel.appCoordinator = self
        detailViewModel.selectedProduct = product
        detailViewController.viewModel = detailViewModel
        detailViewModel.coreDataService = CoreDataService.shared
        detailViewModel.isAddToCartButtonHidden = isAddToCartButtonHidden
   
        // Get the currently selected view controller from the tab bar controller
        if let selectedViewController = tabBarController.selectedViewController as? UINavigationController {
        
            // Push the detail view controller onto the navigation stack of the currently selected tab
     
            selectedViewController.pushViewController(detailViewController, animated: true)
        }
    }
}

