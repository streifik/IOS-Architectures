//
//  AppDelegate.swift
//  OnlineStore(MVVM+Boxing)
//
//  Created by Dmitry Telpov on 01.08.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        
       // tabBarController.viewControllers = [navigationController]
        
        appCoordinator = AppCoordinator(navigationController: navigationController, tabBarController: tabBarController)
        appCoordinator?.start()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

