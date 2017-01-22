//
//  AudioRecorder.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public typealias AudioRecorderCompletion = (URL?) -> Void

internal protocol AudioRecorder
{
    func setup()
    func start()
    func stop(completion: AudioRecorderCompletion)
}
