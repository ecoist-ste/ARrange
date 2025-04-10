//
//  SocialMediaLandingView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

#if os(visionOS)
import SwiftUI

// Add a padded square frame over a blue background.

struct SocialMediaLandingView: View {
    @State private var selectedCategory: String = "All"
    
    var body: some View {
        NavigationStack {
            ZStack {
//                AnimatedFlowingGradientBackground()
                Image("interior").resizable().opacity(0.5)
                ScrollView {
                    LazyVStack {
                        featurePostView
                        furnitureRecView
                        FurniturePostView(
                            furnitureThumbnails: furnitureThumbnails,
                            selectedCategory: $selectedCategory
                        )
                        .animation(.default, value: selectedCategory)
                        .padding()
                        FurniturePostSpheresView().padding()
                    }
                    .padding(50)
                }
            }
        }
    }

    var featurePostView: some View {
        Image("banner4")
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(height: 450)
            .aspectRatio(contentMode: .fit)
            .overlay {
                Button("Discover ➜") {}.buttonStyle(.bordered)
                    .offset(x: -450, y: 150)
            }
    }

    var furnitureRecView: some View {
        VStack(alignment: .leading) {
            Text("Get Inspired").font(.extraLargeTitle)
            FurnitureFiltersView(selectedCategory: $selectedCategory)
            HStack { Spacer() }
        }
    }
}


struct AnimatedFlowingGradientBackground: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 109/255, green: 79/255, blue: 44/255),
                    Color(red: 124/255, green: 97/255, blue: 55/255),
                    Color(red: 139/255, green: 109/255, blue: 68/255),
                    Color(red: 156/255, green: 125/255, blue: 85/255),
                    Color(red: 170/255, green: 140/255, blue: 104/255),
                    Color(red: 184/255, green: 156/255, blue: 124/255),
                    Color(red: 201/255, green: 174/255, blue: 145/255),
                    Color(red: 217/255, green: 191/255, blue: 166/255),
                    Color(red: 231/255, green: 209/255, blue: 187/255),
                    Color(red: 244/255, green: 227/255, blue: 208/255),
                    Color(red: 251/255, green: 239/255, blue: 219/255),
                    Color(red: 255/255, green: 248/255, blue: 235/255),
                    Color(red: 255/255, green: 253/255, blue: 246/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .scaleEffect(1.5) // make it larger so we can "pan" across it
            .offset(x: animate ? -geo.size.width * 0.15 : geo.size.width * 0.15,
                    y: animate ? -geo.size.height * 0.1 : geo.size.height * 0.1)
            .animation(.linear(duration: 5).repeatForever(autoreverses: true), value: animate)
            .onAppear {
                animate = true
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SocialMediaLandingView()
}

#endif
