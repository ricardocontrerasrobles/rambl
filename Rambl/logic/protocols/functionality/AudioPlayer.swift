//
//  AudioPlayer.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public typealias AudioPlayerStatusBinding = (AudioPlayerStatus) -> Void

public enum AudioPlayerStatus
{
    case Loading
    case Playing
    case Finished
}

public protocol AudioPlayer
{
    var statusBinding: AudioPlayerStatusBinding? {get set}
    func play(url: URL)
}
