//
//  ContributionCreatorImplementor.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation
import UIKit

internal struct ContributionCreatorImplementor : ContributionCreator
{
    var user = UIDevice.current.identifierForVendor?.uuidString
    
    func createRambl(user: String,
                     date: Date,
                     localURL: URL?,
                     type: UploadMediaType,
                     latitude: Double,
                     longitude: Double,
                     locationName: String,
                     status: String) -> Rambl?
    {
        let rambl = RamblImplementor(user: user, date: date, mediaType: type, localURL: localURL, latitude: latitude, longitude: longitude, locationName: locationName, status: status)
        return rambl
    }
    
    func createChat(user: String,
                    date: Date,
                    localURL: URL?,
                    type: UploadMediaType,
                    ramblAuthor: String,
                    rambl: String) -> Chat?
    {
        let chat = ChatImplementor(to: ramblAuthor, user: user, date: date, mediaType: type, localURL: localURL)
        return chat
    }
    
    func createUploadable(localURL: URL,
                          path: String,
                          mediaType: UploadMediaType) -> Uploadable
    {
        let uploadable = UploadableImplementor(mediaType: mediaType, path: path, localURL: localURL)
        return uploadable
    }
}
