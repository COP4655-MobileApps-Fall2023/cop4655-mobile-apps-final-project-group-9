//
//  AppDelegate.swift
//  SeniorSignal
//
//  Created by Frederick DeBiase on 11/4/23.
//

import UIKit
import ParseSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize ParseSwift with your Back4App application ID and client key.
        ParseSwift.initialize(
            applicationId: "DA4wP3xPiK0UrXj0S5TyVwTNfflmUaw7wbWydeS1",
            clientKey: "ZrJFPv5IVtMU6UQXfQXPx6xY212qNFYCgPizSPYP",
            serverURL: URL(string: "https://parseapi.back4app.com")! 
        )
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

