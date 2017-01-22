//
//  CoreLocationLocator.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation
import CoreLocation

internal class CoreLocationLocator : NSObject, Locator
{
    internal var binding: LocatorBinding?
    internal var locationManager: CLLocationManager?
    internal let geocoder = CLGeocoder()
    internal var locationName: String = "Somewhere"
    
    func getLocation(binding: @escaping LocatorBinding)
    {
        if locationManager == nil
        {
            setup()
        }
        
        self.binding = binding
    }
    
    func getLocationName() -> String
    {
        return locationName
    }
}

extension CoreLocationLocator : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last
        {
            let latitude : Double = location.coordinate.latitude
            let longitude : Double = location.coordinate.longitude
            binding?(latitude, longitude, nil)
            updateLocationName(location: location)
        }
    }
}

private extension CoreLocationLocator
{
    func setup()
    {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 100
        locationManager?.startUpdatingLocation()
        locationManager?.requestAlwaysAuthorization()
    }
    
    func updateLocationName(location: CLLocation)
    {
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?[0], error == nil else
            {
                return
            }
            if let name = placemark.name
            {
                self?.locationName = name
            }
            else if let subLocality = placemark.subLocality
            {
                self?.locationName = subLocality
            }
            else if let locality = placemark.locality
            {
                self?.locationName = locality
            }
        }
    }
}
