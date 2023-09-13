//
//  ProduuctsHeaderView.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 30.08.23.
//

import UIKit

protocol ProductsHeaderViewDelegate: AnyObject {
    func headerViewDidTapButton(headerView: ProductsHeaderView)
}

class ProductsHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectCategoryButton: UIButton!

    // MARK: Variables
    
    weak var delegate: ProductsHeaderViewDelegate?
    
    // MARK: Actions
    
    @IBAction func headerButtonPressed(_ sender: Any) {
        delegate?.headerViewDidTapButton(headerView: self)
    }
}

