//
//  Uploadable.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

public enum UploadMediaType : String
{
    case Audio = "audio"
    case Video = "video"
    case Image = "image"
}

extension UploadMediaType
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
            return ".jpg"
        }
    }
}

public protocol Uploadable
{
    var localURL: URL? { get }
    var path: String { get }
    var mediaType: UploadMediaType { get }
}
