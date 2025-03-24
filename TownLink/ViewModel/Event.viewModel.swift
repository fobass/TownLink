//
//  Event.viewModel.swift
//  TownLink
//
//  Created by Ernist Isabekov on 2/17/25.
//

import Foundation
import Combine

final class EventStore: ObservableObject {
    @Published var events: [Event] = []
    @Published var event_detail: EventDetail = .init()
    private var locationManager: LocationDataManager
    private var cancellable: AnyCancellable?
    @Published var isLocationAvailable = false
    @Published var event_attendees : [Atteener] = .init()
    init(locationManager: LocationDataManager) {
        self.events = [
            Event.init(event_id: 1, name: "Rock the City", start_time: Date.now, address: "Times Square, New York, NY", town_name: "New York", attendees: 2, category: "music"),
            Event.init(event_id: 2, name: "Food", start_time: Date.now, address: "st.Tok", town_name: "KL", attendees: 5, category: "music"),
            Event.init(event_id: 3, name: "Music", start_time: Date.now, address: "st.Tok", town_name: "KL", attendees: 2, category: "music"),
            Event.init(event_id: 4, name: "Food", start_time: Date.now, address: "st.Tok", town_name: "KL", attendees: 5, category: "music"),
            Event.init(event_id: 5, name: "Music", start_time: Date.now, address: "st.Tok", town_name: "KL", attendees: 2, category: "music"),
            Event.init(event_id: 6, name: "Food", start_time: Date.now, address: "st.Tok", town_name: "KL", attendees: 5, category: "music")
        ]
        
        self.event_detail = EventDetail.init(event_id: 1, name: "Rock the City", description: "A high-energy rock concert featuring top rock bands.", start_time: Date.now, end_time: Date.now, latitude: 0.2, longitude: 0.4, address: "Times Square, New York, NY", town_name: "New York", organizer_id: 1, created_at: Date.now, updated_at: Date.now, attendees: 4, max_attendees: 50, ticket_price: 44.5, category: "music")
        self.locationManager = locationManager
        
        cancellable = locationManager.$location
            .sink { [weak self] location in
                guard let self = self else { return }
                if let _ = location {
                    self.isLocationAvailable = true // Location is available
                    self.fetchEvents(category: "music", sortBy: "distance") // Fetch events when location is available
                } else {
                    self.isLocationAvailable = false // Location is still unavailable
                }
            }
    }
    
    
    func testPing() {
        guard let url = URL(string: "http://172.20.10.4:8080/ping") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Ping failed:", error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🛜 Ping HTTP Status:", httpResponse.statusCode)
            }
            
            if let data = data, let responseData = String(data: data, encoding: .utf8) {
                print("📦 Ping response:", responseData)
            }
        }.resume()
    }
    
    func getEventAttendees(with event_id: Int) {
        if let accessToken = getTokenFromKeychain()  {
            guard let url = URL(string: URL_END_POINT + "event/" + String(event_id) + "/attendees") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let authHeader = "Bearer \(accessToken)"
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                // Check for any error first
                if let error = error {
                    print("Request failed: \(error.localizedDescription)")
                    return
                }
                
                // Check if response is valid and check the status code
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        print("Error: Status code \(httpResponse.statusCode) indicates failure")
                        return
                    }
                }
                
                // Check for data
                guard let data = data else {
                    print("No data received from server")
                    return
                }
                
                // Try to decode the JSON response
                do {
                    let decodedResponse = try JSONDecoder().decode([Atteener].self, from: data)
                    DispatchQueue.main.async {
                        self.event_attendees = decodedResponse
                        print("event_attendees \(decodedResponse)")
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
                
            }.resume()
        }
    }
    
    func publishEvent(newEvent: EventDetail, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: URL_END_POINT + "event") else {
            print("❌ Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let jsonData = try encoder.encode(newEvent)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")
        } catch {
            print("❌ Failed to encode JSON:", error.localizedDescription)
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Request failed:", error.localizedDescription)
                completion(false)
                return
            }
            
           if let httpResponse = response as? HTTPURLResponse {
               print("🛜 HTTP Status:", httpResponse.statusCode)
               if httpResponse.statusCode == 200 {
                   completion(true) // Success
               } else {
                   print("❌ Server returned non-200 status code")
                   completion(false)
               }
           } else {
               completion(false)
           }
        }.resume()
    }
    
    func fetchEvents(radius: Int? = nil, page: Int? = nil, limit: Int? = nil, category: String, sortBy: String) {
        if !isLocationAvailable {
            print("Location is not available yet")
            return
        }
        if let accessToken = getTokenFromKeychain()  {
            guard let location = locationManager.location else {
                print("Location not available yet")
                return
            }
            
            guard var urlComponents = URLComponents(string: URL_END_POINT + "events") else { return }
            
            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
                URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
                URLQueryItem(name: "category", value: category),
                URLQueryItem(name: "sort_by", value: sortBy)
            ]
            
            if let r = radius { queryItems.append(URLQueryItem(name: "radius", value: String(r))) }
            if let p = page { queryItems.append(URLQueryItem(name: "page", value: String(p))) }
            if let l = limit { queryItems.append(URLQueryItem(name: "limit", value: String(l))) }
            
            
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let authHeader = "Bearer \(accessToken)"
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")

            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Request failed: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode([Event].self, from: data)
                    DispatchQueue.main.async {
                        self.events = decodedResponse
                        print("events : \(decodedResponse)")
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
            .resume()
        }
    }
    
    func getEventById(event_id: Int) {
        
        if let accessToken = getTokenFromKeychain()  {
            guard let url = URL(string: URL_END_POINT + "event/" + String(event_id)) else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let authHeader = "Bearer \(accessToken)"
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                // Check for any error first
                if let error = error {
                    print("Request failed: \(error.localizedDescription)")
                    return
                }
                
                // Check if response is valid and check the status code
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        print("Error: Status code \(httpResponse.statusCode) indicates failure")
                        return
                    }
                }
                
                // Check for data
                guard let data = data else {
                    print("No data received from server")
                    return
                }
                
                // Try to decode the JSON response
                do {
                    let decodedResponse = try JSONDecoder().decode(EventDetail.self, from: data)
                    DispatchQueue.main.async {
                        self.event_detail = decodedResponse
                        
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
                
            }.resume() // Don't forget to call .resume() to start the request!
        }
    }
    
    
    func setAttend(newAttend: Attend, completion: @escaping (Bool) -> Void ) {
        guard let url = URL(string: URL_END_POINT + "event/attend") else {
            print("❌ Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let jsonData = try encoder.encode(newAttend)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")
        } catch {
            print("❌ Failed to encode JSON:", error.localizedDescription)
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Request failed:", error.localizedDescription)
                completion(false)
                return
            }
            
           if let httpResponse = response as? HTTPURLResponse {
               print("🛜 HTTP Status:", httpResponse.statusCode)
               if httpResponse.statusCode == 200 {
                   completion(true) // Success
               } else {
                   print("❌ Server returned non-200 status code")
                   completion(false)
               }
           } else {
               completion(false)
           }
        }.resume()
    }

    
    
   
}
import CoreLocation
struct AddressSuggestion: Identifiable {
    let id = UUID()
    let address: String
    let latitude: Double
    let longitude: Double
    let town_name: String
}

class AddressSearchViewModel: ObservableObject {
    @Published var address: String = ""
    @Published var suggestions: [AddressSuggestion] = []
    @Published var showSuggestions: Bool = false
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    
    private let geocoder = CLGeocoder()

    func searchForAddress() {
        guard !address.isEmpty else {
            suggestions.removeAll()
            showSuggestions = false
            return
        }

        geocoder.geocodeAddressString(address) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    self.suggestions.removeAll()
                    self.showSuggestions = false
                } else {
                    self.suggestions = placemarks?.compactMap { placemark in
                        guard let location = placemark.location else { return nil }
                        
                        let name = placemark.name ?? ""                          // Name (e.g., "Apple Park")
                        let streetNumber = placemark.subThoroughfare ?? ""      // Street number
                        let streetName = placemark.thoroughfare ?? ""           // Street name
                        let city = placemark.locality ?? ""                     // City
                        let state = placemark.administrativeArea ?? ""          // State/Province
                        let zipCode = placemark.postalCode ?? ""                // ZIP Code
                        let country = placemark.country ?? ""                   // Country
                       
                       let formattedAddress = [
                           name,
                           "\(streetNumber) \(streetName)".trimmingCharacters(in: .whitespaces),
                           city,
                           state,
                           zipCode,
                           country
                       ].filter { !$0.isEmpty }.joined(separator: ", ")

                        return AddressSuggestion(
                            address: formattedAddress,
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude,
                            town_name: streetName
                        )
                    } ?? []
                    self.showSuggestions = !self.suggestions.isEmpty
                }
            }
        }
    }

    func selectAddress(_ selectedAddress: AddressSuggestion) {
        showSuggestions = false
        address = selectedAddress.address
        latitude = selectedAddress.latitude
        longitude = selectedAddress.longitude
        
        suggestions.removeAll()
        
    }
}
