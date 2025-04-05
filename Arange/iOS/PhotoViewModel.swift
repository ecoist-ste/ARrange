//
//  ProfileModel.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

import SwiftUI
import PhotosUI
import CoreTransferable

@MainActor
class PhotoViewModel: ObservableObject {
    
    // MARK: - Image State
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    @Published private(set) var imageState: ImageState = .empty
    
    // Stores the transferable JPEG data (ready for Firebase upload)
    @Published private(set) var profileImageData: Data? = nil
    
    // Photo picker selection.
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection = imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
                profileImageData = nil
            }
        }
    }
    
    // Loads the transferable image data from the selected photo.
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: PanoramicImageData.self) { result in
            DispatchQueue.main.async {
                // Ensure the callback is for the current selection.
                guard imageSelection == self.imageSelection else {
                    print("Discarding outdated selection result.")
                    return
                }
                switch result {
                case .success(let profileImageDataResult?):
                    self.profileImageData = profileImageDataResult.imageData
                    print("Photo successfully stored.")
                    if let uiImage = UIImage(data: profileImageDataResult.imageData) {
                        self.imageState = .success(Image(uiImage: uiImage))
                    } else {
                        self.imageState = .failure(TransferError.importFailed)
                    }

                case .success(nil):
                    self.imageState = .empty
                    self.profileImageData = nil
                case .failure(let error):
                    self.imageState = .failure(error)
                    self.profileImageData = nil
                }
            }
        }
    }
    
    // TODO: Function to simulate sending the image to Firebase. (Jordan implement this code)
    func sendToFirebase() {
        if let _ = profileImageData {
            print("Sending image to Vision Pro (Firebase upload triggered).")
        } else {
            print("No image data to send.")
        }
    }
}
