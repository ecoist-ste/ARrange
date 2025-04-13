#if os(visionOS)
import SwiftUI

struct Pin: Identifiable {
    let id = UUID()
    var position: SIMD3<Float>
    var comment: String
}

@Observable
class PinManager: ObservableObject {
    var pins: [Pin] = []
    
    func addPin(at position: SIMD3<Float>, with comment: String) {
        let newPin = Pin(position: position, comment: comment)
        pins.append(newPin)
    }
}

struct ImmersiveControllerView: View {
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    @EnvironmentObject var pinManager: PinManager
    
    @State private var x: Float = 0
    @State private var y: Float = 1.5
    @State private var z: Float = 0
    @State private var comment: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Drop a Pin").font(.headline)
            
            HStack {
                Text("Pin's size:")
                Slider(value: $x, in: -5...5)
            }
            HStack {
                Text("Pin's color:")
                Slider(value: $y, in: 0...5)
            }
            HStack {
                Text("Z:")
                Slider(value: $z, in: -5...5)
            }
            
            TextField("Comment", text: $comment)
                .textFieldStyle(.roundedBorder)
            
            Button("Add Pin") {
                pinManager.addPin(at: SIMD3<Float>(x, y, z), with: comment)
                comment = ""
            }
            .buttonStyle(.borderedProminent)
            
            Button("Exit Immersive Space") {
                Task {
                    await dismissImmersiveSpace()
                    dismissWindow(id: "ImmersiveController")
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ImmersiveControllerView()
        .environmentObject(PinManager())
}
#endif
