//
//  Persistor.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation

public typealias PersistorRamblCompletion = ([Rambl]?, Error?) -> Void
public typealias PersistorChatCompletion = ([Chat]?, Error?) -> Void
public typealias PersistorSimpleCompletion = (Error?) -> Void

internal protocol Persistor
{
    func setup()
    func getRambls(latitude: Double, longitude: Double, completion: @escaping PersistorRamblCompletion)
    func getRambls(user: String, completion: PersistorRamblCompletion)
    func getChats(rambl: Rambl, completion: PersistorChatCompletion)
    func saveRambl(localURL: URL,
                   uploader: Uploader,
                   type: ContributionMediaType,
                   latitude: Double,
                   longitude: Double,
                   locationName: String,
                   status: String,
                   completion: PersistorSimpleCompletion)
}
