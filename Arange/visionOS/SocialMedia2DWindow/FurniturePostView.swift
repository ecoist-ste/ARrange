//
//  FurniturePostView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

#if os(visionOS)

import SwiftUI
import RealityKit
import RealityKitContent

let furnitureThumbnails: [[String]] = [
    [
        "furniture0",
        "Monarch Ivory Sofa",
        "Refined and plush centerpiece",
        "This white velvet sofa exudes luxury with its elegant curves and rich upholstery. A perfect blend of comfort and sophistication, it's ideal for upscale lounges and cozy statement corners.",
        "Living room"
    ],
    [
        "furniture1",
        "Luna Noir Lamp",
        "Mysterious ambient lighting",
        "This eerie lamp emits a soft, mysterious glow that adds an intriguing ambiance to any room. With its otherworldly design and shadowy charm, it’s ideal for creating a moody and atmospheric vibe.",
        "Bedroom"
    ],
    [
        "furniture2",
        "Cloudhaven Armchair",
        "Soft and inviting seat",
        "This cozy armchair invites you to sink in and relax with its deep seat and soft upholstery. Designed for warmth and comfort, it’s perfect for reading corners, fireside chats, or lazy Sunday afternoons.",
        "Living room"
    ],
    [
        "furniture3",
        "Orbit Side Table",
        "Minimalist and functional",
        "This modern side table features clean lines and a minimalist profile that complements contemporary decor. Functional yet stylish, it's perfect for holding your favorite books, plants, or a cup of coffee.",
        "Living room"
    ],
    [
        "furniture4",
        "Heritage Wood Chair",
        "Classic and sturdy",
        "This wooden chair combines sturdy craftsmanship with rustic charm. With its solid frame and classic silhouette, it's a versatile addition to any dining area, study, or cozy nook.",
        "Dining"
    ],
    [
        "furniture5",
        "Vortex Gaming Chair",
        "Ergonomic and sleek",
        "This game chair is built for performance and comfort, featuring an ergonomic design and sleek, modern look. Whether you're gaming for hours or working from home, it supports your posture while looking sharp.",
        "Workspace"
    ],
    [
        "furniture6",
        "Slimline Task Chair",
        "Slim and modern",
        "This lean chair is designed with simplicity in mind, offering a lightweight frame and slender profile. Ideal for small spaces or minimalist interiors, it provides style without the bulk.",
        "Workspace"
    ],
    [
        "furniture7",
        "Alba Lounge Sofa",
        "Bright and modern",
        "This white couch brings a fresh, airy feel to any room with its clean lines and neutral tone. Its soft cushions and modern silhouette make it both stylish and welcoming for everyday living.",
        "Living room"
    ],
    [
        "furniture8",
        "FocusLite Desk Lamp",
        "Focused desk lighting",
        "This study lamp provides focused light with an adjustable design that’s perfect for desks and workstations. Its sleek finish and compact form make it a must-have for productivity and modern decor.",
        "Workspace"
    ],
    [
        "furniture9",
        "HearthGlow Lamp",
        "Warm and cozy glow",
        "This homey lamp adds a gentle, comforting glow to your space. With its warm light and charming design, it's perfect for bedrooms, reading corners, or any place where coziness is key.",
        "Bedroom"
    ],
    [
        "furniture10",
        "Rust Luxe Ottoman",
        "Luxe and inviting texture",
        "This velvet ottoman adds a rich, tactile element to your living space. Upholstered in deep rust fabric, it's ideal as a footrest or casual coffee table, delivering warmth and style in one plush package.",
        "Living room"
    ],
    [
        "furniture11",
        "Marquina Stone Island",
        "Sleek and sculptural centerpiece",
        "This black marble kitchen island combines monolithic form with timeless elegance. Featuring dramatic white veining and a bold presence, it's a show-stopping statement for contemporary kitchens.",
        "Kitchen"
    ]
]


struct FurniturePostView: View {
    // Each inner array: [image, name, short description, more description]
    @Binding var selectedCategory: String
    
    
    @State private var liked: [Bool]
    
    let furnitureThumbnails: [[String]]
    
    
    init(furnitureThumbnails: [[String]], selectedCategory: Binding<String>) {
        // Initialize the liked array with false for each item.
        self.furnitureThumbnails = furnitureThumbnails
        self._selectedCategory = selectedCategory
        self.liked = Array(repeating: false, count: furnitureThumbnails.count)
    }
    
    var body: some View {
        let filtered = furnitureThumbnails.enumerated().filter { index, item in
            selectedCategory == "All" || item[4] == selectedCategory
        }
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 250), spacing: 30)], spacing: 30) {
                ForEach(filtered, id: \.0) { index, item in
                    let currentPrice = Double.random(in: 66.35..<900.35)
                    let heartBinding = Binding<Bool>(
                        get: { self.liked[index] },
                        set: { self.liked[index] = $0 }
                    )
                    OnePostView(
                        image: item[0],
                        name: item[1],
                        description: item[2],
                        moreDescription: item[3],
                        price: currentPrice,
                        heartIsTapped: heartBinding
                    )
                }
            }
            .padding()
        }
    }
    
}



struct OnePostView: View {
    @State private var presentSheet = false
    @Binding var heartIsTapped: Bool
    
    let image: String
    let name: String
    let description: String
    let moreDescription: String
    let price: Double
    
    init(image: String = "DefaultFurnitureImage",
         name: String,
         description: String,
         moreDescription: String,
         price: Double,
         heartIsTapped: Binding<Bool>) {
        self.image = image
        self.name = name
        self.description = description
        self.moreDescription = moreDescription
        self.price = price
        self._heartIsTapped = heartIsTapped
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(image)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .frame(width: 300, height: 350)
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    presentSheet = true
                }
                .sheet(isPresented: $presentSheet, onDismiss: {
                    presentSheet = false
                }, content: {
                    FurniturePostDetailView(
                        image: image,
                        name: name,
                        description: description,
                        moreDescription: moreDescription,
                        price: price,
                        heartIsTapped: $heartIsTapped
                    )
                    .frame(width: 1000)
                })
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                Text(description)
                    .frame(maxWidth: 300, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical)
            
            HStack {
                Text("\(price, format: .currency(code: "USD")) / piece")
                    .font(.title3)
                    .padding(.vertical)
                
                Spacer()
                
                Button {
                    withAnimation {
                        heartIsTapped.toggle()
                    }
                } label: {
                    Image(systemName: heartIsTapped ? "heart.fill" : "heart")
                }
                
                Button {
                    // Magnifying glass action (if any)
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
        .hoverEffect(.highlight)
        .hoverEffect { effect, isActive, _ in
            effect.scaleEffect(isActive ? 1.05 : 1.0)
        }
    }
}

#Preview {
    FurniturePostView(furnitureThumbnails: furnitureThumbnails, selectedCategory: .constant("Bedroom"))
}

#endif
