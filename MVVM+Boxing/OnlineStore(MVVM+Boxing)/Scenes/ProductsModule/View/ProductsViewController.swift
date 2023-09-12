//
//  ViewController.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import UIKit

class ProductsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    
    var viewModel = ProductsViewModel()
    var headerButton: UIButton!
    var selectedCategory: String = "Select category"
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getProducts()
        bindViewModel()
        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Products"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    // MARK: Methods
    
    func bindViewModel() {
        viewModel.products.bind {[weak self] products in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.productsTableView.reloadData()
                self.hideActivityIndicator()
            }
        }
    }
    
    func getProducts() {
        showActivityIndicator()
        viewModel.getProducts {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.viewModel.products.value = products
            case .failure(let error):
                self.showAlert(title: "Error", message: self.errorMessage(for: error))
            }
            self.hideActivityIndicator()
        }
    }
 
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            // Hide the content rows
            for indexPath in self.productsTableView.indexPathsForVisibleRows ?? [] {
                if indexPath.row >= 0 {
                    let cell = self.productsTableView.cellForRow(at: indexPath)
                    cell?.isHidden = true
                }
            }
        }
    }
    
    func setUpUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        productsTableView.separatorStyle = .none
        productsTableView.sectionHeaderTopPadding = 0.0
        configureScrollEdgeAppearance()
        productsTableView.sectionFooterHeight = UITableView.automaticDimension
        productsTableView.estimatedSectionHeaderHeight = 44
        productsTableView.register(UINib(nibName: "ProductsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProductsHeaderView")
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func addMenuItems() -> UIMenu {
        let categories: [String] = [
            "Electronics",
            "Jewelery",
            "Men's clothing",
            "Women's clothing"
        ]
        
        let menuItems = UIMenu(title: "", options: .displayInline, children: categories.map { category in
            return UIAction(title: category, handler: { [weak self] action in
                guard let self = self else { return }
                self.selectedCategory = category
                self.viewModel.getProductsyCategory(category: category.lowercased())  { result in
                    switch result {
                    case .success(let products):
                        self.viewModel.products.value = products
                    case .failure:
                        self.showAlert(title: "Error", message: "An error occurred while fetching products.")
                    }
                }
                self.showActivityIndicator()
            })
        })
        
        return menuItems
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

// MARK: TableView protocol

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductsTableViewCell
        if let product = viewModel.products.value?[indexPath.row] {
            cell.configure(product: product)
        }

        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.products.value?[indexPath.row]
        viewModel.productCellTapped(product: product)
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
