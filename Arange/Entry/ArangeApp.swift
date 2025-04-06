//
//  ArangeApp.swift
//  Arange
//
//  Created by Songyuan Liu on 4/4/25.
//

import SwiftUI

@main
struct ArangeApp: App {

    #if os(visionOS)
    @StateObject private var sphereController = SphereController()
    @StateObject private var appState = AppState()
    @StateObject private var furnitureViewModel = FurnitureViewModel()
    #endif

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
        
        ImmersiveSpace(id: "PreviewFurniture") {
            FurniturePlacementView()
                .environmentObject(appState)
                
        }
        #endif

     }
}
