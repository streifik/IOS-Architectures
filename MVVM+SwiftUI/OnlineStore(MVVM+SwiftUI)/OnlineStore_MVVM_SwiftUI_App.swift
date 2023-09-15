//
//  OnlineStore_MVVM_SwiftUI_App.swift
//  OnlineStore(MVVM+SwiftUI)
//
//  Created by Dmitry Telpov on 28.03.23.
//

import SwiftUI

@main
struct OnlineStore_MVVM_SwiftUI_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
