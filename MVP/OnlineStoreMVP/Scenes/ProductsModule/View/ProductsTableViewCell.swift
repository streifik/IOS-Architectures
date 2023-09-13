//
//  ProductsTableViewCell.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 21.07.23.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    // MARK: Outlets
 
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    // MARK: Methods
    
    func configure(product: Product) {
        productTitle.text = product.title
        productPrice.text = "Price: \(product.price)$"
        productImageView.imageFromURL(urlString: product.image)
        selectionStyle = .none
        containerView.layer.cornerRadius = 20
    }
}
