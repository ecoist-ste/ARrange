//
//  ImmersivePostsEntryView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/9/25.
//

import SwiftUI



struct ImmersivePostsEntryView: View {

    
    var allImmersivePosts: [ImmersivePost] = []
    
    let columns = [GridItem(.adaptive(minimum: 300), spacing: 16)]
    
    init() {
        for i in 0..<50 {
            allImmersivePosts.append(ImmersivePost(textureImagePath: "", previewImagePath: "demo\(i % 12 == 0 ? 10 : i % 12)"))
        }
    }
    
    var body: some View {
        ZStack {
            Image("interior").resizable().opacity(0.5)
            ScrollView {
                Spacer()
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allImmersivePosts) { post in
                        ImmersivePostCardView(post: post)
                    }
                }
                .background(.clear)
                .padding(.horizontal)
                Spacer()
            }
            
        }
    }
    
}

struct ImmersivePostCardView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var isImmerive = false
    @State private var isHovered = false
    let post: ImmersivePost
    
    var body: some View {
        Image(post.previewImagePath)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .hoverEffect(.highlight)
            .hoverEffect { effect, isActive, _ in
                effect
                    .scaleEffect(isActive ? 1.1 : 1.0)
            }
            .overlay {
                Button(isImmerive ? "Exit" : "Open") {
                    Task {
                        if isImmerive {
                          await  dismissImmersiveSpace()
                            isImmerive = false
                            dismissWindow(id: "ImmersiveController")
                        } else {
                            await openImmersiveSpace(id: "ImmersiveSphereView")
                            isImmerive = true
                            openWindow(id: "ImmersiveController")
                        }
                    }
                }
                .opacity(0.8)
                .padding(.top, 50)
            }
            
        
    }
}

struct ImmersivePost: Identifiable {
    let id: UUID = UUID()
    let textureImagePath: String
    let previewImagePath: String
    
    init(textureImagePath: String = "defaultTextureImagePath", previewImagePath: String = "defaultPreviewImagePath") {
        self.textureImagePath = textureImagePath
        self.previewImagePath = previewImagePath
    }
}

#Preview {
    ImmersivePostsEntryView()
}
