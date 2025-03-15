//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Soban Shoaib on 2025-03-09.
//

import Foundation
import CoreLocation

//hold weather data will app will use
struct WeatherData {
    let locationName: String
    let temperature: Double
    let condition: String
}



//codable means swift will encode and decode json data into this struct. otherwise u have to write manual functions to do it.
struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather //this notation means a single nested object
    let weather: [Weather] //while this means one or more, array of nested objects
}
struct MainWeather: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = location.last else { return }
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
