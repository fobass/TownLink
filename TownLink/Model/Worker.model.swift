//
//  Worker.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import Foundation

struct Worker: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var city: String
    var remark: String
    var distance: Double
    var avatar: String
    var isVerified: Bool
    var flyDate: String

    var displayDistance : String {
          get {
              if distance > 0 {
                  return String(format: "%.1f", distance) + "km"
              } else {
                  return ""
              }
          }
      }
}
