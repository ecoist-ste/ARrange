//
//  FurniturePostSpheresView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//
#if os(visionOS)

import SwiftUI

struct FurniturePostSpheresView: View {
    var body: some View {
        ZStack {
            Image("social_media_immersive_sphere")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: 2000, maxHeight: 720)

            NavigationLink(destination: ImmersivePostsEntryView()) {
                Text("View Immersive Furniture Posts")
                    .font(.headline)
                    .padding()
                    .clipShape(Capsule())
            }
            .offset(y: 150)
        
        }
        .padding()
    }
}

#Preview {
    FurniturePostSpheresView()
}

#endif
//#if os(visionOS)
//
//import SwiftUI
//
//struct FurniturePostSpheresView: View {
//    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
//    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
//    @Environment(\.openWindow) private var openWindow
//    @Environment(\.dismissWindow) private var dismissWindow
//    @State private var isImmersive = false
//    
//    var body: some View {
//        
//        Image("social_media_immersive_sphere")
//            .resizable()
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .frame(height: 450)
//            .aspectRatio(contentMode: .fit)
//            .overlay(alignment: .center, content: {
//                Button(isImmersive ? "Close Immersive Space" : "View Immersive Furniture Posts") {
//                    Task {
//                        if isImmersive {
//                            await dismissImmersiveSpace()
//                            dismissWindow(id: "ImmersiveController")
//                            isImmersive = false
//                        } else {
//                            await openImmersiveSpace(id: "ImmersiveSphereView")
//                            openWindow(id: "ImmersiveController")
//                            isImmersive = true
//                        }
//                    }
//                }
//                .offset(y: 90)
//            })
//    }
//}
//
//#Preview {
//    FurniturePostSpheresView()
//}
//
//#endif
