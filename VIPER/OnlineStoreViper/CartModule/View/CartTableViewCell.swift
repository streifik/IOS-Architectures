//
//  CartTableViewCell.swift
//  OnlineStoreVIPER
//
//  Created by Dmitry Telpov on 09.08.23.
//

import UIKit

// MARK: Protocols

protocol CartTableViewCellDelegate: AnyObject {
    func increaseButtonTapped(in cell: CartTableViewCell)
    func decreaseButtonTapped(in cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    
    // MARK: Variables
    
    weak var delegate: CartTableViewCellDelegate?
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    var quantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        label.text = "Title"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemIndigo
        
        return label
    }()
    
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        
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
    
    var currentImageURL: String?

    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(containerView)
        containerView.addSubview(quantityStackView)
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        setupConstraints()
    
        quantityStackView.addArrangedSubview(increaseQuantityButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(decreaseQuantityButton)
        quantityStackView.alignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Methods
    
    @objc func increaseButtonTapped(_ sender: UIButton) {
         delegate?.increaseButtonTapped(in: self)
     }

     @objc func decreaseButtonTapped(_ sender: UIButton) {
         delegate?.decreaseButtonTapped(in: self)
     }
    
    func setupConstraints() {
        // ContainerView
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        
        // ProductImageView
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        ])
        
        // TitleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: quantityStackView.leftAnchor, constant: -10),
            titleLabel.widthAnchor.constraint(equalToConstant: 167)
        ])
        
        // PriceLabel
        NSLayoutConstraint.activate([
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            priceLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 20),
            priceLabel.rightAnchor.constraint(equalTo: quantityStackView.leftAnchor, constant: -10)
        ])
        
        // QuantityStackView
        NSLayoutConstraint.activate([
            quantityStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            quantityStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -25),
            quantityStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            quantityStackView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(cartProduct: CartProduct) {
        if let imageURL = cartProduct.imageStringURL {
            productImageView.imageFromURL(urlString: imageURL)
        }
        titleLabel.text = cartProduct.title
        priceLabel.text = "\(cartProduct.price)$"
        quantityLabel.text = String(cartProduct.quantity)
        
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 3
    }
}
