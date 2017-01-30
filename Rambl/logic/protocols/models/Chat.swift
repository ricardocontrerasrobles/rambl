//
//  Chat.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public protocol Chat : Contribution
{
    var ramblAuthor:String {get}
    var rambl:String {get}
}
