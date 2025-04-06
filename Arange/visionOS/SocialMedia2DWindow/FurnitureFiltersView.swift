//
//  FurnitureFiltersView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//
import SwiftUI

let FurnitureFilterWords: [String] = [
    "All",
    "Bedroom",
    "Living room",
    "Kitchen",
    "Workspace",
    "Bathroom",
    "Dining",
    "Laundry"
]

struct FurnitureFiltersView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(FurnitureFilterWords, id: \.self) { word in
                    Button {
                        // TODO: hh
                    } label: {
                        Text(word)

                    }
                }
            }
            
        }
    }
}



#Preview {
    FurnitureFiltersView()
}
