//
//  LandingPage.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//
#if os(iOS)
import SwiftUI
import PhotosUI

struct LandingView: View {
    var body: some View {
        NavigationStack {
            LaunchView()
        }
        
    }
}

struct LaunchView: View {
    @StateObject private var viewModel = PhotoViewModel()
    
    var body: some View {
            VStack {
                // Rectangular image view with full screen width and padding.
                Group {
                    switch viewModel.imageState {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .clipped()
                            .padding()
                    case .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .padding()
                    case .empty:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .foregroundColor(.gray)
                            .padding()
                    case .failure:
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                
                // Button to pick a panoramic photo.
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Text("Select Panoramic Photo")
                        .padding()
                        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 22))
                        
                }
                
                
                // Button to send the photo to Firebase.
                Button("Send to my Vision Pro") {
                    viewModel.sendToFirebase()
                }
                .padding()
                .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 22))
                
             
            }
            .padding()

    }
}
#endif
