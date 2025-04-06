//
//  ImmersiveView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/4/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @EnvironmentObject var furnitureModel: ViewModel
    @State private var showLibrary = false

    var body: some View {
        //        RealityView { content in
        //            for item in furnitureModel.items {
        //                if let entity = try? await Entity(named: item.name, in: realityKitContentBundle) {
        //                    entity.position = item.position
        //                    entity.orientation = item.orientation
        //
        //                    let anchor = AnchorEntity(world: .zero)
        //                    anchor.addChild(entity)
        //                    content.add(anchor)
        //                }
        //            }
        //    }
        
        RealityView { content in
            let mesh = MeshResource.generateBox(size: 0.001)
            let material = SimpleMaterial(color: .blue, isMetallic: false)
            let box = ModelEntity(mesh: mesh, materials: [material])
            
            let anchor = AnchorEntity(.head) // Stays relative to user's head
            box.position = SIMD3<Float>(0.2, -0.2, -0.5) // Half a meter in front
            anchor.addChild(box)

            content.add(anchor)
        }
//        .gesture(TapGesture()
//            .targetedToAnyEntity()
//            .onEnded({ _ in
//                WindowGroup {
//                    FurnitureLibraryView().environmentObject(furnitureModel)
//                }
//            }))
        
    }
}

#Preview(immersionStyle: .mixed, traits:.sizeThatFitsLayout) {
    ImmersiveView()
        .environmentObject(ViewModel())
}
