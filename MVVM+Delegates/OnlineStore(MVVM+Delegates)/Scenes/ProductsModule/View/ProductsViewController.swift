//
//  ViewController.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import UIKit

class ProductsViewController: UIViewController {
    
    // MARK: Variables
    
    var viewModel = ProductsViewModel()
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
        viewModel.getProducts()
        viewModel.productViewModelDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Products"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    // MARK: Methods
    
    func setupUI() {
        title = "Products"
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
    
    func addMenuItems() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Electronics", handler: { action in
                self.selectedCategory = "Electronics"
                self.viewModel.getProductsyCategory(category: "electronics")
            }),
            UIAction(title: "Jewelery", handler: { action in
                self.selectedCategory = "Jewelery"
                self.viewModel.getProductsyCategory(category: "jewelery")
            }),
            UIAction(title: "Men's clothing", handler: { action in
                self.selectedCategory = "Men's clothing"
                self.viewModel.getProductsyCategory(category: "men's clothing")
            }),
            UIAction(title: "Women's clothing", handler: { action in
                self.selectedCategory = "Women's clothing"
                self.viewModel.getProductsyCategory(category: "women's clothing")
            })]
        )
        
        return menuItems
    }
}

// MARK: Extensions

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductsTableViewCell
        if let product = viewModel.products?[indexPath.row] {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.products?[indexPath.row]
        viewModel.productCellTapped(product: product)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
}


extension ProductsViewController: ProductViewModelDelegate {
    func updateProducts(products: [Product]?) {
       productsTableView.reloadData()
    }
    
    func handleError(error: ProductError) {
       showAlert(title: "Error", message: errorMessage(for: error))
    }
}
