//
//  FurnitureItem.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

import Foundation
import simd

struct FurnitureItem: Identifiable {
    let id = UUID()
    let name: String
    var position: SIMD3<Float>
    var orientation: simd_quatf
}
