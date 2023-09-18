//
//  ContentView.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import SwiftUI
struct ContentView: View {
    var body: some View {
        ZStack {
            Color.init(uiColor: .secondarySystemBackground)
            TabView {
                ProductsView()
                    .tabItem {
                        Label("Products", systemImage: "list.clipboard.fill")
                    }
                
                CartView()
                    .tabItem {
                        Label("Cart", systemImage: "cart")
                    }
            }
            .onAppear {
                correctTransparencyTabBarBug()
                updateNavigationBarColor()
            }
        }
    }
    
    func correctTransparencyTabBarBug() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .secondarySystemBackground
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    func updateNavigationBarColor() {
        UINavigationBar.appearance().barTintColor = .secondarySystemBackground
        UINavigationBar.appearance().backgroundColor = .clear
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
