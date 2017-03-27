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
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
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
        let geoCoder = CLGeocoder
        var currentLocation = locations.last
        let currentLat = "\(currentLocation!.coordinate.latitude)"
        let currentLong = "\(currentLocation!.coordinate.longitude)"
        print("Your coordinates are: " + currentLat + currentLong)
        locationManager.stopUpdatingLocation()
        geoCoder.reverseGeocodeLocation(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
