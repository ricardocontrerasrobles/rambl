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

internal protocol Persistor
{
    func setup()
    func getRambls(latitude: Double, longitude: Double, completion: @escaping PersistorRamblCompletion)
    func getRambls(user: String, completion: PersistorRamblCompletion)
    func getChats(rambl: Rambl, completion: @escaping PersistorChatCompletion)
    func getChats(user: String, completion: PersistorChatCompletion)
    func save(rambl: Rambl, uploader: Uploader)
    func save(chat: Chat, uploader: Uploader)
}
