//
//  ProductRating+CoreDataProperties.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 05.04.23.
//
//

import Foundation
import CoreData


extension ProductRating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductRating> {
        return NSFetchRequest<ProductRating>(entityName: "ProductRating")
    }

    @NSManaged public var rate: Double
    @NSManaged public var count: Int64
    @NSManaged public var cartProduct: CartProduct?

}

extension ProductRating : Identifiable {

}
