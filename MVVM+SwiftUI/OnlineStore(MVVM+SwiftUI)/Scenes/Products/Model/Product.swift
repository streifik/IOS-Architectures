//
//  Product.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import Foundation

struct Product: Decodable, Identifiable {
    
    // MARK: - Variables And Properties
    
    var id: Int
    var title: String
    var price: Double
    var description: String
    var category: String
    var image: String
    var quantity: Int?
    
    static var sampleProduct = Product(id: 1, title: "Sample product", price: 12.2, description: "Sample description", category: "electronics", image: "sampleImage")
}



