//
//  CartRouter.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

protocol CartRouterProtocol {
    func showProductDetail(product: Product)
}

class CartRouter: CartRouterProtocol {
    weak var viewController: CartViewController?
    
    func showProductDetail(product: Product) {
        let detailViewController = DetailProductsModuleBuilder.build(product: product, isAddToCartStackViewHidden: true)
        detailViewController.hidesBottomBarWhenPushed = true 
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
