//
//  CustomHeaderView.swift
//  OnlineStoreVIPER
//
//  Created by Dmitry Telpov on 31.08.23.
//


import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Properties
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let headerButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .trailing
        var configuration = UIButton.Configuration.plain()
        let imageSize: CGFloat = 12.5
        let image = UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: imageSize))
        
        configuration.image = image
        configuration.titlePadding = 10
        configuration.imagePadding = 5
        configuration.baseForegroundColor = .lightGray
        button.semanticContentAttribute = .forceRightToLeft
        button.configuration = configuration
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
     
        setUpUI()
        setUpConstrints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setUpUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(containerView)
        containerView.addSubview(headerButton)
    }
    
    func setUpConstrints() {
        // Container View
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
        
        // Header Button
        NSLayoutConstraint.activate([
            headerButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            headerButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            headerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            headerButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
           headerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
