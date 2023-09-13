//
//  CoreDataService.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 02.08.23.
//


import Foundation
import CoreData
import UIKit

class CoreDataService {
    
    typealias CoreDataResult<T> = (Result<T, CoreDataError>) -> Void
    
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
    
    func saveContext(completion: CoreDataResult<Void>? = nil) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion?(.success(()))
            } catch {
                completion?(.failure(.coreDataError))
            }
        } else {
            completion?(.success(()))
        }
    }
    
    func deleteProductFromCart(product: CartProduct, completion: CoreDataResult<Void>? = nil) {
        let context = persistentContainer.viewContext
        context.delete(product)
        
        saveContext(completion: completion)
    }
    
    func addProduct(id: Int, about: String, title: String, category: String, price: Double, quantity: Int, imageStringURL: String, completion: @escaping CoreDataResult<CartProduct?>) {
        let context = persistentContainer.viewContext
        guard let product = NSEntityDescription.insertNewObject(forEntityName: "CartProduct", into: context) as? CartProduct else {
            completion(.failure(.coreDataError))
            return
        }
        
        product.id = Int64(id)
        product.about = about
        product.title = title
        product.category = category
        product.price = price
        product.quantity = Int64(quantity)
        product.imageStringURL = imageStringURL
        
        saveContext { result in
            switch result {
            case .success:
                completion(.success(product))
            case .failure:
                completion(.failure(.coreDataError))
            }
        }
    }
    
    func fetchProductsData(completion: @escaping CoreDataResult<[CartProduct]>) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            let products = try context.fetch(fetchRequest)
            completion(.success(products))
        } catch {
            completion(.failure(.coreDataError))
        }
    }
    
    func fetchProduct(id: Int, completion: @escaping CoreDataResult<CartProduct?>) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            let products = try context.fetch(fetchRequest)
            if products.first == nil {
                completion(.failure(.cartProductNotFound))
            } else {
                completion(.success(products.first))
            }
        } catch {
            completion(.failure(.coreDataError))
        }
    }
}


