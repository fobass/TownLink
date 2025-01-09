//
//  Market.model.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/23/24.
//

import Foundation

struct Item: Identifiable, Hashable {
    var id = UUID()
    let user_id: Int
    let title: String
    let description: String
    let price: Double
    let imagelink: String
    let lat, lon: Double
    let dateadded: String
    let views, sold, liked: Int
    let distance: Double

//    enum CodingKeys: String, CodingKey {
//        case id, uuid, title
//        case itemDescription = "description"
//        case price, imagelink, lat, lon, dateadded, views, sold, reviewid, distance
//    }
//    
    var DisplayDistance : String {
        get {
            if distance > 0 {
                return String(format: "%.1f", distance) + "km"
            } else {
                return ""
            }
        }
    }
    
//    var DisplayDateAdded : String {
//        get {
//            let formatter = DateFormatter()
//            formatter.locale = .current
//            formatter.dateFormat = "dd-MMM-YYYY"
//            return formatter.string(from: StrToDate(str: self.dateadded))
//        }
//    }
//    
    var priceVal: String {
        get {
            return price.withFormat()
        }
    }
    
}

//typealias Market = [MarketItem]

struct ItemDetail:  Hashable {
//    var id : UUID
    let item_id: UUID
    let user_id: Int
    let title: String
    let itemDescription: String
    let price: Double
    let imagelink: String
    let lat, lon: Double
    let dateadded: String
    let views, sold: Int
    let reviewid: String
    let distance: Double
    let location: String
    let tags: String
}
