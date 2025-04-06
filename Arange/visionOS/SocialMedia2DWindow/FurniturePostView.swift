//
//  FurniturePostView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct FurniturePostView: View {
    
    let furnitureThumbnails: [[String]] = [
        [
            "furniture0",
            "elegant couch",
            "This elegant couch is designed with refined comfort and sophisticated style in mind. It features plush cushions and sleek lines that make it an ideal centerpiece for any modern living room. The design effortlessly balances luxury with everyday comfort."
        ],
        [
            "furniture1",
            "errie lamp",
            "This errie lamp boasts a uniquely intriguing design that captivates the eye. Its unconventional form and mysterious glow add an unexpected twist to traditional lighting. The lamp serves as both a functional piece and a conversation starter in any space."
        ],
        [
            "furniture2",
            "cozy armchair",
            "This cozy armchair is crafted to offer maximum comfort and a welcoming vibe. Its soft fabric and inviting design make it perfect for quiet reading nooks or relaxing afternoons. The chair's timeless appeal complements both modern and classic interiors."
        ],
        [
            "furniture3",
            "modern side table",
            "This modern side table features a minimalist design that enhances contemporary decor. It is crafted with clean lines and a functional silhouette to provide both style and practicality. Ideal for accentuating living spaces or as an auxiliary surface in any room."
        ],
        [
            "furniture4",
            "wooden chair",
            "This wooden chair exudes natural charm and sturdy elegance. Its classic design and rich wood finish make it a versatile addition to any dining or living space. The chair combines timeless aesthetics with modern durability."
        ],
        [
            "furniture5",
            "game chair",
            "This game chair is engineered for extended comfort during intense gaming sessions. Its ergonomic design and adjustable features provide the perfect balance of support and style. The chair not only enhances gameplay but also adds a modern flair to your setup."
        ],
        [
            "furniture6",
            "lean chair",
            "This lean chair is defined by its streamlined silhouette and minimalist appeal. It offers a comfortable seating option without compromising on style. The chair's contemporary design makes it a fitting choice for modern interiors."
        ],
        [
            "furniture7",
            "white couch",
            "This white couch offers a fresh and sophisticated look that brightens any space. Its crisp design and inviting seating provide a perfect blend of elegance and comfort. A versatile piece that works well in both modern and classic settings."
        ],
        [
            "furniture8",
            "study lamp",
            "This study lamp delivers focused illumination with a chic and modern design. It is thoughtfully designed to provide optimal lighting for reading or working, making it an essential piece for any study area. The lamp combines functionality with a sleek aesthetic."
        ],
        [
            "furniture9",
            "homey lamp",
            "This homey lamp creates a warm and inviting atmosphere with its gentle glow. Its design is both practical and charming, perfect for adding a cozy touch to any room. The lamp is an excellent choice for creating a comfortable and relaxed home environment."
        ]
    ]

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(furnitureThumbnails.indices, id: \.self) { thumbnailIndex in
                    OnePostView(image: furnitureThumbnails[thumbnailIndex][0], name:  furnitureThumbnails[thumbnailIndex][1], description:  furnitureThumbnails[thumbnailIndex][2], price: Double.random(in: 66.35..<900.35))
                }
            }
            
        }
    }
}


struct OnePostView: View {
    
    @State private var presentSheet = false
    
    let image: String
    let name: String
    let description: String
    let price: Double
    
    init(image: String = "DefaultFurnitureImage", name: String, description: String, price: Double) {
        self.image = image
        self.name = name
        self.description = description
        self.price = price
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
                    FurniturePostDetailView(image: image, name: "Table 1", description: "Side table, stone, 40x28cm", price: 83)
                        .frame(width: 1000)
                })
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                Text(description)
                    .frame(maxWidth: 300, alignment: .leading) // constrain width
                    .fixedSize(horizontal: false, vertical: true) // allow wrapping
            }
            .padding(.vertical)
            
            HStack {
                Text("\(price, format: .currency(code: "USD")) / piece")
                    .font(.title3)
                    .padding(.vertical)
                
                Spacer()
                
                Button {
                    // heart action
                } label: {
                    Image(systemName: "heart")
                }
                
                Button {
                    // magnifying glass action
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                }
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 20)
        .hoverEffect(.highlight)
        .hoverEffect { effect, isActive, _ in
            effect.scaleEffect(isActive ? 1.05: 1.0)
        }
    }
}


#Preview {
    FurniturePostView()
}
