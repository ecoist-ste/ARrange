//
//  SphereController.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//

#if os(visionOS)
import Foundation

@Observable
class SphereController: ObservableObject {
    var currentBatch: Int = 0
    var animationDirection: Int = 1
}
#endif
