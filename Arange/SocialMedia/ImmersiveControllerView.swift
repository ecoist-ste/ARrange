import SwiftUI

struct ImmersiveControllerView: View {
    @EnvironmentObject var sphereController: SphereController
    private let totalBatches: Int = 4  // With 20 spheres and 5 per batch.
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    // Rotate counterclockwise.
                    sphereController.animationDirection = -1
                    if sphereController.currentBatch > 0 {
                        sphereController.currentBatch -= 1
                    } else {
                        sphereController.currentBatch = totalBatches - 1
                    }
                } label: {
                    Image(systemName: "arrow.left.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding()
                }
                Button {
                    // Rotate clockwise.
                    sphereController.animationDirection = 1
                    if sphereController.currentBatch < totalBatches - 1 {
                        sphereController.currentBatch += 1
                    } else {
                        sphereController.currentBatch = 0
                    }
                } label: {
                    Image(systemName: "arrow.right.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding()
                }
            }
        }
        .padding()
        .glassBackgroundEffect()
        .frame(width: 400, height: 600)
    }
}

#Preview {
    ImmersiveControllerView()
        .environmentObject(SphereController())
}
