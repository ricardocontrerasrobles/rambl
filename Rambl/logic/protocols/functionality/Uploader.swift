//
//  Uploader.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public typealias UploaderCompletion = (Contribution, URL?, Error?) -> Void

internal protocol Uploader
{
    func upload(contribution: Contribution, completion: @escaping UploaderCompletion)
    func getURL() -> String
}
