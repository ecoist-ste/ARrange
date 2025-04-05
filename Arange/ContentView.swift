//
//  ContentView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/4/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var isImmersive = false

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")
            
            Button(isImmersive ? "Close space" : "Open space") {
                Task {
                    if isImmersive {
                        await dismissImmersiveSpace()
                        isImmersive = false
                    } else {
                        await openImmersiveSpace(id: "demo")
                        isImmersive = true
                    }
                    
                }
            }
        }
        .padding()

    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
