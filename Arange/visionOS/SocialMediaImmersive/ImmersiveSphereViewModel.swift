//
//  ImmersiveSphereViewModel.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//
#if os(visionOS)
import UIKit
import SwiftUI
import RealityKit
import Combine

import FirebaseCore
import FirebaseStorage

// MARK: - ImmersiveSphereViewModel
class ImmersiveSphereViewModel: ObservableObject {
    // Business logic and layout constants.
    let sphereRadius: Float = 0.3
    let totalSpheres: Int = 12
    let spheresPerBatch: Int = 4
    let animationDuration: Float = 1.0
    let pivotRadius: Float = 1.5
    let sphereHeight: Float = 1.5
    var demoImages: [String] = ["demo1",
                                "demo2",
                                "demo3",
                                "demo4",
                                "demo5",
                                "demo6",
                                "demo7",
                                "demo8",
                                "demo9",
                                "demo10",
                                "demo11",
                                "demo12",]
    
    var imageTextures: [String: TextureResource] = [:]
    
    // Array of all 20 spheres.
    @Published var spheres: [Entity] = []
    
    @Published var isTapped = false
    
    @Published var isDoubleTapped = false
    @Published var originalPos: SIMD3<Float> = .zero
    
    init() {
        resetSpheres()
    }
    
    func resetSpheres() {
        Task {
            let ref = Storage.storage().reference().child("images")
            do {
                let result = try await ref.listAll()
                
                DispatchQueue.main.async {
                    for item in result.items {
                        // The items under storageReference.
                        if (!self.demoImages.contains(item.fullPath)) {
                            self.demoImages.append(item.fullPath)
                        }
                    }
                }
            } catch {
                // ...
                print("Error fetching items")
            }
        }
        self.spheres = self.arrangeSpheres()
    }
    
    /// Arranges spheres evenly around a circle.
    func arrangeSpheres() -> [Entity] {
        print("enter arrangeSpheres()")
        
        var createdSpheres: [Entity] = []
        for i in 0..<self.demoImages.count {
            if let skybox = createSkybox(
                using: demoImages[i],
                sphereRadius: sphereRadius
            ) {
                // Calculate the angle for this sphere.
                let angle = (2 * Float.pi / Float(self.demoImages.count)) * Float(i)
                let x = pivotRadius * sin(angle)
                let z = -pivotRadius * cos(angle)
                skybox.transform.translation = SIMD3<Float>(x, sphereHeight, z)
                createdSpheres.append(skybox)
                
                print("append skybox")
            }
        }
        return createdSpheres
    }
    
    /// Updates the pivot node's rotation based on the current batch.
    /// Each batch corresponds to a 90° step.
    func updatePivotRotation(pivot: Entity, currentBatch: Int, animated: Bool) {
        let stepAngle = 90.0.degreesToRadians
        let targetAngle = -Float(currentBatch) * stepAngle
        let targetRotation = simd_quatf(angle: targetAngle, axis: SIMD3(0, 1, 0))
        let targetTransform = Transform(scale: pivot.transform.scale,
                                        rotation: targetRotation,
                                        translation: pivot.transform.translation)
        if animated {
            pivot.move(to: targetTransform,
                       relativeTo: pivot.parent,
                       duration: TimeInterval(animationDuration),
                       timingFunction: .easeInOut)
        } else {
            pivot.transform = targetTransform
        }
    }
    
    
    // MARK: - Texture Loading
    /// Main function to create a skybox entity using the given image. It uses the helper functions
    /// to load the texture (downscaling if necessary) and then creates the entity.
    func createSkybox(using imagePath: String = "demo1", maxDimension: CGFloat = 8193, sphereRadius: Float) -> Entity? {
        print(imageTextures)
        
        
        if (imageTextures.index(forKey: imagePath) == nil) {
            if let texture = loadTexture(for: imagePath, maxDimension: maxDimension) {
                imageTextures[imagePath] = texture
            }
        } else {
            if let texture = imageTextures[imagePath] {
                let containerEntity = createContainerEntity(with: sphereRadius, texture: texture)
                return containerEntity
            }
        }
        
        return nil
    }
    
    /// Loads a texture from the asset bundle. If the image's dimensions exceed maxDimension,
    /// the image is downscaled and loaded from a temporary file. Otherwise, it is loaded directly.
    func loadTexture(for imagePath: String, maxDimension: CGFloat) -> TextureResource? {
        if (imagePath.contains("/")) {
            let imageRef = Storage.storage().reference().child(imagePath)
            
            print("Entering download data")
            imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print("Error occured when downloading image: \(error)")
                } else {
                    // Data for "images/island.jpg" is returned
                    print("Got Downloaded Data")
                    let image = UIImage(data: data!)
                    
                    guard let image = image else {
                        print("Failed to load image named \(imagePath)")
                        return
                    }
                     
                    
                    let width = image.size.width
                    let height = image.size.height
                    let needsDownscale = width > maxDimension || height > maxDimension
                    
                    var result: TextureResource?
                    
                    if needsDownscale {
                        result = self.downscaleAndLoadTexture(for: image, imagePath: imagePath, maxDimension: maxDimension)
                    } else {
                        do {
                            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(self.demoImages.firstIndex(of: imagePath) ?? 0)_temp.png")
                            try data!.write(to: tempURL)
                            
                            result = try TextureResource.load(contentsOf: tempURL)
                        } catch {
                            print("Failed to load texture named \(imagePath): \(error)")
                            return
                        }
                    }
                    
                    if let result = result {
                        self.imageTextures[imagePath] = result
                    }
                }
            }
        } else {
            let image = UIImage(named: imagePath)
            
            guard let image = image else {
                print("Failed to load image named \(imagePath)")
                return nil
            }
            
            
            let width = image.size.width
            let height = image.size.height
            let needsDownscale = width > maxDimension || height > maxDimension
            
            if needsDownscale {
                return downscaleAndLoadTexture(for: image, imagePath: imagePath, maxDimension: maxDimension)
            } else {
                do {
                    return try TextureResource.load(named: imagePath)
                } catch {
                    print("Failed to load texture named \(imagePath): \(error)")
                    return nil
                }
            }
        }
        
        return nil
    }

    /// Downscales the provided image to fit within maxDimension while preserving aspect ratio,
    /// writes the downscaled image to a temporary file, and loads a texture from that file.
    func downscaleAndLoadTexture(for image: UIImage, imagePath: String, maxDimension: CGFloat) -> TextureResource? {
        let width = image.size.width
        let height = image.size.height
        let aspectRatio = width / height
        
        let newSize: CGSize = (width > height)
            ? CGSize(width: maxDimension, height: maxDimension / aspectRatio)
            : CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let finalImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        print("Image downscaled from \(width)x\(height) to \(newSize.width)x\(newSize.height)")
        
        guard let data = finalImage.pngData() else {
            print("Failed to create PNG data from image.")
            return nil
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(demoImages.firstIndex(of: imagePath) ?? 0)_temp.png")
        
        do {
            try data.write(to: tempURL)
        } catch {
            print("Error writing image: \(error)")
            return nil
        }
        
        do {
            return try TextureResource.load(contentsOf: tempURL)
        } catch {
            print("Failed to load texture from downscaled image: \(error)")
            return nil
        }
    }

    // MARK: - Entity Creation

    /// Creates a container entity with an input target and collision component, then adds a visual child
    /// that renders the sphere with a negative x-scale (to create the skybox inversion effect).
    func createContainerEntity(with sphereRadius: Float, texture: TextureResource) -> Entity {
        // Create the sphere mesh.
        let sphereMesh = MeshResource.generateSphere(radius: sphereRadius)
        var material = UnlitMaterial()
        material.color = .init(texture: .init(texture))
        
        // Create the container entity that handles input and collision.
        let containerEntity = Entity()
        containerEntity.components.set(InputTargetComponent())
        let collisionComponent = CollisionComponent(shapes: [.generateSphere(radius: sphereRadius)])
        containerEntity.components.set(collisionComponent)
        
        // Create the visual child entity with negative scale for the skybox effect.
        let visualEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        visualEntity.scale = SIMD3<Float>(-1, 1, 1)
        containerEntity.addChild(visualEntity)
        
        return containerEntity
    }

    
    /// A simple linear interpolation helper.
    func lerp(start: Float, end: Float, t: Float) -> Float {
        return start + (end - start) * t
    }
}

extension Double {
    var degreesToRadians: Float { Float(self * .pi / 180) }
}

extension Float {
    var degreesToRadians: Float { self * .pi / 180 }
}
#endif
