//
//  FurniturePlacementView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct FurniturePlacementView: View {
    
    let entityNamePath: String = "Coffeetable"
    @State private var enlarge = false
    @State private var dragOffset: SIMD3<Float> = .zero
    @State private var furniturePosition: SIMD3<Float> = SIMD3<Float>(0, 0, -1.5)
    @State private var isLocked = true
    
    var body: some View {
        RealityView { content, attachments in
            if let entity = try? await Entity(named: entityNamePath, in: realityKitContentBundle) {
                entity.components.set(CollisionComponent(shapes: [.generateBox(size: [1, 1, 1])]))
                entity.components.set(InputTargetComponent(allowedInputTypes: .all))
                content.add(entity)
                entity.position = SIMD3<Float>(0, 0, -1.5)
                print("scene's position: ", entity.position)
                
                if let lock = attachments.entity(for: "lock") {
                    
                    lock.position = entity.position
                    lock.position.y += 0.5
                    lock.position.z += 1
                
                    entity.addChild(lock)
                    
                    print("label's position: ", lock.position)
                }
            }
        } update: { content, attachments in
            if let scene = content.entities.first, !isLocked {
                scene.position = self.furniturePosition + self.dragOffset
//                print("scene's position: ", scene.position)
            }
        } attachments: {
            Attachment(id: "lock") {
                Button {
                    isLocked.toggle()
                } label: {
                    Text(self.isLocked ? "Unlock" : "lock")
                        .padding(20)
                        .font(.extraLargeTitle)
                        .glassBackgroundEffect()
                }
                .buttonStyle(.borderedProminent)
                .frame(alignment: .top)
            }
        }
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged{ value in
                    dragOffset.x = Float(value.translation.width) * 0.001
                    dragOffset.z = Float(value.translation.height) * 0.001

                }
                .onEnded { value in
                    furniturePosition += dragOffset
                    dragOffset = .zero
                }
        )
    }
}

#Preview(immersionStyle: .mixed) {
    FurniturePlacementView()
        .environment(AppState())
}
