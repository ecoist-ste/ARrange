#if os(visionOS)
import SwiftUI

struct Pin: Identifiable {
    let id = UUID()
    var position: SIMD3<Float>
    var comment: String
}

class PinManager: ObservableObject {
    @Published var pins: [Pin] = []
    
    func addPin(at position: SIMD3<Float>, with comment: String) {
        let newPin = Pin(position: position, comment: comment)
        pins.append(newPin)
    }
}

struct ImmersiveControllerView: View {
    @EnvironmentObject var pinManager: PinManager
    
    @State private var x: Float = 0
    @State private var y: Float = 1.5
    @State private var z: Float = 0
    @State private var comment: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Drop a Pin").font(.headline)
            
            HStack {
                Text("X:")
                Slider(value: $x, in: -5...5)
            }
            HStack {
                Text("Y:")
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
        }
        .padding()
    }
}

//#Preview {
//    ImmersiveControllerView()
//        .environmentObject(SphereController())
//}
#endif
