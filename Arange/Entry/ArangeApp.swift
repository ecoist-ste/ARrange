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
    @StateObject private var pinManager = PinManager()
    @State private var immersionStyle: ImmersionStyle = .progressive
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
        .defaultSize(width: 1480, height: 800)
        
        WindowGroup(id: "ImmersiveController") {
            ImmersiveControllerView()
                .environmentObject(pinManager)
                .environmentObject(sphereController)
                .environmentObject(immersiveSphereViewModel)
        }
        .defaultSize(CGSize(width: 400, height: 600))
        
        ImmersiveSpace(id: "ImmersiveSphereView") {
            ImmersiveSphereView()
                .environmentObject(immersiveSphereViewModel)
                .environmentObject(pinManager)
                .environmentObject(appState)
                .preferredSurroundingsEffect(.dark)
        }
        .immersionStyle(selection: $immersionStyle, in: .progressive(0.3...1.0, initialAmount: 0.3))
        
        ImmersiveSpace(id: "PreviewFurniture") {
            FurniturePlacementView()
                .environmentObject(appState)
                
        }
        #endif

     }
}
