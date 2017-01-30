//
//  Contribution.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public protocol Contribution: Uploadable
{
    var id:String { get }
    var user:String { get }
    var date:Date { get }
    
    func toDict() -> [String:String]?
}
