//
//  DetailVCViewController.swift
//  WeatherGift
//
//  Created by Nick on 3/20/17.
//  Copyright © 2017 Nick Ryan. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVCViewController: UIViewController {
    
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if currentPage == 0 {
            getLocation()
        }
        locationsArray[currentPage].getWeather {
            self.updateUserInterface()
        }
    }
    func updateUserInterface() {
        let isHidden = (locationsArray[currentPage].currentTemp == -999.9)
        
        temperatureLabel.isHidden = isHidden
        locationLabel.isHidden = isHidden
        
        
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        var curTemperature = String(format: "%3.f", locationsArray[currentPage].currentTemp) + "°"
        temperatureLabel.text = curTemperature
        print("%%% curTemperature inside updateUserInterface = \(curTemperature)")
        summaryLabel.text = locationsArray[currentPage].weatherSummary
        currentImage.image = UIImage(named: locationsArray[currentPage].currentIcon)
    }
    
}

extension DetailVCViewController: CLLocationManagerDelegate {
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            print("I'm sorry, location settings are turned off for this application")
        case .restricted:
            print("Location settings are likely restricted")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentPage == 0 {
            let geoCoder = CLGeocoder()
            var place = ""
            var currentLocation = locations.last
            let currentLat = "\(currentLocation!.coordinate.latitude)"
            let currentLong = "\(currentLocation!.coordinate.longitude)"
            print("Your coordinates are: " + currentLat + "," + currentLong)
            geoCoder.reverseGeocodeLocation(currentLocation!, completionHandler: {placemarks,
                error in
                if placemarks != nil {
                    var placemark = placemarks!.last
                    place = (placemark?.name)!
                    self.locationsArray[0].name = place
                    self.locationsArray[0].coordinates = currentLat + "," + currentLong
                    
                } else {
                    print("Error receiving current location")
                    place = "Parts Unknown"
                }
                print(place)
                self.locationsArray[0].getWeather {
                    self.updateUserInterface()
                }
            })}
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
