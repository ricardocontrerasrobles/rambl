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

class MainViewModel: BaseViewModel
{
    public var updateMap: UpdateMapBinding?
    public var audioPlayerStatus: AudioPlayerStatusBinding?
    private let audioRecorder = RamblLogicBridge.getAudioRecorder()
    private var audioPlayer = RamblLogicBridge.getAudioPlayer()
    private let persistor = RamblLogicBridge.getPersistor()
    private let uploader = RamblLogicBridge.getUploader()
    private let contributionCreator = RamblLogicBridge.getContributionCreator()
    private let locator = RamblLogicBridge.getLocator()
    private var latitude : Double  = 0.0
    private var longitude : Double  = 0.0
    private static let spanDelta : CLLocationDegrees = 0.001
    private var currentRambl: Rambl?
    
    override init()
    {
        super.init()
        setup()
    }
    
    func startRecording()
    {
        audioRecorder.start()
    }
    
    func stopRecording()
    {
        audioRecorder.stop { [weak self] (localURL) in
            guard let localURL = localURL else
            {
                return
            }
            self?.save(localURL: localURL, type: .Audio)
        }
    }
    
    func play(rambl: Rambl)
    {
        if let url = URL(string: uploader.uploadableURL(uploadable: rambl))
        {
            currentRambl = rambl
            audioPlayer.audioPlayerStatus = audioPlayerStatus
            audioPlayer.play(url: url)
        }
    }
    
    func getRamblChatViewModel() -> ChatViewModel?
    {
        guard let currentRambl = currentRambl else
        {
            return nil
        }
        let chatViewModel = RamblChatViewModel(rambl: currentRambl,
                                               audioRecorder: audioRecorder,
                                               audioPlayer: audioPlayer,
                                               persistor: persistor,
                                               uploader: uploader,
                                               contributionCreator: contributionCreator)
        return chatViewModel
    }
    
    func getSettingsViewModel() -> SettingsViewModel?
    {
        let settingsViewModel = SettingsViewModel(uploader: uploader, contributionCreator: contributionCreator)
        return settingsViewModel
    }
    
    func userImageURL(rambl: Rambl) -> String
    {
        return uploader.userImageURL(user: rambl.user)
    }
    
    private func setup()
    {
        locator.getLocation{ [weak self] (newLatitude, newLongitude, error) in
            if let error = error
            {
                print(error)
            }
            else
            {
                self?.locationChanged(newLatitude: newLatitude, newLongitude: newLongitude)
            }
        }
    }
    
    private func locationChanged(newLatitude: Double, newLongitude: Double)
    {
        guard latitude != newLatitude || longitude != newLongitude  else
        {
            return
        }
        latitude = newLatitude
        longitude = newLongitude
        self.regionChanged(region: getRegion(latitude: latitude, longitude: longitude))
    }
    
    private func regionChanged(region: MKCoordinateRegion)
    {
        self.persistor.getRambls(latitude: latitude, longitude: longitude, completion: { [weak self] (rambls, error) in
            self?.updateMap?(region, rambls)
        })
    }
    
    private func save(localURL: URL, type: UploadMediaType)
    {
        guard let user = contributionCreator.user else
        {
            return
        }
        if let rambl = contributionCreator.createRambl(user: user,
                                                       date: Date(),
                                                       localURL: localURL,
                                                       type: .Audio,
                                                       latitude: latitude,
                                                       longitude: longitude,
                                                       locationName: locator.getLocationName(),
                                                       status: SettingsViewModel.getStatus())
        {
            persistor.save(rambl: rambl, uploader: uploader)
        }
    }
    
    private func getRegion(latitude : Double, longitude : Double) -> MKCoordinateRegion
    {
        var region = MKCoordinateRegion()
        region.center.latitude = latitude
        region.center.longitude = longitude
        region.span.latitudeDelta = MainViewModel.spanDelta
        region.span.longitudeDelta = MainViewModel.spanDelta
        return region
    }
}
