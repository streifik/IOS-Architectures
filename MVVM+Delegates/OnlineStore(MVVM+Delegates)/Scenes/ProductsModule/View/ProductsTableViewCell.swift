//
//  ProductsTableViewCell.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
    
    // MARK: Variables
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemIndigo
        
        return label
    }()
    
    // MARK: Initialisers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Methods
    
    func configure(product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "Price: \(product.price)$"
        productImageView.imageFromURL(urlString: product.image)
        selectionStyle = .none
    }
    
    func setUpUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(containerView)
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    func setUpConstraints() {
        // ContainerView
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 320)
        ])
        
        // ProductImageView
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalToConstant: 220),
            productImageView.widthAnchor.constraint(equalToConstant: 220),
            productImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 41),
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
        ])
        
        // TitleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 19),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 41)
        ])
        
        // PriceLabel
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            priceLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 41),
            priceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
}


