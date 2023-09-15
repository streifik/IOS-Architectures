//
//  ContentView.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import SwiftUI
struct ContentView: View {
    var body: some View {
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
            // correct the transparency bug for Tab bars
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            
            updateNavigationBarColor()
        }
    }
    func updateNavigationBarColor() {
        UINavigationBar.appearance().barTintColor = .secondarySystemBackground
        UINavigationBar.appearance().backgroundColor = .secondarySystemBackground
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
