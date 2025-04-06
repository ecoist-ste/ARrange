//
//  FurnitureLibraryView.swift
//  Arange
//
//  Created by Guozhen Miao on 4/5/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct FurnitureLibraryView: View {
    let items = ["Chair", "Sofa", "Table"]
    @State private var selectedItem: String = "Chair"
    @EnvironmentObject var furnitureModel: ViewModel

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
                
                Button("Place Item") {
                    furnitureModel.addItem(named: selectedItem)
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
//        HStack {
//            // List of items on the left
//            List(items, id: \.self) { item in
//                Button(action: {
//                    selectedItem = item
//                }) {
//                    HStack {
//                        Text(item)
//                        if item == selectedItem {
//                            Spacer()
//                            Image(systemName: "checkmark")
//                        }
//                    }
//                }
//            }
//            .frame(width: 200) // Limit the list width
//
//            Spacer()
//
//            // 3D Model on the right
//            VStack {
//                Model3D(named: selectedItem, bundle: realityKitContentBundle) { model in
//                    model
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(maxWidth: 400, maxHeight: 400)
//                } placeholder: {
//                    ProgressView()
//                }
//            }
//            .padding()
//            Spacer()
//            
//            Button("Place Item") {
//                                
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//        }
//        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    FurnitureLibraryView()
}
