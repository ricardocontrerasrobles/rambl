//
//  Uploader.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation
import UIKit

public typealias UploaderCompletion = (Uploadable, String?, Error?) -> Void

internal protocol Uploader
{
    func upload(uploadable: Uploadable, completion: @escaping UploaderCompletion)
    func uploadableURL(uploadable: Uploadable) -> String
    func userImageURL(user: String) -> String
}
