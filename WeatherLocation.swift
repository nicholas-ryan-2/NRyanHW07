//
//  WeatherLocation.swift
//  
//
//  Created by Nick on 3/27/17.
//
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = -999.9
    var weatherSummary = ""
    var currentIcon = ""
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print(temperature)
                    self.currentTemp = temperature
                } else {
                    print("Error")
                }
                if let summary = json["daily"]["summary"].string {
                    print(summary)
                    self.weatherSummary = summary
                } else {
                    print("Error")
                }
                if let icon = json["currently"]["icon"].string {
                    print(icon)
                    self.currentIcon = icon
                } else {
                    print("Error")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
