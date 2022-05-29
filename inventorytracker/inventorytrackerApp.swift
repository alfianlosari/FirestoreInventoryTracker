//
//  inventorytrackerApp.swift
//  inventorytracker
//
//  Created by Alfian Losari on 29/05/22.
//

import Firebase
import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let settings = Firestore.firestore().settings
//        #if targetEnvironment(simulator)
//        settings.host = "localhost:9000"
//        settings.isPersistenceEnabled = false
//        settings.isSSLEnabled = false
//        #endif
        Firestore.firestore().settings = settings
        return true
    }
    
}

@main
struct inventorytrackerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
