//
//  WeatherData.swift
//  Clima
//
//  Created by Temur Juraev on 24.04.2022.
//

import Foundation


struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let pressure: Int
}

struct Weather: Codable   {
    let description: String
    let id: Int
}

