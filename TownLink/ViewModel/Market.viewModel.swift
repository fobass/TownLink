//
//  Market.viewModel.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/23/24.
//

import Foundation
import Combine

final class MarketStore: ObservableObject {
    @Published var items: [Item] = []
    
    
    init() {
        self.items = [
            Item.init(user_id: 1, title: "Basket", description: "Bla bla", price: 1.4, imagelink: "", lat: 0, lon: 0, dateadded: "ff", views: 0, sold: 12, liked: 5, distance: 3),
            Item.init(user_id: 2, title: "IPhone", description: "Bla bla", price: 1.4, imagelink: "", lat: 0, lon: 0, dateadded: "ff", views: 0, sold: 12, liked: 5, distance: 3),
            Item.init(user_id: 3, title: "TV", description: "Bla bla", price: 1.4, imagelink: "", lat: 0, lon: 0, dateadded: "ff", views: 0, sold: 12, liked: 5, distance: 3)
        ]
    }
}
