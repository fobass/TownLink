//
//  User.viewModel.swift
//  TownLink
//
//  Created by Ernist Isabekov on 1/8/25.
//

import Foundation
import Security

func decodeJWT(_ jwt: String) -> [String: Any]? {
    let segments = jwt.split(separator: ".")
    guard segments.count == 3,
          let payloadData = base64UrlDecode(String(segments[1])) else {
        return nil
    }

    let json = try? JSONSerialization.jsonObject(with: payloadData, options: [])
    return json as? [String: Any]
}

func base64UrlDecode(_ value: String) -> Data? {
    var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    
    let length = Double(base64.lengthOfBytes(using: .utf8))
    let requiredLength = 4 * ceil(length / 4.0)
    let paddingLength = requiredLength - length
    if paddingLength > 0 {
        base64 += String(repeating: "=", count: Int(paddingLength))
    }
    
    return Data(base64Encoded: base64)
}

func getTokenFromKeychain() -> String? {
    let keychainQuery: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "access_token",
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var dataTypeRef: AnyObject?
    if SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef) == noErr,
       let data = dataTypeRef as? Data,
       let token = String(data: data, encoding: .utf8) {
        return token
    }
    return nil
}

func getUserData() -> (username: String?, userId: Int?) {
    let username = UserDefaults.standard.string(forKey: "username")
    let userId = UserDefaults.standard.integer(forKey: "user_id")
    return (username, userId == 0 ? nil : userId)
}

final class AuthManager: ObservableObject {
    @Published var authState: AuthState = .unauthenticated
    @Published var isCheckingAuth: Bool = false
    
    init(){
//        self.checkAuthentication()
    }
    
    func logoutUser() {
        // Remove access_token from Keychain
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "access_token"
        ]
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Remove user data from UserDefaults
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.synchronize()  // Ensure changes are saved immediately

        print("User logged out successfully.")
        DispatchQueue.main.async {
            self.authState = .unauthenticated
        }
    }
    
    
    func isLoggedIn() -> Bool {
        return authState == .loggedIn
    }
    
    func loginWithSocial(provider: String, accessToken: String, lat: Double = 0.0, lon: Double = 0.0, completion: @escaping (Result<Bool, Error>) -> Void) {
        let urlString = URL_END_POINT + "login"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let queryItems = [
            URLQueryItem(name: "provider", value: provider),
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon))
        ]
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        request.url = components.url
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let claims = try JSONDecoder().decode(Claims.self, from: data)
                self.saveToKeychain(token: claims.access_token)
                self.saveToUserDefaults(username: claims.username, userId: claims.user_id)
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func saveToKeychain(token: String) {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "access_token",
            kSecValueData as String: token.data(using: .utf8)!
        ]
        
        SecItemDelete(keychainQuery as CFDictionary) // Remove old token if exists
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    func saveToUserDefaults(username: String, userId: Int) {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(userId, forKey: "user_id")
    }
    
    

   
    
    func isTokenValid(_ token: String) -> Bool {
       guard let payload = decodeJWT(token),
             let exp = payload["exp"] as? TimeInterval else {
           return false
       }
       
       let expirationDate = Date(timeIntervalSince1970: exp) // Get expiration date
       
       // Debug print to check formatted date for logs
       let dateFormatter = DateFormatter()
       dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Ensure using UTC
       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       let formattedDate = dateFormatter.string(from: expirationDate)
       print("Formatted expiration date: \(formattedDate)")

       // Compare expiration date with current date
       return expirationDate > Date()
   }
    
    func checkAuthentication() {
        
       isCheckingAuth = true
       DispatchQueue.global(qos: .background).async {
//           self.authState = .inProccess
           if let token = getTokenFromKeychain() {
               if self.isTokenValid(token) {
                   DispatchQueue.main.async {
                       self.authState = .loggedIn
                       self.isCheckingAuth = false
                   }
               } else {
                   DispatchQueue.main.async {
                       self.authState = .guest
                       self.isCheckingAuth = false
                   }
               }
           } else {
               DispatchQueue.main.async {
                   self.authState = .unauthenticated
                   self.isCheckingAuth = false
               }
           }
       }
   }
    
}


final class ProfileStore: ObservableObject {
    @Published var profile: Profile = Profile.init(profile_id: -1, first_name: "Test", last_name: "Test", pwd: "", gender: 0, phone_number: "", email: "", date_of_birth: Date(), photo_url: "", emergency_contact: 0, is_active: true, is_verified: true, verified_doc_id: 0, about: "", date_joined: Date(), score: 0, lat: 0, lon: 0, comments_id: 0)
    @Published var isChaged: Bool = false
    
    
    init(){
        getById(with: -1)
    }
    
    func updateProfile(profile: Profile) {
        self.profile = profile
    }

    
    func getById(with userId: Int) {
        
        let finalUserId: Int
        if userId == -1 {
            if let storedUserId = getUserData().userId {
                finalUserId = storedUserId
            } else {
                print("No stored user ID found")
                return
            }
        } else {
            finalUserId = userId
        }
                
        if let accessToken = getTokenFromKeychain()  {
            let urlString = URL_END_POINT + "profile/" + String(finalUserId)
            print("urlString \(urlString)")
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let authHeader = "Bearer \(accessToken)"
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")

            request.httpBody = nil
            print("accessToken \(accessToken)")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                   print("Error making request: \(error)")
                   return
               }
               
               if let httpResponse = response as? HTTPURLResponse {
                   print("Response status code: \(httpResponse.statusCode)")
                   if httpResponse.statusCode != 200 {
                       print("Failed with status code: \(httpResponse.statusCode)")
                       return
                   }
               }
               
               guard let data = data else {
                   print("No data received")
                   return
               }

               do {
                   let decodedData = try JSONDecoder().decode(Profile.self, from: data)
                   DispatchQueue.main.async {
                       self.profile = decodedData
                   }
               } catch {
                   print("Failed to decode response: \(error)")
               }
            }.resume()
            
        }
    }
}
