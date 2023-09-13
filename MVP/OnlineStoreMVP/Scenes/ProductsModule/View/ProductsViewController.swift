//
//  ProductsViewController.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 21.07.23.
//

import UIKit

class ProductsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var productsTableView: UITableView!
    
    // MARK: Variables
    
    var presenter: ProductsPresenterProtocol!
    var headerButton: UIButton!
    var testLabel = UILabel()
    var selectedCategory: String = "Select category"
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsTableView.separatorStyle = .none
        navigationController?.navigationBar.prefersLargeTitles = true
        productsTableView.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        productsTableView.register(UINib(nibName: "ProductsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProductsHeaderView")
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
    
    func addMenuItems() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Electronics", handler: { action in
                self.selectedCategory = "Electronics"
                self.presenter.getProductsyCategory(category: "electronics")
            }),
            UIAction(title: "Jewelery", handler: { action in
                self.selectedCategory = "Jewelery"
                self.presenter.getProductsyCategory(category: "jewelery")
            }),
            UIAction(title: "Men's clothing", handler: { action in
                self.selectedCategory = "Men's clothing"
                self.presenter.getProductsyCategory(category: "men's clothing")
            }),
            UIAction(title: "Women's clothing", handler: { action in
                self.selectedCategory = "Women's clothing"
                self.presenter.getProductsyCategory(category: "women's clothing")
            })]
        )
        
        return menuItems
    }
}

// MARK: Extensions

extension ProductsViewController: ProductsViewProtocol {
    func sucess() {
        productsTableView.reloadData()
    }
    
    func failure(error: ProductError) {
        showAlert(title: "Error", message: errorMessage(for: error))
    }
}
extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductsTableViewCell
        if let product = presenter.products?[indexPath.row] {
            cell.configure(product: product)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = presenter.products?[indexPath.row]
        presenter.productCellTapped(product: product)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductsHeaderView") as? ProductsHeaderView
        
        headerView?.selectCategoryButton.setTitle(selectedCategory, for: .normal)
        headerView?.selectCategoryButton.showsMenuAsPrimaryAction = true
        headerView?.selectCategoryButton.menu = addMenuItems()
        headerView?.containerView.layer.cornerRadius =  10
        headerView?.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
}

extension ProductsViewController: ProductsHeaderViewDelegate {
    func headerViewDidTapButton(headerView: ProductsHeaderView) {
        headerView.selectCategoryButton.menu = addMenuItems()
        headerView.selectCategoryButton.showsMenuAsPrimaryAction = true
    }
}
