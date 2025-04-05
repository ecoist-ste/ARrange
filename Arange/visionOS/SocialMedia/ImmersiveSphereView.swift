#if os(visionOS)
import SwiftUI
import RealityKit
import Combine

import SwiftUI
import RealityKit


struct ImmersiveSphereView: View {
    @EnvironmentObject var sphereController: SphereController
    @StateObject var viewModel = ImmersiveSphereViewModel()
    
    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(world: .zero)
            let pivot = Entity()
            anchor.addChild(pivot)
            content.add(anchor)
            
            // Add all spheres (created in the view model) to the pivot.
            for sphere in viewModel.spheres {
                pivot.addChild(sphere)
            }
            
            // Set the initial pivot rotation without animation.
            viewModel.updatePivotRotation(
                pivot: pivot,
                currentBatch: sphereController.currentBatch,
                animated: false
            )
            
        } update: { content in
            if let anchor = content.entities.first(where: { $0 is AnchorEntity }) as? AnchorEntity,
               let pivot = anchor.children.first {
                // Animate the pivot rotation based on the current batch.
                viewModel.updatePivotRotation(
                    pivot: pivot,
                    currentBatch: sphereController.currentBatch,
                    animated: true
                )
            }
        } placeholder: {
            ProgressView("Loading…")
                .scaleEffect(5)
                .font(.system(size: 8))
        }
        .gesture(
            MoveSphereGesture
        )
        .gesture(
            EnlargeSphereGesture
        )

        
        .animation(.easeInOut, value: viewModel.isTapped)
    }
    
    private var EnlargeSphereGesture: some Gesture {
        SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                viewModel.isTapped.toggle()
                if viewModel.isTapped {
                    value.entity.transform.scale *= 1.2
                    
                } else {
                    value.entity.transform.scale = SIMD3<Float>(1, 1, 1)
                }
            }
    }
    
    private var MoveSphereGesture: some Gesture {
        SpatialTapGesture(count: 2)
            .targetedToAnyEntity()
            .onEnded { value in
                viewModel.isDoubleTapped.toggle()
                if viewModel.isDoubleTapped {
                    let currentTransform = value.entity.transform
                    viewModel.originalPos = currentTransform.translation
                    var newTransform = currentTransform
                    newTransform.translation = SIMD3<Float>(0, 1.5, -0.5)
                    value.entity.move(
                        to: newTransform,
                        relativeTo: value.entity.parent,
                        duration: 1.5,
                        timingFunction: .easeInOut
                    )
                } else {
                    let currentTransform = value.entity.transform

                    var newTransform = currentTransform
                    newTransform.translation = viewModel.originalPos
                    value.entity.move(
                        to: newTransform,
                        relativeTo: value.entity.parent,
                        duration: 1.5,
                        timingFunction: .easeInOut
                    )
                }
                
            }
    }
}

#Preview {
    ImmersiveSphereView()
        .environmentObject(SphereController())
}

#endif
