#if os(visionOS)
import SwiftUI
import RealityKit
import Combine

import SwiftUI
import RealityKit


struct ImmersiveSphereView: View {
    @EnvironmentObject var viewModel: ImmersiveSphereViewModel
    @EnvironmentObject var pinManager: PinManager
    
    func createSkybox(using imagePath: String = "demo3", sphereRadius: Float) -> Entity? {
        let sphereMesh = MeshResource.generateSphere(radius: sphereRadius)
        var material = UnlitMaterial()
        
        guard let texture = try? TextureResource.load(named: imagePath) else {
            print("Failed to load texture from the main bundle")
            return nil
        }
        
        material.color = .init(texture: .init(texture))
        
        let skybox = ModelEntity(mesh: sphereMesh, materials: [material])
        skybox.scale = SIMD3<Float>(-1, 1, 1)
        skybox.transform.translation.y = 1.73
        
        return skybox
        
    }
    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(world: .zero)
            if let skybox = createSkybox(sphereRadius: 1000.0) {
                anchor.addChild(skybox)
                content.add(anchor)
            }
            
            for pin in pinManager.pins {
                let entity = createPinEntity(with: pin.comment)
                entity.position = pin.position
                anchor.addChild(entity)
            }
            
        } update: { content in
            if let anchor = content.entities.first(where: { $0 is AnchorEntity }) as? AnchorEntity {
                    for child in anchor.children {
                        if child.name.hasPrefix("pin_") {
                            anchor.removeChild(child)
                        }
                    }

                    for pin in pinManager.pins {
                        let pinEntity = createPinEntity(with: pin.comment)
                        pinEntity.position = pin.position
                        anchor.addChild(pinEntity)
                    }
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
        .gesture(
            RemovePinGesture
        )
        
        
        .animation(.easeInOut, value: viewModel.isTapped)
    }
    
    private var RemovePinGesture: some Gesture {
        SpatialTapGesture(count: 3)
            .targetedToAnyEntity()
            .onEnded { value in
                let tappedEntity = value.entity
                guard tappedEntity.name == "pin" || tappedEntity.name == "pinContainer" else { return }

                if let container = tappedEntity.findEntity(named: "pinContainer") ?? tappedEntity.parent {
                    container.removeFromParent()
                    
                    // Optional: sync with model
                    if let index = pinManager.pins.firstIndex(where: {
                        distance($0.position, container.transform.translation) < 0.01
                    }) {
                        pinManager.pins.remove(at: index)
                    }
                }
            }
    }

    
    func createPinEntity(with comment: String) -> Entity {
        let pin = ModelEntity(
            mesh: MeshResource.generateSphere(radius: 0.05),
            materials: [SimpleMaterial(color: .red, isMetallic: false)]
        )
        pin.name = "pin"

        // Text mesh
        let textMesh = MeshResource.generateText(
            comment,
            extrusionDepth: 0.01,
            font: .systemFont(ofSize: 0.1),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byWordWrapping
        )

        let textMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.position = SIMD3<Float>(0.1, 0.1, 0) // Offset from pin

        // Billboard effect to face camera
        textEntity.orientation = simd_quatf(angle: 0, axis: [0, 1, 0])
        textEntity.components.set(BillboardComponent())

        let container = Entity()
        container.name = "pinContainer"
        container.addChild(pin)
        container.addChild(textEntity)
        
        pin.components.set(InputTargetComponent())
        textEntity.components.set(InputTargetComponent())
        
        let collisionComponent = CollisionComponent(shapes: [ShapeResource.generateBox(width: 2.0, height: 2.0, depth: 0.02)])
        pin.components.set(collisionComponent)
        textEntity.components.set(collisionComponent)
        
        return container
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
        .environmentObject(ImmersiveSphereViewModel())
        .environmentObject(PinManager())
}

#endif
