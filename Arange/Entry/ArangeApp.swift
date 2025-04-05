//
//  ArangeApp.swift
//  Arange
//
//  Created by Songyuan Liu on 4/4/25.
//

import SwiftUI

@main
struct ArangeApp: App {

    @State private var sphereController = SphereController()

    var body: some Scene {
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

     }
}
