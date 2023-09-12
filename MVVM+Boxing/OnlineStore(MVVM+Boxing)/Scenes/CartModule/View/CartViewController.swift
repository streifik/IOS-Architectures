//
//  CartViewController.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 02.08.23.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: Variables
    
    var viewModel = CartViewModel()
    weak var delegate: CartTableViewCellDelegate?
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getCartProducts()
        bindViewModel()
        navigationItem.title = "Cart"
   
        switch viewModel.cartProducts.value {
        case .success(let products):
            self.messageLabel.isHidden = products != nil && products?.count != 0
        case .failure:
            self.messageLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        setupUI()
        configureScrollEdgeAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    // MARK: Methods
    
    func bindViewModel() {
        viewModel.cartProducts.bind {[weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.cartTableView.reloadData()
                    self.messageLabel.isHidden = !(products?.isEmpty ?? true)
                case .failure(let error):
                    self.showAlert(title: "Error", message: self.errorMessage(for: error))
                }
                self.cartTableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Cart"
        cartTableView.separatorStyle = .none
        messageLabel.clipsToBounds = true
        messageLabel.layer.cornerRadius = 10
    }
    
    func configureScrollEdgeAppearance() {
        if #available(iOS 15, *) {
            guard let navigationBar = navigationController?.navigationBar else { return }
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.secondarySystemBackground
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
    }
}

// MARK: TableView protocool

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.cartProducts.value {
        case .success(let products):
            return products?.count ?? 0
        case .failure:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        if case .success(let products) = viewModel.cartProducts.value, let cartProduct = products?[indexPath.row] {
            cell.configure(cartProduct: cartProduct)
        }
        cell.delegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .success(let products) = viewModel.cartProducts.value {
            let cartProduct = products?[indexPath.row]
            viewModel.productCellTapped(cartProduct: cartProduct)
        }
    }
}

// MARK: CartTableViewCell delegate

extension CartViewController: CartTableViewCellDelegate {
    func increaseButtonTapped(in cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        
        if case .success(let products) = viewModel.cartProducts.value,
           let cartProduct = products?[indexPath.row] {
            let newQuantity = Int(cartProduct.quantity) + 1
            editProductQuantityAndReload(product: cartProduct, newQuantity: newQuantity)
        }
    }
    
    func decreaseButtonTapped(in cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        
        if case .success(let products) = viewModel.cartProducts.value,
           let cartProduct = products?[indexPath.row],
           cartProduct.quantity > 0 {
            let newQuantity = Int(cartProduct.quantity) - 1
            editProductQuantityAndReload(product: cartProduct, newQuantity: newQuantity)
        }
    }
    
    private func editProductQuantityAndReload(product: CartProduct, newQuantity: Int) {
        viewModel.editProductQuantity(product: product, quantity: newQuantity)
    }
}
