//
//  ImageViewExtension.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import Foundation
import UIKit

extension UIImageView {
    private static var imageCache: [String: UIImage] = [:]
    
    public func imageFromURL(urlString: String) {
        self.image = nil
        
        // Check if the image is available in the cache
        if let cachedImage = UIImageView.imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let newImage = UIImage(data: data)
                
                UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.image = newImage
                }, completion: { _ in
                    // Save the downloaded image to the cache
                    UIImageView.imageCache[urlString] = newImage
                })
            }
        }.resume()
    }
}

