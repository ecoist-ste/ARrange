//
//  AppState.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//
import Foundation

@Observable
class AppState: ObservableObject {
    let immersiveSpaceID = "PreviewFurniture"
    enum WindowState {
        case authentication
        case socialMedia
        case me
    }
    
    var currentState = WindowState.authentication
    
    var isImmersive = false
    
    var furnitureNameToBePreviewed: String = "elegant_couch"
    
    var immersiveViewTextureImagePath: String = "demo3"
}

