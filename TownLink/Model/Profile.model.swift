//
//  User.model.swift
//  TownLink
//
//  Created by Ernist Isabekov on 1/8/25.
//

import Foundation

enum AuthState {
    case loggedIn
    case guest
    case unauthenticated
    case inProccess
}

struct Atteener {
    var profile_id: Int
    var first_name: String
    var phone_number: String
    var email: String
    var date_joined: Date
    var is_verified: Bool
    var about: String
    var photo_url: String
}

extension Atteener: Codable {
    enum CodingKeys: String, CodingKey {
        case profile_id
        case first_name
        case phone_number, email
        case is_verified
        case about, date_joined
        case photo_url
    }
}

struct Profile {
    var profile_id: Int
    var first_name, last_name, pwd: String
    var gender: Int
    var phone_number, email: String
    var date_of_birth: Date
    var photo_url: String
    var emergency_contact: Int
    var is_active, is_verified: Bool
    var verified_doc_id: Int
    var about: String
    var date_joined: Date
    var score: Int
    var lat, lon: Double
    var comments_id: Int
    
//    var provider: String //"google" or "facebook"
//    var provider_id: String //Google/Facebook user ID
//    var last_login: Date
    
    var DisplayGreetingName : String {
        get {
            if (!first_name.isEmpty) {
                return "Hi I'm, " + self.first_name
            } else {
                return ""
            }
        }
    }

}

extension Profile: Codable {
    enum CodingKeys: String, CodingKey {
        case profile_id
        case first_name, last_name, pwd
        case gender, phone_number, date_of_birth, email
        case photo_url
        case emergency_contact, is_active, is_verified, verified_doc_id
        case about, date_joined
        case score
        case lat, lon
        case comments_id
//        case provider
//        case provider_id
//        case last_login
    }
}


struct Claims: Decodable{
    var access_token: String
    var username: String
    var user_id: Int
}


