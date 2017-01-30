//
//  ContributionCreator.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

public protocol ContributionCreator
{
    var user: String? {get}
    
    func createRambl(user: String,
                     date: Date,
                     localURL: URL?,
                     type: UploadMediaType,
                     latitude: Double,
                     longitude: Double,
                     locationName: String,
                     status: String) -> Rambl?
    
    func createChat(user: String,
                    date: Date,
                    localURL: URL?,
                    type: UploadMediaType,
                    ramblAuthor: String,
                    rambl: String) -> Chat?
    
    func createUploadable(localURL: URL,
                          path: String,
                          mediaType: UploadMediaType) -> Uploadable
}
