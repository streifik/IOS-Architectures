//
//  CartTableViewCell.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 02.08.23.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func increaseButtonTapped(in cell: CartTableViewCell)
    func decreaseButtonTapped(in cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    
    // MARK: Outlets

    @IBOutlet weak var productsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabbel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    
    // MARK: Variables
    
    weak var delegate: CartTableViewCellDelegate?
    
    // MARK: Methods
    
    func configure(cartProduct: CartProduct) {
        titleLabel.text = cartProduct.title
        priceLabbel.text = String(cartProduct.price) + "$"
        quantityLabel.text = String(cartProduct.quantity)
        
        if let imageStringUrl = cartProduct.imageStringURL {
            productsImageView.imageFromURL(urlString: imageStringUrl)
        }
        selectionStyle = .none
        containerView.layer.cornerRadius = 20
    }
    
    // MARK: Actions
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        delegate?.increaseButtonTapped(in: self)
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        delegate?.decreaseButtonTapped(in: self)
    }
}
