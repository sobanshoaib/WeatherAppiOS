//
//  ContentView.swift
//  WeatherApp
//
//  Created by Soban Shoaib on 2025-03-06.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State private var isNight = false
    
    @StateObject private var locationManage = LocationManager()
    @State private var weatherData: WeatherData?
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: isNight)
            VStack {
//                CityTextView(cityName: "\(weatherData?.locationName)")
                CityTextView(cityName: "Edmonton")
                MainWeatherStatusView(imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill", temperature: 10)

                HStack(spacing: 30) {
                        WeatherDayView(dayOfWeek: "WED", ImageName: "cloud.sun.fill", temperature: 8)
                        WeatherDayView(dayOfWeek: "THU", ImageName: "sun.max.fill", temperature: 18)
                        WeatherDayView(dayOfWeek: "FRI", ImageName: "wind.snow", temperature: 2)
                        WeatherDayView(dayOfWeek: "SAT", ImageName: "sunset.fill", temperature: 4)
                        WeatherDayView(dayOfWeek: "SUN", ImageName: "snow", temperature: -12)

                }
                
                Spacer()
                
                Button {
                    isNight.toggle()
                    print("Changed background")
                } label: {
                    WeatherButton(title: "Change Day Time", textColour: .blue, backgroundColour: .white)
                }
                
                Spacer()
            }
        }
    }
    
    private func fetchWeatherData(_ location: CLLocation) { //CLLocation is built in framework; a class; has info like langitude, longitude, timestamp, and more
        let apiKey = "apikey"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return } //guard let means if it fails, the else clause is triggered
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    weatherData = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, condition: weatherResponse.weather.first?.description ?? "")
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var ImageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: ImageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
            
        }
    }
}

struct BackgroundView: View {
    
    var isNight: Bool
    
    
    var body: some View {
        
        LinearGradient(colors: [isNight ? .black : .blue, isNight ? .gray: Color("lightBlue")],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea()
    }
}


struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}


