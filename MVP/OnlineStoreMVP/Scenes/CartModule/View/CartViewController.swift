//
//  CartViewController.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 26.07.23.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: Variables
    
    var presenter: CartViewPresenterProtocol!
    
    // MARK: Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getCartProducts()
        navigationItem.title = "Cart"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        cartTableView.separatorStyle = .none
        messageLabel.clipsToBounds = true
        messageLabel.layer.cornerRadius = 10
    }
}

// MARK: Extensions

extension CartViewController: CartViewProtocol {
    func handleError(error: CoreDataError) {
        showAlert(title: "Error", message: errorMessage(for: error))
    }
    
    func updateViewWithCartProducts(_ cartProducts: [CartProduct]) {
        if cartProducts.isEmpty {
            messageLabel.isHidden = false
        } else {
            messageLabel.isHidden = true
        }
        cartTableView.reloadData()
    }
    
    func failure() {
        print("Some error with fetching Core Data objects")
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.cartProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        if let cartProduct = presenter.cartProducts?[indexPath.row] {
            cell.configure(cartProduct: cartProduct)
        }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cartProduct = presenter.cartProducts?[indexPath.row] {
        presenter.productCellTapped(cartProduct: cartProduct)
        }
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func increaseButtonTapped(in cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell), let cartProduct = presenter.cartProducts?[indexPath.row] {
            presenter.editProductQuantity(product: cartProduct, quantity: Int(cartProduct.quantity) + 1)
        }
    }
    
    func decreaseButtonTapped(in cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell), let cartProduct = presenter.cartProducts?[indexPath.row], cartProduct.quantity > 0 {
            presenter.editProductQuantity(product: cartProduct, quantity: Int(cartProduct.quantity) - 1)
        }
    }
}
