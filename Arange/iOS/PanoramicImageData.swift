//
//  ProfileImageData.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

import SwiftUI
import PhotosUI
import CoreTransferable

enum TransferError: Error {
    case importFailed
}

struct PanoramicImageData: Transferable {
    /// The image data formatted as JPEG.
    let imageData: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            #if canImport(UIKit)
            guard let uiImage = UIImage(data: data),
                  let jpegData = uiImage.jpegData(compressionQuality: 0.8) else {
                throw TransferError.importFailed
            }
            return PanoramicImageData(imageData: jpegData)
            #elseif canImport(AppKit)
            guard let nsImage = NSImage(data: data),
                  let tiffData = nsImage.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let jpegData = bitmap.representation(using: .jpeg, properties: [:]) else {
                throw TransferError.importFailed
            }
            return ProfileImageData(imageData: jpegData)
            #else
            throw TransferError.importFailed
            #endif
        }
    }
}
