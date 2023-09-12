//
//  ProductsTableViewCell.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
    
    // MARK: Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productsImageView: UIImageView!
    
    // MARK: Methods
    
    func configure(product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "Price: \(product.price)$"
        productsImageView.imageFromURL(urlString: product.image)
        
        containerView.layer.cornerRadius = 20
        selectionStyle = .none
    }
}
