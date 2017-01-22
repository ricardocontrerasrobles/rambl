//
//  Contribution.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public enum ContributionMediaType : String
{
    case Audio = "audio"
    case Video = "video"
    case Image = "image"
}

extension ContributionMediaType
{
    func getExtension() -> String
    {
        switch self
        {
        case .Audio:
            return ".m4a"
        case .Video:
            return ".mov"
        case .Image:
            return ".png"
        }
    }
}

public protocol Contribution
{
    var id:String { get }
    var path:String { get }
    var user:String {get}
    var date:Date {get}
    var mediaType:ContributionMediaType {get}
    var localURL:URL? {get}
}
