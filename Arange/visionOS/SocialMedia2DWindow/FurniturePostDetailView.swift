//
//  FurniturePostDetailView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct FurniturePostDetailView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var isImmersive = false
    @State private var count = 1
    @State private var showMoreDescriptionPopover = false
    @State private var isMoreDescriptionHovered = false
    @State private var rating: Int = 0  // Interactive star rating

    // Removed local heart state; now passed in as a binding.
    @Binding var heartIsTapped: Bool

    let image: String
    let name: String
    let description: String
    let moreDescription: String
    let price: Double

    let productInformationLabels: [String] = [
        "Product details",
        "Measurements",
        "Delivery",
        "Assembly instructions"
    ]

    init(image: String = "DefaultFurnitureImage",
         name: String = "Default Furniture Name",
         description: String = "Default Description",
         moreDescription: String = "",
         price: Double = 0.0,
         heartIsTapped: Binding<Bool>) {
        self.image = image
        self.name = name
        self.description = description
        self.moreDescription = moreDescription
        self.price = price
        self._heartIsTapped = heartIsTapped
    }

    var body: some View {
        GeometryReader3D { proxy in
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: proxy.size.width / 1.8)
                    .overlay {
                        Button(isImmersive ? "Finish preview" : "Preview in your space") {
                            Task {
                                if isImmersive {
                                    await dismissImmersiveSpace()
                                    appState.isImmersive = false
                                } else {
                                    await openImmersiveSpace(id: "PreviewFurniture")
                                    appState.isImmersive = true
                                    appState.furnitureNameToBePreviewed = name
                                }
                                isImmersive.toggle()
                            }
                        }
                        .offset(y: proxy.size.height / 2.8)
                    }
                VStack(alignment: .leading, spacing: 20) {
                    // Top bar with back, share, and favorite (heart) button.
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                        }

                        Spacer()

                        Button {
                            // Share action
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }

                        Button {
                            withAnimation {
                                heartIsTapped.toggle()
                            }
                        } label: {
                            Image(systemName: heartIsTapped ? "heart.fill" : "heart")
                        }
                    }
                    .padding()

                    Spacer()

                    // Title, description, and interactive star rating.
                    HStack {
                        VStack(alignment: .leading) {
                            Text(name)
                                .font(.largeTitle)
                            Text(description)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Rate this product:")
                                .font(.subheadline)
                            HStack(spacing: 4) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .onTapGesture {
                                            rating = star
                                        }
                                }
                            }
                        }
                    }
                    
                    // "moreDescription" text with tap-to-show popover and hover effect that increases font size.
                    Text(moreDescription)
                        .font(.system(size: isMoreDescriptionHovered ? 20 : 16))
                        .padding(.bottom, 20)
                        .onTapGesture {
                            showMoreDescriptionPopover = true
                        }
                        .popover(isPresented: $showMoreDescriptionPopover) {
                            VStack(alignment: .center) {
                                Text("More Description")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                Divider()
                                ScrollView {
                                    Text(moreDescription)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                }
                            }
                            .padding()
                            .frame(width: 250)  // Limit the popover width.
                        }
                        .onHover { hovering in
                            withAnimation(.easeInOut) {
                                isMoreDescriptionHovered = hovering
                            }
                        }
                    
                    // Product information labels.
                    ForEach(productInformationLabels, id: \.self) { label in
                        VStack {
                            Divider().offset(y: -10)
                            HStack {
                                Text(label)
                                Spacer()
                                Image(systemName: "plus")
                            }
                        }
                        .padding(.bottom, 5)
                    }
                    
                    // Quantity selection and Add to Cart button.
                    HStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                if count > 0 { count -= 1 }
                            }) {
                                Image(systemName: "minus")
                                    .clipShape(Circle())
                            }
                            
                            Text("\(count)")
                                .font(.system(size: 20, weight: .bold))
                            
                            Button(action: {
                                count += 1
                            }) {
                                Image(systemName: "plus")
                                    .clipShape(Circle())
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 22).fill(Color.white.opacity(0.3)))
                        
                        Button {
                            // Add to cart action
                        } label: {
                            Text("Add to cart (\(price, format: .currency(code: "USD")))")
                                .foregroundStyle(.black)
                        }
                        .background(Color.yellow, in: RoundedRectangle(cornerRadius: 22))
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .glassBackgroundEffect()
    }
}
