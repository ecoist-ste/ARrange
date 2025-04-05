import SwiftUI
import RealityKit
import Combine

struct ImmersiveSphereView: View {
    // The current batch index (each batch contains 5 spheres)
    @State private var currentBatch: Int = 0
    
    private let totalSpheres: Int = 20
    private let spheresPerBatch: Int = 5
    
    // All created spheres are stored here.
    private var skyboxes: [Entity] = []
    
    init() {
        // Create all spheres during initialization.
        skyboxes = createAnArrayOfSkyboxes(count: totalSpheres).compactMap { $0 }
    }
    
    var body: some View {
        RealityView { content in
            // Anchor at the world origin (assume user/camera is near (0,0,0)).
            let anchor = AnchorEntity(world: .zero)
            let localPivot = Entity()
            
            // Determine the indices for the current batch of spheres.
            let startIndex = currentBatch * spheresPerBatch
            let endIndex = min(startIndex + spheresPerBatch, skyboxes.count)
            let currentSpheres = skyboxes[startIndex..<endIndex]
            
            // We want the user to be the center of the arc, facing them.
            // For each sphere, we place it on a concave arc in front of the user.
            let arcRadius: Float = 1.5
            let sphereHeight: Float = 1.7  // eye level
            let arcAngleRange = (-45.0).degreesToRadians ... (45.0).degreesToRadians
            let batchCount = currentSpheres.count
            
            for (i, sphere) in currentSpheres.enumerated() {
                // t is a normalized value [0..1] across the batch.
                let t = Float(i) / Float(max(batchCount - 1, 1))
                // Interpolate the angle from -45° to +45°.
                let angle = lerp(start: arcAngleRange.lowerBound, end: arcAngleRange.upperBound, t: t)
                
                // Position on a circle (center = user at origin):
                // x = r * sin(angle)
                // z = -r * cos(angle)  (negative so 0° is directly in front)
                let xOffset = arcRadius * sin(angle)
                let zOffset = -arcRadius * cos(angle)
                
                // Place the sphere at (x, y=1.5, z).
                sphere.position = SIMD3<Float>(xOffset, sphereHeight, zOffset)
                localPivot.addChild(sphere)
            }
            
            anchor.addChild(localPivot)
            content.add(anchor)
        }
    }
}

extension ImmersiveSphereView {
    /// Creates an array of skybox Entities.
    private func createAnArrayOfSkyboxes(count: Int = 20) -> [Entity?] {
        var arr: [Entity?] = []
        
        for _ in 0..<count {
            if let skybox = createSkybox() {
                arr.append(skybox)
            }
        }
        return arr
    }

    /// Loads a sphere with a texture (using the "demo" image by default).
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
        // Optionally flip the sphere by scaling X to -1.
        entity.scale = SIMD3<Float>(-1, 1, 1)
        return entity
    }
    
    /// A simple linear interpolation function.
    private func lerp(start: Float, end: Float, t: Float) -> Float {
        return start + (end - start) * t
    }
}

extension Double {
    /// Converts degrees to radians.
    var degreesToRadians: Float { Float(self * .pi / 180) }
}

extension Float {
    /// Converts degrees to radians.
    var degreesToRadians: Float { self * .pi / 180 }
}

#Preview {
    ImmersiveSphereView()
}
