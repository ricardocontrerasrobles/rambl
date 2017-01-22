//
//  AVFoundationAudioRecorder.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation
import AVFoundation

internal class AVFoundationAudioRecorder : NSObject, AudioRecorder
{
    private var recorder:AVAudioRecorder?
    internal var session:AVAudioSession?
    internal var allowedToRecord:Bool = true
    internal var canRecord:Bool = true
    private var recordingUrl:URL?
    let extensionString = ".m4a"
    let dateFormatterString = "yyyy-mm-dd-hh-mm-ss"
    let formatter = DateFormatter()
    private let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    override init ()
    {
        super.init()
        setup()
    }
    
    func setup()
    {
        formatter.dateFormat = dateFormatterString
        setupAudioSession()
    }
    
    func start()
    {
        setupAudioSession()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let fullPath = documentsDirectory + "/" + uniqueString() + extensionString
        recordingUrl = URL(fileURLWithPath: fullPath)
        if let url = recordingUrl {
            
            do {
                recorder = try AVAudioRecorder(url: url, settings: settings)
                recorder?.delegate = self
                recorder?.isMeteringEnabled = true
                recorder?.prepareToRecord()
                recorder?.record()
                
            } catch {
                canRecord = false
            }
        }
    }
    
    func stop(completion: AudioRecorderCompletion)
    {
        recorder?.stop()
        
        guard allowedToRecord, canRecord else
        {
            completion(nil)
            return
        }
        completion(recordingUrl)
    }
}

private extension AVFoundationAudioRecorder
{
    func setupAudioSession()
    {
        session = AVAudioSession.sharedInstance()
        session?.requestRecordPermission() { [weak self] (allowed: Bool) -> Void in
            DispatchQueue.main.async {
                self?.allowedToRecord = allowed
            }
        }
        
        do {
            try session?.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session?.setActive(true)
            
            
        } catch {
            canRecord = false
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func uniqueString() -> String
    {
        return formatter.string(from: Date())
    }
}

extension AVFoundationAudioRecorder : AVAudioRecorderDelegate
{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag {
            canRecord = false
        }
    }
    
}
