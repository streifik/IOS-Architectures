//
//  DetailProductsViewController.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 21.07.23.
//

import UIKit

class DetailProductsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var addToCartStackView: UIStackView!
    @IBOutlet weak var productsImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    // MARK: Variables
    
    var presenter: DetailProductsPresenter!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter.isAddToCartButtonHidden {
            addToCartStackView.isHidden = true
        } else {
            addToCartStackView.isHidden = false
        }
        
        if let product = presenter.product {
            productTitle.text = product.title
            productPrice.text = "\(product.price)$"
            productDescription.text = product.description
            productsImageView.imageFromURL(urlString: product.image)
            getCartProductQuantity(product: product)
        }
        navigationController?.hidesBottomBarWhenPushed = true 
    }
    
    // MARK: Methods
    
    func getCartProductQuantity(product: Product?) {
        guard let product = product else { return }
        presenter.checkProductExistInCart(product: product) { [weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let cartProduct):
                if let quantity = cartProduct?.quantity {
                    self.quantityStackView.isHidden = false
                    self.quantityLabel.text = String(quantity)
                } else {
                    self.quantityStackView.isHidden = true
                }
            case .failure:
                self.quantityStackView.isHidden = true
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func decreaseButtonTapped(_ sender: Any) {
        presenter.checkProductExistInCart(product: presenter.product) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cartProduct):
                if cartProduct?.quantity != 0 {
                    self.presenter.editProductQuantity(product: self.presenter.product, newQuantity: 1)
                    self.quantityLabel.text = String(self.presenter.product?.quantity ?? 0)
                }
            case .failure(let error):
                if error == .cartProductNotFound {
                    // Add new product
                    self.presenter.addToCart(product: self.presenter.product)
                } else {
                    self.showAlert(title: "Error", message: self.errorMessage(for: error))
                }
            }
        }
    }
    
    @IBAction func increaseButtonTapped(_ sender: UIButton) {
        presenter.editProductQuantity(product: presenter.product, newQuantity: -1)
        quantityLabel.text = String(presenter.product?.quantity ?? 0)
    }
    
    @IBAction func addToCardButtonTapped(_ sender: Any) {
        addToCart(product: presenter.product)
    }
}

extension DetailProductsViewController: DetailProductsViewProtocol {
    func productAddedToCart(cartProduct: CartProduct?, error: CoreDataError?) {
        if let cartProduct = cartProduct {
            quantityStackView.isHidden = cartProduct.quantity == 0 ? true : false
            quantityLabel.text = String(cartProduct.quantity)
        } else {
            quantityStackView.isHidden = true
        }
        if let error = error {
            showAlert(title: "Error", message: errorMessage(for: error))
        }
    }
    
    func addToCart(product: Product?) {
        presenter.addToCart(product: product)
    }
}
