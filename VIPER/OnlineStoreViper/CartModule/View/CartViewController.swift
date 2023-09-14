//
//  CartViewController.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 09.08.23
//

import UIKit

// MARK: Protocols

protocol CartViewProtocol: AnyObject {
    func updateView()
    func handleError(error: CoreDataError)
}

class CartViewController: UIViewController {
    
    // MARK: Variables
    
    let cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var messageLabel: UILabel!
    var presenter: CartPresenterProtocol?
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewLoaded()
        navigationItem.title = "Products"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: Methods
    
    func initialize() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Cart"
        setupMessageLabel()
        view.addSubview(cartTableView)
        view.addSubview(messageLabel)
       
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        setUpUI()
        setupTableView()
        setUpConstraints()
        presenter?.viewLoaded()
    }
    
    func updateView() {
        if (presenter?.cartProducts == nil) || presenter?.cartProducts?.count == 0 {
           messageLabel.isHidden = false
        } else {
           messageLabel.isHidden = true
        }
        cartTableView.reloadData()
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
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 170),
            label.heightAnchor.constraint(equalToConstant: 45),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        messageLabel = label
    }
    
    // MARK: Methods
    
    func setUpUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Cart"
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

// MARK: CartViewProtocol

extension CartViewController: CartViewProtocol {
    func handleError(error: CoreDataError) {
        showAlert(title: "Error", message: errorMessage(for: error))
    }
}

// MARK: TableViewProtocol

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.cartProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        if let cartProduct = presenter?.cartProducts?[indexPath.row] {
            cell.configure(cartProduct: cartProduct)
        }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cartProduct = presenter?.cartProducts?[indexPath.row] {
            presenter?.productSelected(cartProduct: cartProduct)
        }
    }
}

// MARK: CartTableViewCellDelegate

extension CartViewController: CartTableViewCellDelegate {
    func increaseButtonTapped(in cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell), let cartProduct = presenter?.cartProducts?[indexPath.row] {
            presenter?.productQuantityUpdated(product: cartProduct, quantity: Int(cartProduct.quantity) + 1 )
        }
    }
    
    func decreaseButtonTapped(in cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell), let cartProduct = presenter?.cartProducts?[indexPath.row], cartProduct.quantity > 0 {
            presenter?.productQuantityUpdated(product: cartProduct, quantity: Int(cartProduct.quantity) - 1)
        }
    }
}
