//
//  ImmersivePostsEntryView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/9/25.
//

import SwiftUI


struct ImmersivePostsEntryView: View {
    var allImmersivePosts: [ImmersivePost] = []

    let columns = [GridItem(.adaptive(minimum: 360), spacing: 32)]
    
    let userNames = [
        "Steven",
        "Jordan",
        "Jiyoon",
        "Amiire",
        "Tim"
    ]
    @State private var scrollIndex = 0

    init() {
        for i in 0..<50 {
            allImmersivePosts.append(ImmersivePost(
                textureImagePath: "demo\(i % 12 == 0 ? 10 : i % 12)",
                previewImagePath: "demo\(i % 12 == 0 ? 10 : i % 12)",
                avatarImageName: "avatar\(i % 5)",
                caption: "Interior style \(i + 1)",
                username: "\(userNames[i % 5])"
            ))
        }
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(Array(allImmersivePosts.enumerated()), id: \.1.id) { index, post in
                        ImmersivePostCardView(post: post)
                            .id(index)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)
                .padding(.bottom, 200) // leave space for ornament
            }
            .onChange(of: scrollIndex) { newValue in
                withAnimation(.easeInOut) {
                    scrollProxy.scrollTo(newValue, anchor: .top)
                }
            }
        }
        .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .center) {
            HStack(spacing: 40) {
                Button {
                    scrollIndex = max(scrollIndex - 6, 0)
                } label: {
                    Image(systemName: "chevron.up.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }

                Button {
                    scrollIndex = min(scrollIndex + 6, allImmersivePosts.count - 1)
                } label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .ignoresSafeArea()
    }
}

struct ImmersivePostCardView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @EnvironmentObject private var appstate: AppState
    @State private var isHovered = false
    let post: ImmersivePost

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: isHovered ? 20 : 10, x: 0, y: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )

            VStack {
                HStack(spacing: 10) {
                    Image(post.avatarImageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())

                    Text(post.username)
                        .font(.headline)
                        .bold()

                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 12)

                Spacer(minLength: 4)

                Image(post.previewImagePath)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal, 8)

                Spacer(minLength: 4)

                Text(post.caption)
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
            }
            .foregroundStyle(
                .white.opacity(1)
            )
        }
        .frame(width: 380, height: 280)
        .padding()
        .hoverEffect(.highlight)
        .hoverEffect { effect, isActive, _ in
            effect.scaleEffect(isActive ? 1.05 : 1.0)
        }
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            appstate.immersiveViewTextureImagePath = post.textureImagePath
            Task {
                await openImmersiveSpace(id: "ImmersiveSphereView")
                openWindow(id: "ImmersiveController")
            }
        }

    }
}

struct ImmersivePost: Identifiable {
    let id: UUID = UUID()
    let textureImagePath: String
    let previewImagePath: String
    let avatarImageName: String
    let caption: String
    let username: String

    init(textureImagePath: String = "defaultTextureImagePath",
         previewImagePath: String = "defaultPreviewImagePath",
         avatarImageName: String = "avatar0",
         caption: String = "A beautiful room.",
         username: String = "guest_user") {
        self.textureImagePath = textureImagePath
        self.previewImagePath = previewImagePath
        self.avatarImageName = avatarImageName
        self.caption = caption
        self.username = username
    }
}

#Preview {
    ImmersivePostsEntryView()
        .environmentObject(AppState())
}
