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
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(FurnitureFilterWords, id: \.self) { word in
                    Button {
                        selectedCategory = word
                    } label: {
                        Text(word)
                            .padding()
                            .bold(selectedCategory == word)
                            .font(selectedCategory == word ? .system(size: 20) : .system(size: 16))
                            
                            
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
}



#Preview {
    FurnitureFiltersView(selectedCategory: .constant("Bedroom"))
}
