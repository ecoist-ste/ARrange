//
//  MyProjectsView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//
#if os(visionOS)
import SwiftUI
import RealityKit
import RealityKitContent

struct MyProjectsView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @EnvironmentObject var furnitureModel: FurnitureViewModel
    @State private var selectedItem: String = "Funky Sofa"
    @State private var isImmersive = false
    
    let items = ["Funky Sofa",
                 "Chair",
                 "modern_table",
                 "errie lamp",
                 "cozy armchair",
                 "modern side table",
                 "wooden chair",
                 "game chair",
                 "lean chair",
                 "white couch",
                 "study lamp",
                 "homey lamp"]
        
        var body: some View {
                NavigationSplitView {
                    VStack {
                        Spacer()
                        Text("Furnitures")
                            .font(.title)
                            .padding()
                        
                        Spacer()
                        
                        List(items, id: \.self) { item in
                            Divider()
                            Button(action: {
                                selectedItem = item
                            }) {
                                HStack {
                                    Spacer()
                                    Text(item)
                                    Image(systemName: "checkmark")
                                        .opacity(item == selectedItem ? 1 : 0)
                                    Spacer()
                                }
                                
                            }
                        }
                        .animation(.easeOut, value: selectedItem)
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
                                    isImmersive = false
                                } else {
                                    await openImmersiveSpace(id: "PreviewFurniture")
                                    isImmersive = true
                                    appState.furnitureNameToBePreviewed = selectedItem
                                    
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

#endif
