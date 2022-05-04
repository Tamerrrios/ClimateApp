//
//  WeatherManager.swift
//  Clima
//
//  Created by Temur Juraev on 23.04.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(with error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=877f2a92fba9a7ce047cc85b14ca50b2&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    //MARK: (NETWORKING) Creating func with networking for requesting Data from web server
    //MARK: 4 Steps for crearing NETWORKING REQUEST
    //MARK: 1. Create URL, 2. Create a URL Session, 3. Give URLSession a task, 4.Start a task
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(with: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather =  self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
            
        }
        
    }
    //MARK: - Парсим JSON
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decorder = JSONDecoder()
        do {
            let decodedData =  try decorder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(with: error)
            return nil
        }
    }
    
    
}
