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
    // Each inner array: [image, name, short description, more description]
    let furnitureThumbnails: [[String]] = [
        [
            "furniture0",
            "elegant couch",
            "Refined and plush centerpiece",
            "This elegant couch showcases timeless sophistication with its graceful curves and plush cushions. Designed for both comfort and class, it's the perfect statement piece for upscale living rooms or refined lounge areas."
        ],
        [
            "furniture1",
            "errie lamp",
            "Mysterious ambient lighting",
            "This eerie lamp emits a soft, mysterious glow that adds an intriguing ambiance to any room. With its otherworldly design and shadowy charm, it’s ideal for creating a moody and atmospheric vibe."
        ],
        [
            "furniture2",
            "cozy armchair",
            "Soft and inviting seat",
            "This cozy armchair invites you to sink in and relax with its deep seat and soft upholstery. Designed for warmth and comfort, it’s perfect for reading corners, fireside chats, or lazy Sunday afternoons."
        ],
        [
            "furniture3",
            "modern side table",
            "Minimalist and functional",
            "This modern side table features clean lines and a minimalist profile that complements contemporary decor. Functional yet stylish, it's perfect for holding your favorite books, plants, or a cup of coffee."
        ],
        [
            "furniture4",
            "wooden chair",
            "Classic and sturdy",
            "This wooden chair combines sturdy craftsmanship with rustic charm. With its solid frame and classic silhouette, it's a versatile addition to any dining area, study, or cozy nook."
        ],
        [
            "furniture5",
            "game chair",
            "Ergonomic and sleek",
            "This game chair is built for performance and comfort, featuring an ergonomic design and sleek, modern look. Whether you're gaming for hours or working from home, it supports your posture while looking sharp."
        ],
        [
            "furniture6",
            "lean chair",
            "Slim and modern",
            "This lean chair is designed with simplicity in mind, offering a lightweight frame and slender profile. Ideal for small spaces or minimalist interiors, it provides style without the bulk."
        ],
        [
            "furniture7",
            "white couch",
            "Bright and modern",
            "This white couch brings a fresh, airy feel to any room with its clean lines and neutral tone. Its soft cushions and modern silhouette make it both stylish and welcoming for everyday living."
        ],
        [
            "furniture8",
            "study lamp",
            "Focused desk lighting",
            "This study lamp provides focused light with an adjustable design that’s perfect for desks and workstations. Its sleek finish and compact form make it a must-have for productivity and modern decor."
        ],
        [
            "furniture9",
            "homey lamp",
            "Warm and cozy glow",
            "This homey lamp adds a gentle, comforting glow to your space. With its warm light and charming design, it's perfect for bedrooms, reading corners, or any place where coziness is key."
        ]
    ]
    
    // Create a state array to store the favorite status for each furniture item.
    @State private var liked: [Bool]
    
    init() {
        // Initialize the liked array with false for each item.
        self.liked = Array(repeating: false, count: furnitureThumbnails.count)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                // Wrap the range in Array and annotate the type explicitly.
                ForEach(Array(0..<furnitureThumbnails.count), id: \.self) { (index: Int) in
                    let item = furnitureThumbnails[index]
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
