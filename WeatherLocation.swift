//
//  WeatherLocation.swift
//  
//
//  Created by Nick on 3/27/17.
//
//

import Foundation
import Alamofire

class WeatherLocation {
    var name = ""
    var coordinates = ""
    
    func getWeather() {
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        Alamofire.request(weatherURL).responseJSON { response in
            print(response)
        }
    }
}
