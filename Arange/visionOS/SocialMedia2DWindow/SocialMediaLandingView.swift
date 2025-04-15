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
    @State private var windowWidth: CGFloat = 0
    @State private var windowHeight: CGFloat = 0
    @State private var scrollToBottom: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("interior").resizable().opacity(0.5)
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        LazyVStack {
                            featurePostView
                                .id(0)
                            furnitureRecView
                                .id(1)
                            FurniturePostView(
                                furnitureThumbnails: furnitureThumbnails,
                                selectedCategory: $selectedCategory
                            )
                            .id(2)
                            .animation(.default, value: selectedCategory)
                            .padding()
                            FurniturePostSpheresView().padding()
                                .id(3)
                        }
                        .padding(50)
                    }
                    .onChange(of: scrollToBottom) { oldValue, newValue in
                        withAnimation(.easeInOut(duration: 1.2)) {
                            scrollProxy.scrollTo(newValue)
                        }
                    }
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
                Button("Discover ➜") {
                    scrollToBottom = 3
                }
                .buttonStyle(.bordered)
                .offset(x: -450, y: 150)
            }
            .padding(.bottom)
    }
    
    var furnitureRecView: some View {
        VStack(alignment: .leading) {
            Text("Get Inspired").font(.extraLargeTitle)
            FurnitureFiltersView(selectedCategory: $selectedCategory)
            HStack { Spacer() }
        }
    }
}

#Preview {
    SocialMediaLandingView()
}

#endif
