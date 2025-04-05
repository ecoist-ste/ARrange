//
//  SphereController.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

import Foundation

@Observable
class SphereController: ObservableObject {
    var currentBatch: Int = 0
    var animationDirection: Int = 1
}
