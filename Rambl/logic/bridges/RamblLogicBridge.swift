//
//  RamblLogicBridge.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/21/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

class RamblLogicBridge
{
    static func getAudioPlayer() -> AudioPlayer
    {
        return AVFoundationAudioPlayer()
    }
    
    static func getAudioRecorder() -> AudioRecorder
    {
        return AVFoundationAudioRecorder()
    }
    
    static func getLocator() -> Locator
    {
        return CoreLocationLocator()
    }
    
    static func getPersistor() -> Persistor
    {
        return FireBasePersistor()
    }
    
    static func getUploader() -> Uploader
    {
        return AWSS3Uploader()
    }
}
