//
//  CoreDataManager.swift
//  OnlineStoreMVP
//
//  Created by Dmitry Telpov on 26.07.23.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataServiceProtocol {
    
    var persistentContainer: NSPersistentContainer { get set}
    
    func addProduct(id: Int, about: String, title: String, category: String, price: Double, quantity: Int, imageStringURL: String) -> CartProduct?
    func fetchProductsData() -> [CartProduct]?
    func fetchProduct(id: Int) -> CartProduct?
    func deleteProductFromCart(product: CartProduct)
    func saveContext ()
    
}

class CoreDataService: CoreDataServiceProtocol {
    
    static let shared = CoreDataService()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CartProduct")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: Add product
    
    func addProduct(id: Int, about: String, title: String, category: String, price: Double, quantity: Int, imageStringURL: String) -> CartProduct? {
        let context = persistentContainer.viewContext
        if let product = NSEntityDescription.insertNewObject(forEntityName: "CartProduct", into: context) as? CartProduct {
            product.id = Int64(id)
            product.about = about
            product.title = title
            product.category = category
            product.price = price
            product.quantity = Int64(quantity)
            product.imageStringURL = imageStringURL
            
            do {
                try context.save()
            } catch {
                print("Error with context save")
            }
            return product
        }
        return nil
    }
    
    // MARK: Fetch All Products
    
    func fetchProductsData() -> [CartProduct]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartProduct")
        do {
            let results = try context.fetch(fetchRequest)
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
    
    func deleteProductFromCart(product: CartProduct){
        let context = persistentContainer.viewContext
        context.delete(product)

        do {
            try context.save()
        } catch {
            print("error")
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
