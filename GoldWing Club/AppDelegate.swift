//
//  AppDelegate.swift
//  GoldWing Club
//
//  Created by Noël Jaffré on 12/17/24.
//

import Foundation
import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import FirebaseAppCheck

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configuration de Firebase
        FirebaseApp.configure()

        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory()) // Use Debug provider during development

        // Set yellow color as default for Toolbar title in all the app
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(.yellow)]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.yellow)]
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance

        print("AppDelegate launched")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Gérez votre token APNs ici si nécessaire
        print("Device token: \(deviceToken)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    
}
