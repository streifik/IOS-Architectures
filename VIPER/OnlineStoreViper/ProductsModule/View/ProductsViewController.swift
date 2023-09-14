//
//  ProductsViewController.swift
//  Super easy dev
//
//  Created by Dmitry Telpov on 08.08.23
//

import UIKit
import Foundation

// MARK: Protocols

protocol ProductsViewProtocol: AnyObject {
    func fillTableView(products: [Product]?)
    func handleError(error: ProductError)
}

class ProductsViewController: UIViewController {

    // MARK: Variables
    
    var presenter: ProductsPresenterProtocol?
    var headerButton: UIButton!
    var selectedCategory: String = "Select category"
    
    let productsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupUI()
        setUpConstraints()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Products"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false 
    }
    
    // MARK: Methods
    
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .secondarySystemBackground
        productsTableView.register(ProductsTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        productsTableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "customHeader")
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.backgroundColor = .secondarySystemBackground
        productsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productsTableView)
        productsTableView.separatorStyle = .none
        productsTableView.sectionHeaderTopPadding = 0.0
    }
    
    func setUpConstraints() {
        productsTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        productsTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        productsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    func initialize() {
        presenter?.viewLoaded()
    }
    
    func addMenuItems() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Electronics", handler: { action in
                self.selectedCategory = "Electronics"
                self.presenter?.categorySelected(category: "electronics")
            }),
            UIAction(title: "Jewelery", handler: { action in
                self.selectedCategory = "Jewelery"
                self.presenter?.categorySelected(category: "jewelery")
            }),
            UIAction(title: "Men's clothing", handler: { action in
                self.selectedCategory = "Men's clothing"
                self.presenter?.categorySelected(category: "men's clothing")
            }),
            UIAction(title: "Women's clothing", handler: { action in
                self.selectedCategory = "Women's clothing"
                self.presenter?.categorySelected(category: "women's clothing")
            })]
        )
        return menuItems
    }
}

// MARK: ProductsViewProtocol

extension ProductsViewController: ProductsViewProtocol {
    func handleError(error: ProductError) {
        showAlert(title: "Error", message: errorMessage(for: error))
    }
    
    func fillTableView(products: [Product]?) {
        productsTableView.reloadData()
    }
    
}
// MARK: TableViewProtocol

extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.products?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductsTableViewCell
        if let product = presenter?.products?[indexPath.row] {
            cell.configure(product: product)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeader") as? CustomHeaderView
        headerView?.headerButton.setTitle(selectedCategory, for: .normal)
        headerView?.headerButton.showsMenuAsPrimaryAction = true
        headerView?.headerButton.menu = addMenuItems()
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let product = presenter?.products?[indexPath.row] {
            presenter?.productSelected(product: product)
        }
    }
}
