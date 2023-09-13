//
//  ProductDetailViewController.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: Variables
    
    var viewModel = ProductDetailViewModel()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "cart")
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemIndigo
        return label
    }()
    
    var desciptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    var addToCartButton: UIButton = {
        let button = ActualGradientButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.titlePadding = 10
        configuration.imagePadding = 40
        button.configuration = configuration
        return button
    }()
    
    var addToCartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var quantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemIndigo
        return label
    }()
    
    var increaseQuantityButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(increaseButtonTapped),
                         for: .touchUpInside)
        return button
    }
    
    var decreaseQuantityButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(decreaseButtonTapped),
                         for: .touchUpInside)
        return button
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpConstraints()
        getCartProductQuantity(product: viewModel.selectedProduct)
        viewModel.productDetailViewModelDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = contentView.frame.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.isAddToCartStackViewHidden {
            addToCartStackView.isHidden = true
        } else {
            addToCartStackView.isHidden = false
        }
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Methods
    
    
    func getCartProductQuantity(product: Product?) {
        guard let product = product else { return }
        viewModel.getCartProductQuantity(from: product) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quantity):
                self.quantityStackView.isHidden = false
                self.quantityLabel.text = "\(quantity)"
            case .failure(let error):
                self.quantityStackView.isHidden = true
                if error != .cartProductNotFound {
                    self.showAlert(title: "Error", message: self.errorMessage(for: error))
                }
            }
        }
    }
    
    @objc func increaseButtonTapped(_ sender: UIButton) {
        viewModel.getCartProductQuantity(from: viewModel.selectedProduct) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.viewModel.editProductQuantity(product: self.viewModel.selectedProduct, newQuantity: 1)
                self.quantityLabel.text = String(self.viewModel.selectedProduct?.quantity ?? 0)
            case .failure(let error):
                if error == .cartProductNotFound {
                    // Add new product
                    self.viewModel.addToCart(product: self.viewModel.selectedProduct)
                } else {
                    self.showAlert(title: "Error", message: self.errorMessage(for: error))
                }
            }
        }
    }
    
    @objc func decreaseButtonTapped(_ sender: UIButton) {
        viewModel.editProductQuantity(product: viewModel.selectedProduct, newQuantity: -1)
        quantityLabel.text = String(viewModel.selectedProduct?.quantity ?? 0)
    }
    
    @objc func addToCartButtonTapped(_ sender: UIButton) {
        quantityStackView.isHidden = false
        viewModel.addToCart(product: viewModel.selectedProduct)
    }
    
    func setUpUI() {
        addToCartButton.addTarget(self,
                                  action: #selector(self.addToCartButtonTapped),
                                  for: .touchUpInside)
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(quantityStackView)
        view.addSubview(addToCartStackView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(desciptionLabel)
        quantityStackView.addArrangedSubview(increaseQuantityButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(decreaseQuantityButton)
        addToCartStackView.addArrangedSubview(addToCartButton)
        addToCartStackView.addArrangedSubview(quantityStackView)
        
        if let product = viewModel.selectedProduct {
            titleLabel.text = product.title
            priceLabel.text = "\(product.price)$"
            desciptionLabel.text = product.description
            productImageView.imageFromURL(urlString: product.image)
            
            viewModel.getCartProductQuantity(from: product) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let quantity):
                    self.quantityStackView.isHidden = false
                    self.quantityStackView.isHidden = false
                    self.quantityLabel.text = "\(quantity)"
                case .failure:
                    self.quantityStackView.isHidden = true
                }
            }
        }
    }
    
    
    func setUpConstraints() {
        // ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -125)
        ])
        
        // ContentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // ProductImageView
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalToConstant: 300),
            productImageView.widthAnchor.constraint(equalToConstant: 300),
            productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 46),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30)
        ])
        
        // TitleLabel
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -21),
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 53)
        ])
        
        //PriceLabel
        NSLayoutConstraint.activate([
            priceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21),
            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -21),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        ])
        
        // DescriptionLabel
        NSLayoutConstraint.activate([
            desciptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21),
            desciptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -21),
            desciptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            desciptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35)
        ])
        
        NSLayoutConstraint.activate([
            quantityStackView.widthAnchor.constraint(equalToConstant: 80),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            addToCartStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 30),
            addToCartStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addToCartStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 60),
            addToCartStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
        ])
    }
}

// MARK: Extensions

extension ProductDetailViewController: ProductDetailViewModelDelegate {
    func productAddedToCart(cartProduct: CartProduct?, error: CoreDataError?) {
        if let cartProduct = cartProduct {
            quantityStackView.isHidden = cartProduct.quantity == 0 ? true : false
            quantityLabel.text = "\(cartProduct.quantity)"
        } else {
            quantityStackView.isHidden = true
        }
        
        if let error = error {
            showAlert(title: "Error", message: errorMessage(for: error))
        }
    }
}
