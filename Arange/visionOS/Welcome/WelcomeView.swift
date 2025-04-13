//
//  WelcomeView.swift
//  Arange
//
//  Created by Songyuan Liu on 4/5/25.
//
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Image("interior")
                .resizable()
            VStack {
                Spacer()
                Text("Welcome home, Architect!")
                    .font(.system(size: 50))
                    .bold()
                Spacer()
                HStack { Spacer() }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
