//
//  ArangeApp.swift
//  Arange
//
//  Created by Songyuan Liu on 4/4/25.
//

import SwiftUI
import Firebase

@main
struct ArangeApp: App {

    #if os(visionOS)
    @StateObject private var sphereController = SphereController()
    @StateObject private var appState = AppState()
    @StateObject private var furnitureViewModel = FurnitureViewModel()
    @StateObject private var immersiveSphereViewModel = ImmersiveSphereViewModel()
    #endif
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        #if os(iOS)
        WindowGroup {
            LandingView()
        }
        
        #else
        WindowGroup {
            LaunchView()
                .environmentObject(sphereController)
                .environmentObject(appState)
                .environmentObject(furnitureViewModel)
                .environmentObject(immersiveSphereViewModel)
        }
        
        WindowGroup(id: "ImmersiveController") {
            ImmersiveControllerView()
                .environmentObject(sphereController)
                .environmentObject(immersiveSphereViewModel)
        }
        .defaultSize(CGSize(width: 400, height: 600))
        
        ImmersiveSpace(id: "ImmersiveSphereView") {
            ImmersiveSphereView()
                .environmentObject(sphereController)
        }
        
        ImmersiveSpace(id: "PreviewFurniture") {
            FurniturePlacementView()
                .environmentObject(appState)
                
        }
        #endif

     }
}
