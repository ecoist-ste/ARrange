//
//  ProfileModel.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

import SwiftUI
import PhotosUI
import CoreTransferable


import FirebaseCore
import FirebaseStorage

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
    @Published private(set) var panoramicImageData: Data? = nil
    
    // Photo picker selection.
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection = imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
                panoramicImageData = nil
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
                case .success(let panaromicImageDataResult?):
                    self.panoramicImageData = panaromicImageDataResult.imageData
                    print("Photo successfully stored.")
                    if let uiImage = UIImage(data: panaromicImageDataResult.imageData) {
                        self.imageState = .success(Image(uiImage: uiImage))
                    } else {
                        self.imageState = .failure(TransferError.importFailed)
                    }

                case .success(nil):
                    self.imageState = .empty
                    self.panoramicImageData = nil
                case .failure(let error):
                    self.imageState = .failure(error)
                    self.panoramicImageData = nil
                }
            }
        }
    }
    
    // TODO: Function to send the image to Firebase. (Jordan implement this code)
    func sendToFirebase() {
        if let data = panoramicImageData {
            // Get a reference to the storage service using the default Firebase App
            let storage = Storage.storage()

            // Create a storage reference from our storage service
            let storageRef = storage.reference()
            
            Task {
                let storageReference = storageRef.child("images/uid")
                do {
                    let result = try await storageReference.listAll()
                    let count = result.items.count
                    
                    let testRef = storageRef.child("images/\(count + 1).jpg")
                    
                    let uploadTask = testRef.putData(data, metadata: nil) { (metadata, error) in
                      guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        print("Error Occured")
                        return
                      }
                      // Metadata contains file metadata such as size, content-type.
                      let size = metadata.size
                      // You can also access to download URL after upload.
                      testRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                          // Uh-oh, an error occurred!
                          return
                        }
                      }
                    }
                } catch {
                  // ...
                }
            }
        
        } else {
            print("No image data to send.")
        }
    }
}
