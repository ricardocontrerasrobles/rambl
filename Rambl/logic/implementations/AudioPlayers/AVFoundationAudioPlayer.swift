//
//  AVFoundationAudioPlayer.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation
import AVFoundation

internal class AVFoundationAudioPlayer : AudioPlayer
{
    public var audioPlayerStatus: AudioPlayerStatusBinding?
    private var player : AVPlayer?
    
    func play(url: URL)
    {
        audioPlayerStatus = nil
        player = nil
        audioPlayerStatus?(.Loading)
        let playerItem = AVPlayerItem(url:url)
        player = AVPlayer(playerItem:playerItem)
        player?.volume = 1.0
        player?.play()
        let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { [weak self] time in
            print("Playing: \(time.seconds)")
            if time.seconds == 0
            {
                self?.audioPlayerStatus?(.Loading)
            }
            else if time.seconds >= playerItem.duration.seconds
            {
                self?.audioPlayerStatus?(.Finished)
                self?.player = nil
            }
            else
            {
                self?.audioPlayerStatus?(.Playing)
            }
        }
    }
}
