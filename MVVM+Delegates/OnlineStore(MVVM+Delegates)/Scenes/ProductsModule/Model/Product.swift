//
//  Product.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
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

extension Product {
    func toCartProduct() -> CartProduct {
        let cartProduct = CartProduct(context: CoreDataService.shared.persistentContainer.viewContext)
        cartProduct.id = Int64(self.id)
        cartProduct.title = self.title
        cartProduct.price = self.price
        cartProduct.about = self.description
        cartProduct.category = self.category
        cartProduct.imageStringURL = self.image
        cartProduct.quantity = Int64(self.quantity ?? 0) 
        return cartProduct
    }
}
