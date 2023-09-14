//
//  Product.swift
//  OnlineStoreVIPER
//
//  Created by Dmitry Telpov on 09.08.23.
//

import Foundation

struct Product: Decodable, Encodable {
    
    // MARK: - Variables And Properties
    
    var id: Int
    var title: String
    var price: Double
    var description: String
    var category: String
    var image: String
    var quantity: Int?
}
