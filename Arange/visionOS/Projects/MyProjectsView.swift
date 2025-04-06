//
//  MyProjectsView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//
import SwiftUI
import RealityKit
import RealityKitContent

struct MyProjectsView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @EnvironmentObject var furnitureModel: FurnitureViewModel
    @State private var selectedItem: String = "Chair"
    @State private var isImmersive = false
    
    let items = ["Chair", "Sofa", "Table"]
        
        var body: some View {
            NavigationSplitView {
                VStack {
                    Spacer()
                    Text("Furnitures")
                        .font(.title)
                        .padding()
                    
                    Spacer()
                    
                    List(items, id: \.self) { item in
                        Button(action: {
                            selectedItem = item
                        }) {
                            HStack {
                                Text(item)
                                if item == selectedItem {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                    Spacer()
                }
            } detail: {
                HStack{
                    Spacer()
                    
                    Model3D(named: selectedItem, bundle: realityKitContentBundle) { model in
                        model
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 400, maxHeight: 400)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(isImmersive ? "Stop viewing" : "View in your space ") {
                        Task {
                            if isImmersive {
                                await dismissImmersiveSpace()
                            } else {
                                await openImmersiveSpace(id: "PreviewFurniture")
                            }
                        }
                    }
                    .padding()
                    .buttonStyle(.automatic)
                }
            }
        }
}

#Preview {
    MyProjectsView()
}
