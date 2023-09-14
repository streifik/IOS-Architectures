//
//  CartProduct+CoreDataProperties.swift
//  OnlineStoreVIPER
//
//  Created by Dmitry Telpov on 09.08.23.
//
//

import Foundation
import CoreData


extension CartProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<CartProduct>(entityName: "CartProduct")
    }

    @NSManaged public var about: String?
    @NSManaged public var category: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageStringURL: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int64
    @NSManaged public var title: String?

}

extension CartProduct : Identifiable {

}
