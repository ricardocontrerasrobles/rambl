//
//  MainViewModel.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/14/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation
import MapKit

typealias UpdateMapBinding = (MKCoordinateRegion, [Rambl]?) -> Void

class MainViewModel
{
    public var updateMap: UpdateMapBinding?
    public var statusBinding: AudioPlayerStatusBinding?
    let locator = RamblLogicBridge.getLocator()
    let audioRecorder = RamblLogicBridge.getAudioRecorder()
    var audioPlayer = RamblLogicBridge.getAudioPlayer()
    let persistor = RamblLogicBridge.getPersistor()
    let uploader = RamblLogicBridge.getUploader()
    var latitude : Double  = 0.0
    var longitude : Double  = 0.0
    
    internal let spanDelta : CLLocationDegrees = 0.001
    
    init()
    {
        setup()
    }
    
    func startRecording()
    {
        audioRecorder.start()
    }
    
    func stopRecording()
    {
        audioRecorder.stop { [weak self] (url) in
            guard let url = url else
            {
                return
            }
            self?.save(localURL: url, type: .Audio)
        }
    }
    
    func play(contribution: Contribution)
    {
        if let url = URL(string: uploader.getURL() + "/" + contribution.path)
        {
            audioPlayer.statusBinding = statusBinding
            audioPlayer.play(url: url)
        }
    }
}

private extension MainViewModel
{
    func setup()
    {
        locator.getLocation{ [weak self] (latitude, longitude, error) in
            if self?.longitude != longitude && self?.longitude != longitude
            {
                self?.latitude = latitude
                self?.longitude = longitude
                if let region = self?.getRegion(latitude: latitude, longitude: longitude)
                {
                    self?.persistor.getRambls(latitude: latitude, longitude: longitude, completion: { [weak self] (rambls, error) in
                        self?.updateMap?(region, rambls)
                    })
                }
            }
        }
    }
    
    func save(localURL: URL, type: ContributionMediaType)
    {
        // TODO: Get location name from reverse geocoding
        persistor.saveRambl(localURL: localURL,
                            uploader: uploader,
                            type: .Audio,
                            latitude: latitude,
                            longitude: longitude,
                            locationName: locator.getLocationName(),
                            status: "I'm rambling") { (error) in
                                if let error = error
                                {
                                    print(error)
                                }
        }
    }
    
    func getRegion(latitude : Double, longitude : Double) -> MKCoordinateRegion
    {
        var region = MKCoordinateRegion()
        region.center.latitude = latitude
        region.center.longitude = longitude
        region.span.latitudeDelta = spanDelta
        region.span.longitudeDelta = spanDelta
        return region
    }
}
