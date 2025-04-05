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
