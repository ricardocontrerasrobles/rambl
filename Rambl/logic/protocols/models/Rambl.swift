//
//  Rambl.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public protocol Rambl : Contribution
{
    var latitude:Double {get}
    var longitude:Double {get}
    var geohash:String {get}
    var locationName:String {get}
    var status:String {get}
}
