//
//  Event.model.swift
//  TownLink
//
//  Created by Ernist Isabekov on 2/16/25.
//

import Foundation
import SwiftUI

struct Attend {
    var attendee_id: Int
    var user_id: Int
    var event_id: Int
    var status: String
    var ticket_qr_code: String
    var created_at: Date
}

extension Attend: Codable {
    enum CodingKeys: String, CodingKey {
        case attendee_id
        case user_id
        case event_id
        case status
        case ticket_qr_code
        case created_at
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(Int(created_at.timeIntervalSince1970), forKey: .created_at)
        try container.encode(attendee_id, forKey: .attendee_id)
        try container.encode(user_id, forKey: .user_id)
        try container.encode(event_id, forKey: .event_id)
        try container.encode(status, forKey: .status)
        try container.encode(ticket_qr_code, forKey: .ticket_qr_code)
    }
}


struct EventDetail {
    var event_id: Int
    var name: String
    var description: String
    var start_time: Date
    var end_time: Date
    var latitude: Double
    var longitude: Double
    var address: String
    var town_name: String
    var organizer_id: Int
    var created_at: Date
    var updated_at: Date
    var attendees: Int
    var max_attendees: Int
    var ticket_price: Double
    var category: String
    
    init(event_id: Int = -1, name: String = "", description: String = "", start_time: Date = Date.now, end_time: Date = Date.now, latitude: Double = 0, longitude: Double = 0, address: String = "", town_name: String = "", organizer_id: Int = -1, created_at: Date = Date.now, updated_at: Date = Date.now, attendees: Int = -1, max_attendees: Int = 0, ticket_price: Double = 0, category: String = "") {
        self.event_id = event_id
        self.name = name
        self.description = description
        self.start_time = start_time
        self.end_time = end_time
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.town_name = town_name
        self.organizer_id = organizer_id
        self.created_at = created_at
        self.updated_at = updated_at
        self.attendees = attendees
        self.max_attendees = max_attendees
        self.ticket_price = ticket_price
        self.category = category
    }
    
    
    var isComplete : Bool {
        return !name.isEmpty 
    }
    
    var isValid: Bool {
           !name.isEmpty && start_time < end_time && max_attendees > 0 && !category.isEmpty
       }
       
    var validationErrors: [String] {
       var errors: [String] = []
       if name.isEmpty { errors.append("Event name is required") }
       if start_time >= end_time { errors.append("Start date must be before end date") }
       if max_attendees <= 0 { errors.append("Max attendees must be greater than 0") }
       if category.isEmpty { errors.append("Category is required") }
       return errors
    }
    
    var starttime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"  // "Wed, Jun 5 7:00 PM"
        return formatter.string(from: start_time)
    }
    
}

extension EventDetail: Codable {
    enum CodingKeys: String, CodingKey {
        case event_id
        case name
        case description
        case start_time
        case end_time
        case latitude
        case longitude
        case address
        case town_name
        case organizer_id
        case created_at
        case updated_at
        case attendees
        case max_attendees
        case ticket_price
        case category
    }
    
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Supports "2024-02-17T12:34:56Z"
        return formatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        event_id = try container.decode(Int.self, forKey: .event_id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        
        let _start_time = try container.decode(Int.self, forKey: .start_time)
        start_time = Date(timeIntervalSince1970: TimeInterval(_start_time))
        
        let _end_time = try container.decode(Int.self, forKey: .end_time)
        end_time = Date(timeIntervalSince1970: TimeInterval(_end_time))
        
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        address = try container.decode(String.self, forKey: .address)
        town_name = try container.decode(String.self, forKey: .town_name)
        organizer_id = try container.decode(Int.self, forKey: .organizer_id)
        
        let _created_at = try container.decode(Int.self, forKey: .created_at)
        created_at = Date(timeIntervalSince1970: TimeInterval(_created_at))
        let _updated_at = try container.decode(Int.self, forKey: .updated_at)
        updated_at = Date(timeIntervalSince1970: TimeInterval(_updated_at))
        attendees = try container.decode(Int.self, forKey: .attendees)
        max_attendees = try container.decode(Int.self, forKey: .max_attendees)
        ticket_price = try container.decode(Double.self, forKey: .ticket_price)
        category = try container.decode(String.self, forKey: .category)
        
     }
    
    func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           
            try container.encode(Int(start_time.timeIntervalSince1970), forKey: .start_time)
            try container.encode(Int(end_time.timeIntervalSince1970), forKey: .end_time)
            try container.encode(Int(created_at.timeIntervalSince1970), forKey: .created_at)
            try container.encode(Int(updated_at.timeIntervalSince1970), forKey: .updated_at)

           
           // Encode other fields
           try container.encode(event_id, forKey: .event_id)
           try container.encode(organizer_id, forKey: .organizer_id)
           try container.encode(max_attendees, forKey: .max_attendees)
           try container.encode(ticket_price, forKey: .ticket_price)
           try container.encode(latitude, forKey: .latitude)
           try container.encode(name, forKey: .name)
           try container.encode(address, forKey: .address)
           try container.encode(longitude, forKey: .longitude)
           try container.encode(attendees, forKey: .attendees)
           try container.encode(category, forKey: .category)
           try container.encode(town_name, forKey: .town_name)
           try container.encode(description, forKey: .description)
    }
}

struct Event {
    var event_id: Int
    var name: String
    var start_time: Date
    var address: String
    var town_name: String
    var attendees: Int
    var category: String
    
    var starttime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d h:mm a"  // "Wed, Jun 5 7:00 PM"
        return formatter.string(from: start_time)
    }
    
    func color(id: Int) -> Color {
        switch id {
            case 1: .red.opacity(0.7)
            case 2: .blue.opacity(0.7)
            case 3: .yellow.opacity(0.7)
            case 4: .blue.opacity(0.7)
            case 5: .gray.opacity(0.7)
            case 6: .green
            case 7: .brown
            case 8: .cyan
            case 9: .indigo
            case 10: .mint
            case 11: .orange
            case 12: .pink
            case 13: .purple
            case 14: .teal
            case 15: .random()
            case 16: .indigo
            case 17: .red
            case 18: .pink
            case 19: .yellow
            case 20: .red
            case 21: .brown
            case 22: .cyan
            default: .green.opacity(0.7)
        }
    }
    
      
}

extension Event: Codable {
    enum CodingKeys: String, CodingKey {
        case event_id
        case name
        case start_time
        case address
        case town_name
        case attendees
        case category
    }
    
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Supports "2024-02-17T12:34:56Z"
        return formatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        event_id = try container.decode(Int.self, forKey: .event_id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        town_name = try container.decode(String.self, forKey: .town_name)
        attendees = try container.decode(Int.self, forKey: .attendees)
        category = try container.decode(String.self, forKey: .category)
        let timestamp = try container.decode(Int.self, forKey: .start_time)
        start_time = Date(timeIntervalSince1970: TimeInterval(timestamp))
     }
}


struct EventRequest: Codable {
    var latitude: Double
    var longitude: Double
    var radius: Int
    var page: Int
    var limit: Int
    var category: String
    var sort_by: String
    
    
}
