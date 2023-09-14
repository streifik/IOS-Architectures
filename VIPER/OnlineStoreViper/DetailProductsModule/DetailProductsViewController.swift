//
//  DetailProductsViewController.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

import UIKit

// MARK: Protocols

protocol DetailProductsViewProtocol: AnyObject {
    func fillProductData(product: Product)
    func fillCartProductData(cartProduct: CartProduct?)
    func handleError(error: CoreDataError)
}

class DetailProductsViewController: UIViewController {
    
    // MARK: Variables
    
    var presenter: DetailProductsPresenterProtocol?
    
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
        initialize()
    }
    
    // MARK: Methods
    
    func initialize() {
        presenter?.viewLoaded()
    }
    
    func setUpUI() {
        addToCartButton.addTarget(self,
                                   action: #selector(addToCartButtonTapped),
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
        
        if let addToCartStackViewHidden = presenter?.checkIsAddToCartStackViewHidden {
            if addToCartStackViewHidden() {
                addToCartStackView.isHidden = true
            } else {
                addToCartStackView.isHidden = false
            }
        }
    }

    func setUpConstraints() {
        // ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: addToCartStackView.isHidden ? 0 : -125)
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
        
        // AddToCartStack
        NSLayoutConstraint.activate([
            addToCartStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 30),
            addToCartStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addToCartStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 60),
            addToCartStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
        ])
 
        NSLayoutConstraint.activate([
            quantityStackView.widthAnchor.constraint(equalToConstant: 80),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func decreaseButtonTapped(_ sender: UIButton) {
        presenter?.changeProductQuantity(newQuantity: -1)
    }
    
    @objc func addToCartButtonTapped(_ sender: UIButton) {
        quantityStackView.isHidden = false
        presenter?.productAddedToCart()
    }
    
    @objc func increaseButtonTapped(_ sender: UIButton) {
        presenter?.changeProductQuantity(newQuantity: 1)
    }
    
    private func errorMessage(for error: ProductDetailError) -> String {
        switch error {
        case .cartProductNotFound:
            return "Cart product not found."
        case .coreDataError:
            return "An error occurred while fetching data."
        case .quantityEditingError:
            return "An error occurred while editing quantity."
        case .productNotFound:
            return "Product not found."
        }
    }
}

// MARK: - DetailProductsViewProtocol

extension DetailProductsViewController: DetailProductsViewProtocol {
    func fillCartProductData(cartProduct: CartProduct?) {
        if let quantity = cartProduct?.quantity {
            if quantity != 0 {
                quantityStackView.isHidden = false
                quantityLabel.text = String(quantity)
            } else {
                quantityStackView.isHidden = true
            }
        } else {
            quantityStackView.isHidden = true
        }
    }
    
    func handleError(error: CoreDataError) {
        if error == .cartProductNotFound {
            quantityStackView.isHidden = true
        } else {
            showAlert(title: "Error", message: errorMessage(for: error))
        }
    }
    
    func fillProductData(product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "\(product.price)$"
        desciptionLabel.text = product.description
        productImageView.imageFromURL(urlString: product.image)
    }
}
