//
//  EndPoint.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 11.04.23.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "fakestoreapi.com"
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    var headers: [String: Any] {
         return [
             "app-id": "YOUR APP ID HERE"
         ]
     }
}

extension Endpoint {
    static func products() -> Self {
        return Endpoint(path: "/products")
    }
    
    static func productsByCategory(category: String) -> Self {
        print()
        return Endpoint(path: "/products/category/\(category)")
    }
}


