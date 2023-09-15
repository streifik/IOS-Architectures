//
//  File.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 01.09.23.
//

import SwiftUI

extension Color {
    
    static let startColor = Color(red: 197/255.0, green: 140/255.0, blue: 197/255.0, opacity: 1)
    
    static let secondColor = Color(red: 123/255.0, green: 198/255.0, blue: 204/255.0, opacity: 1)
    
    static let gradientBackgroundColor = LinearGradient(gradient: Gradient(colors: [.startColor, .secondColor]), startPoint: .leading, endPoint: .trailing)
}
