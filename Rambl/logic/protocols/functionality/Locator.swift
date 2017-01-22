//
//  Locator.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public typealias LocatorBinding = (Double, Double, Error?) -> Void

internal protocol Locator
{
    func getLocation(binding: @escaping LocatorBinding)
    func getLocationName() -> String
}
