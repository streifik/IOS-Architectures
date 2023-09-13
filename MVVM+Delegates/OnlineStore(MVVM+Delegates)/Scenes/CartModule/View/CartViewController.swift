//
//  CartViewController.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 02.08.23.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: Variables

    let cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var messageLabel: UILabel!
    var viewModel = CartViewModel()
    weak var delegate: CartTableViewCellDelegate?
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getCartProducts()
        navigationItem.title = "Cart"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        viewModel.getCartProducts()
        viewModel.cartViewModelDelegate = self
        setUpUI()
        view.addSubview(cartTableView)
        view.addSubview(messageLabel)
        setUpConstraints()
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
    }
    
    func setupMessageLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cart is empty"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.textColor = .white
        label.backgroundColor = .systemGray3
        
        view.addSubview(label)
        messageLabel = label
    }
    
    // MARK: Methods
    
    func setUpUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupMessageLabel()
    }
    func setupTableView() {
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.backgroundColor = .secondarySystemBackground
        cartTableView.separatorStyle = .none
        cartTableView.sectionHeaderTopPadding = 0.0
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(equalToConstant: 170),
            messageLabel.heightAnchor.constraint(equalToConstant: 45),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cartTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            cartTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            cartTableView.topAnchor.constraint(equalTo: view.topAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: Extensions

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        if let cartProduct = viewModel.cartProducts?[indexPath.row] {
            cell.configure(cartProduct: cartProduct)
        }
        cell.delegate = self
  
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cartProduct = viewModel.cartProducts?[indexPath.row] {
            viewModel.cartProductCellTapped(cartProduct: cartProduct)
        }
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func increaseButtonTapped(in cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell) {
            if let cartProduct = viewModel.cartProducts?[indexPath.row] {
                viewModel.editProductQuantity(product: cartProduct, quantity: Int(cartProduct.quantity) + 1)
            }
        }
    }
    
    func decreaseButtonTapped(in cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell) {
            if let cartProduct = viewModel.cartProducts?[indexPath.row], cartProduct.quantity > 0 {
                viewModel.editProductQuantity(product: cartProduct, quantity: Int(cartProduct.quantity) - 1)
            }
        }
    }
}

extension CartViewController: CartViewModelDelegate {
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
}

