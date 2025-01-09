//
//  extension.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/23/24.
//

import Foundation
import SwiftUI

extension Double {
    func withFormat() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        
        return currencyFormatter.string(from: NSNumber(value: self))!
    }
}


let LINEAR_GRADIENT = LinearGradient(gradient: Gradient(colors: [Color(hue: 1.0, saturation: 0.829, brightness: 0.906), Color(hue: 0.892, saturation: 0.792, brightness: 0.957)]), startPoint: .top, endPoint: .bottom)


struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIView
    var style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context:
                        UIViewRepresentableContext<BlurView>) {
        
    }
}


enum AddPresentedView: Identifiable {
    case defaultView
    case event
    case market
    case work
    
    var id: Int {
       switch self {
            case .defaultView: return 1
            case .event: return 2
            case .market: return 3
            case .work: return 4
       }
   }
}
