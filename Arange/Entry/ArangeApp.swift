//
//  ArangeApp.swift
//  Arange
//
//  Created by Songyuan Liu on 4/4/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ArangeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    #if os(visionOS)
    @State private var sphereController = SphereController()
    #endif

    var body: some Scene {
        #if os(iOS)
        WindowGroup {
            LandingView()
        }
        #else
        WindowGroup {
            ContentView()
                .environmentObject(sphereController)
        }
        
        WindowGroup(id: "ImmersiveController") {
            ImmersiveControllerView()
                .environmentObject(sphereController)
        }
        .defaultSize(CGSize(width: 400, height: 600))
                    
        
        ImmersiveSpace(id: "demo") {
            ImmersiveSphereView()
                .environmentObject(sphereController)
        }
        #endif

     }
}
