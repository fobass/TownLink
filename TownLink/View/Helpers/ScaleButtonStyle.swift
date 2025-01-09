//
//  ScaleButtonStyle.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.996 : 1)
            .opacity(configuration.isPressed ? 0.93 : 1)
            .animation(.linear(duration: 0.1))
    }
}

