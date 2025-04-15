#if os(visionOS)
import SwiftUI
import RealityKit
import SceneKit
import Combine

struct ImmersiveSphereView: View {
    @EnvironmentObject var viewModel: ImmersiveSphereViewModel
    @EnvironmentObject var pinManager: PinManager
    @EnvironmentObject var appState: AppState
    
    // Use radius 3.0 for the sphere
    let sphereRadius: Float = 10.0

    @State private var redPinPosition: SIMD3<Float> = simd_normalize(SIMD3<Float>(0, 1.5, -2)) * 10.0
    @State private var initialPinPosition: SIMD3<Float> = simd_normalize(SIMD3<Float>(0, 1.5, -2)) * 10.0
    
    @State private var redPinCommentText: String = "Double tap to leave a remark"
    @State private var isEditingRedPinComment: Bool = false
    
    let rotationSpeed: Float = 0.00005
    
    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(world: .zero)
            
            // Use radius 3.0 for the skybox
            if let skybox = createSkybox(using: appState.immersiveViewTextureImagePath, sphereRadius: sphereRadius) {
                anchor.addChild(skybox)
                content.add(anchor)
            }
            
            
        } update: { content in
            guard let anchor = content.entities.first(where: { $0 is AnchorEntity }) as? AnchorEntity else { return }

                for pin in pinManager.pins {
                    let entityName = "pin_\(pin.id.uuidString)"
                    if anchor.findEntity(named: entityName) == nil {
                        let pinEntity = createPinEntity(with: pin.comment)
                        pinEntity.name = "pinContainer" // 👈 allows dragging
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
            TapGesture(count: 2)
                .targetedToAnyEntity()
                .onEnded { value in
                    if value.entity.name == "pinContainer" {
                        isEditingRedPinComment = true
                    }
                }
        )
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    if value.entity.name == "pinContainer" {
                        let dx = Float(value.translation.width)
                        let dy = Float(value.translation.height)

                        let dragX = log(abs(dx) + 1) * 0.001 * (dx < 0 ? -1 : 1)
                        let dragY = log(abs(dy) + 1) * 0.001 * (dy < 0 ? -1 : 1)

                        let angleY = -dragX
                        let angleX = -dragY
                        var pos = value.entity.position
                        
                        let rotationY = simd_quatf(angle: angleY, axis: SIMD3<Float>(0, 1, 0))
                        pos = rotationY.act(pos)
                        
                        let right = simd_normalize(simd_cross(pos, SIMD3<Float>(0, 1, 0)))
                        let rotationX = simd_quatf(angle: angleX, axis: right)
                        pos = rotationX.act(pos)
                        
                        // Constrain to surface of radius 3.0
                        pos = simd_normalize(pos) * (sphereRadius - 1.0)
                        
                        
                        value.entity.position = pos
                    }
                }
                .onEnded { value in
                    let deltaX = Float(value.translation.width)
                    let deltaY = Float(value.translation.height)
                    let angleY = -deltaX * rotationSpeed
                    let angleX = -deltaY * rotationSpeed
                    
                    var pos = value.entity.position
                    let rotationY = simd_quatf(angle: angleY, axis: SIMD3<Float>(0, 1, 0))
                    pos = rotationY.act(pos)
                    let right = simd_normalize(simd_cross(pos, SIMD3<Float>(0, 1, 0)))
                    let rotationX = simd_quatf(angle: angleX, axis: right)
                    pos = rotationX.act(pos)
                    
                    pos = simd_normalize(pos) * sphereRadius
                    
                    redPinPosition = pos
                    initialPinPosition = pos
                }
        )
        
        .sheet(isPresented: $isEditingRedPinComment) {
            VStack(spacing: 20) {
                Text("Edit Comment")
                    .font(.title2)
                    .padding(.top)
                TextField("Enter comment", text: $redPinCommentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button("Done") {
                    isEditingRedPinComment = false
                }
                .padding(.bottom)
            }
            .padding()
        }
    }
    
    func createSkybox(using imagePath: String = "demo3", sphereRadius: Float) -> Entity? {
        let sphereMesh = MeshResource.generateSphere(radius: sphereRadius)
        var material = UnlitMaterial()
        
        guard let texture = try? TextureResource.load(named: imagePath) else {
            print("Failed to load texture from the main bundle")
            return nil
        }
        
        material.color = .init(texture: .init(texture))
        let skybox = ModelEntity(mesh: sphereMesh, materials: [material])
        skybox.scale = SIMD3<Float>(-1, 1, 1) // flip for interior view
        skybox.transform.translation.y = 0
        return skybox
    }
    
    func createPinEntity(with comment: String) -> Entity {
        let pin = ModelEntity(
            mesh: MeshResource.generateSphere(radius: 0.1), // larger for scale
            materials: [SimpleMaterial(color: .red, isMetallic: false)]
        )
        pin.name = "pin"
        
        let textMesh = MeshResource.generateText(
            comment,
            extrusionDepth: 0.01,
            font: .italicSystemFont(ofSize: 0.1),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byWordWrapping
        )
        
        let textMaterial = SimpleMaterial(color: .red, isMetallic: false)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.name = "text"
        textEntity.position = SIMD3<Float>(0.2, 0.2, 0)
        textEntity.components.set(BillboardComponent())
        
        let container = AnchorEntity()
        container.name = "pinContainer"
        container.addChild(pin)
        container.addChild(textEntity)
        container.components.set(InputTargetComponent())
        container.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: [1, 1, 1])]))
        
        return container
    }
}

#Preview {
    ImmersiveSphereView()
        .environmentObject(ImmersiveSphereViewModel())
        .environmentObject(PinManager())
        .environmentObject(AppState())
}
#endif
