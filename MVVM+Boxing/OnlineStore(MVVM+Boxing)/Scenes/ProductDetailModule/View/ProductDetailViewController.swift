//
//  ProductDetailViewController.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var addToCartStackView: UIStackView!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    // MARK: Variables
    
    var viewModel = ProductDetailViewModel()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.isAddToCartButtonHidden {
            addToCartStackView.isHidden = true
            scrollViewBottomConstraint.constant = 0
        } else {
            addToCartStackView.isHidden = false
            scrollViewBottomConstraint.constant = 125
        }
        bindViewModel()
        
        if let product = viewModel.selectedProduct {
            productLabel.text = product.title
            priceLabel.text = "\(product.price)$"
            descriptionLabel.text = product.description
            productImageView.imageFromURL(urlString: product.image)
            
            getCartProductQuantity(product: product)
        }
        scrollView.contentSize = CGSize(width: view.bounds.width, height: max(view.bounds.height + 1, view.frame.size.height))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: Methods
    
    func bindViewModel() {
        viewModel.cartProduct.bind {[weak self] product in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let quantity = product?.quantity {
                    if quantity > 0 {
                        self.quantityStackView.isHidden = false
                        self.quantityLabel.text = String(quantity)
                    } else {
                        self.quantityStackView.isHidden = true
                    }
                }
            }
        }
    }
    
    func getCartProductQuantity(product: Product) {
        viewModel.checkProductExistInCart(product: product) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cartProduct):
                self.viewModel.cartProduct.value = cartProduct
                self.bindViewModel()
            case .failure(let error):
                if error == .cartProductNotFound {
                    self.quantityStackView.isHidden = true
                } else {
                    self.showAlert(title: "Error", message: self.errorMessage(for: error))
                }
            }
        }
    }

    // MARK: Actions
    
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
       viewModel.addToCart(product: viewModel.selectedProduct) {[weak self] result in
           guard let self = self else { return }
            switch result {
            case .success(let cartProduct):
                self.viewModel.cartProduct.value = cartProduct
                self.quantityStackView.isHidden = false
            case .failure(let error):
                self.showAlert(title: "Error", message: self.errorMessage(for: error))
            }
        }
    }
    
    @IBAction func increaseQuantityButtonTapped(_ sender: UIButton) {
        if let quantity = viewModel.cartProduct.value?.quantity {
            viewModel.editProductQuantity(product: viewModel.cartProduct.value, quantity: Int(quantity) + 1) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let cartProduct):
                    self.viewModel.cartProduct.value = cartProduct
                case .failure(let error):
                    self.showAlert(title: "Error", message: self.errorMessage(for: error))
                }
            }
        }
    }
    
    @IBAction func decreaseQuantityButtonTapped(_ sender: UIButton) {
        if let quantity = viewModel.cartProduct.value?.quantity {
            viewModel.editProductQuantity(product: viewModel.cartProduct.value, quantity: Int(quantity) - 1) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let cartProduct):
                    self.viewModel.cartProduct.value = cartProduct
                case .failure(let error):
                    self.showAlert(title: "Error", message: self.errorMessage(for: error))
                }
            }
        }
    }
}
