//
//  LocationDataManager.swift
//  TownLink
//
//  Created by Ernist Isabekov on 2/17/25.
//

import Foundation
import CoreLocation
import Combine

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    @Published var townName: String = "Unknown"
    private var lastUpdatedLocation: CLLocation? = nil
    @Published var isLocationReady: Bool = false  // Flag to track if location is ready
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100  // Only update if moved 100 meters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        // Only update if user has moved 100m or more
        if let lastLocation = lastUpdatedLocation {
            let distance = lastLocation.distance(from: newLocation)
            if distance < 100 { return }  // Ignore minor movements
        }
        
        lastUpdatedLocation = newLocation
        DispatchQueue.main.async {
            self.location = newLocation
            self.isLocationReady = true  // Location is now available
            self.reverseGeocode(location: newLocation)
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                self.townName = placemark.locality ?? "Unknown"
            }
        }
    }
}
