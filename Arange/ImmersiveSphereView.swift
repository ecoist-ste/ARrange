import SwiftUI
import RealityKit
import Combine

struct ImmersiveSphereView: View {
    @State private var rotationEnabled: Bool = true
    // Keep a dummy state that gets updated each frame to force the view to refresh.
    @State private var totalTime: Float = 0.0
    @State private var pivot: Entity? = nil
    @State private var lastUpdateTime: Date = Date()
    @State private var lastDelta: Float = 1.0 / 60.0
    @State private var timerSubscription: Cancellable? = nil

    private var skyboxes: [Entity?] = []
    private let rotationSpeed: Float = .pi / 25

    init() {
        skyboxes = createAnArrayOfSkyboxes().compactMap { $0 }
    }

    var body: some View {
        ZStack {
            RealityView { content in
                let anchor = AnchorEntity(world: .zero)
                let localPivot = Entity()

                for skybox in skyboxes {
                    if let sphere = skybox {
                        sphere.components.set(InputTargetComponent(allowedInputTypes: .all))
                        sphere.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.2)]))
                        localPivot.addChild(sphere)
                    }
                }

                anchor.addChild(localPivot)
                content.add(anchor)
                pivot = localPivot

            } update: { content in
                if let pivot = pivot, rotationEnabled {
                    let deltaRotation = simd_quatf(
                        angle: rotationSpeed * lastDelta,
                        axis: SIMD3(0, 1, 0)
                    )
                    pivot.orientation = deltaRotation * pivot.orientation
                }
                print("rotationEnabled: \(rotationEnabled)")
            }
            .gesture(
                SpatialTapGesture()
                    .targetedToAnyEntity()
                    .onEnded({ _ in
                        print("Rotation enabled is falsed because it's tapped")
                        timerSubscription?.cancel()
                        timerSubscription = nil
                        rotationEnabled = false
                    })
            )
            
            // Hidden view to force SwiftUI to update every frame.
            Text("\(totalTime)")
                .opacity(0)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timerSubscription?.cancel()
        }
    }

    private func startTimer() {
        timerSubscription = Timer.publish(every: 1.0/60.0, on: .main, in: .common)
            .autoconnect()
            .sink { now in
                let dt = Float(now.timeIntervalSince(lastUpdateTime))
                lastUpdateTime = now
                lastDelta = dt
                totalTime += dt  // Update dummy variable to force view refresh.
            }
    }
}

extension ImmersiveSphereView {
    private func createAnArrayOfSkyboxes(count: Int = 20) -> [Entity?] {
        var arr: [Entity?] = []
        let circleRadius: Float = 2.0

        for i in 0..<count {
            guard let skybox = createSkybox() else { continue }
            let angle = 2 * Float.pi * Float(i) / Float(count)
            skybox.position.x = circleRadius * cos(angle)
            skybox.position.z = circleRadius * sin(angle)
            skybox.position.y = 2
            arr.append(skybox)
        }
        return arr
    }

    private func createSkybox(using imagePath: String = "demo") -> Entity? {
        let sphereMesh = MeshResource.generateSphere(radius: 0.2)
        var material = UnlitMaterial()
        do {
            let texture = try TextureResource.load(named: imagePath)
            material.color = .init(texture: .init(texture))
        } catch {
            return nil
        }
        let entity = Entity()
        entity.components.set(ModelComponent(mesh: sphereMesh, materials: [material]))
        entity.scale = .init(x: -1, y: 1, z: 1)
        entity.position = .init(x: 0, y: 2, z: -2)
        return entity
    }
}

#Preview {
    ImmersiveSphereView()
}
