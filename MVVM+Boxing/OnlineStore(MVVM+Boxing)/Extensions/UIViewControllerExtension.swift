//
//  UIViewControllerExtension.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 05.09.23.
//

import Foundation
import UIKit

extension UIViewController {
    func errorMessage(for error: ProductError) -> String {
        switch error {
        case .productNotFound:
            return "Product not found."
        case .networkError:
            return "Network error occurred while fetching data."
        }
    }
    func errorMessage(for error: ProductDetailError) -> String {
        switch error {
        case .cartProductNotFound:
            return "Cart product not found."
        case .coreDataError:
            return "An error occurred while fetching data."
        case .quantityEditingError:
            return "An error occurred while editing quantity."
        case .productNotFound:
            return "Product not found."
        }
    }
    
    func errorMessage(for error: CartError) -> String {
        switch error {
        case .cartProductNotFound:
            return "Cart product not found."
        case .quantityEditingError:
            return "An error occurred while editing quantity."
        case .coreDataError:
            return "An error occurred while fetching data."
            
        }
    }
    func showAlert() {
        showAlert(title: "Alert", message: "This is an example alert.", buttonTitle: "Got it") {
            print("User tapped OK")
        }
    }
    
    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
