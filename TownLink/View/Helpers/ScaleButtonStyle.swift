//
//  ScaleButtonStyle.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI
import CoreLocation

// MARK: ScaledButton Style
struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
