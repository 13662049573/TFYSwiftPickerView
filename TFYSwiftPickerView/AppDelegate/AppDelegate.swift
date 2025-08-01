//
//  AppDelegate.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 设置导航栏样式
        setupNavigationBarAppearance()
        
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
    }
    
    // MARK: - Navigation Bar Setup
    private func setupNavigationBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = PickerColors.theme
            appearance.titleTextAttributes = [
                .foregroundColor: PickerColors.text,
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
            ]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = PickerColors.theme
            UINavigationBar.appearance().tintColor = PickerColors.text
            UINavigationBar.appearance().titleTextAttributes = [
                .foregroundColor: PickerColors.text,
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
            ]
        }
    }
}

