//
//  ViewModel.swift
//  Arange
//
//  Created by Guozhen Miao on 4/5/25.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var items: [FurnitureItem] = []

    func addItem(named name: String) {
        let newItem = FurnitureItem(
            name: name,
            position: SIMD3<Float>(0, 0, -1), // default 1m in front
            orientation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
        )
        items.append(newItem)
    }
}
