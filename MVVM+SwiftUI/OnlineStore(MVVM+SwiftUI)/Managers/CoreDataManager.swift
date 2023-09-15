//
//  CoreDataManager.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 29.03.23.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    
    static let shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CartModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: Add product
    
    func addProduct(product: Product, quantity: Int) -> CartProduct? {
        let context = persistentContainer.viewContext
        
        if let cartProduct = NSEntityDescription.insertNewObject(forEntityName: "CartProduct", into: context) as? CartProduct {
            cartProduct.id = Int64(product.id)
            cartProduct.about = product.description
            cartProduct.title = product.title
            cartProduct.category = product.category
            cartProduct.price = product.price
            cartProduct.image = product.image
            cartProduct.quantity = Int64(quantity)
        
            do {
                try context.save()
            } catch {
                print("Error with context save")
            }
            return cartProduct
        }
        return nil
    }
    
    // MARK: Fetch All Products
    
    func fetchProductsData() -> [CartProduct]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartProduct")
        do {
            let results = try context.fetch(fetchRequest)
            print(results.count)
            if let products = results as? [CartProduct] {
                return products
            }
        } catch {
            print("error")
        }
        return nil
    }
    
    // MARK: Fetch product by id
    
    func fetchProduct(id: Int) -> CartProduct? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %i" ,id)
        let results = try! context.fetch(fetchRequest)
        if let products = results as? [CartProduct] {
            return products.first
        }
        return nil
    }
    
    // MARK: - Delete object
    
    func deleteProductFromCart(product: CartProduct) -> Bool {
        let context = persistentContainer.viewContext
        context.delete(product)

        do {
            try context.save()
            return true
        } catch {
            print("Error deleting product from cart: \(error)")
            return false
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
