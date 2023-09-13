//
//  CartTableViewCell.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 26.07.23.
//

import UIKit

// MARK: Protocols

protocol CartTableViewCellDelegate: AnyObject {
    func increaseButtonTapped(in cell: CartTableViewCell)
    func decreaseButtonTapped(in cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    // MARK: Variables
    
    weak var delegate: CartTableViewCellDelegate?
    
    // MARK: Methods
    
    func configure(cartProduct: CartProduct) {
        productTitle.text = cartProduct.title
        productPrice.text = "\(cartProduct.price)$"
        quantityLabel.text = String(cartProduct.quantity)
        
        if let imageStringUrl = cartProduct.imageStringURL {
            productImageView.imageFromURL(urlString: imageStringUrl)
        }
        selectionStyle = .none
        containerView.layer.cornerRadius = 20
    }
    
    // MARK: Actions
    
    @IBAction func increaseQuantityButtonTapped(_ sender: UIButton) {
        delegate?.increaseButtonTapped(in: self)
    }
    
    @IBAction func decreaseQuantityButtonTapped(_ sender: UIButton) {
        delegate?.decreaseButtonTapped(in: self)
    }
}
