//
//  FireBasePersistor.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation
import Firebase

internal class FireBasePersistor : Persistor
{
    internal lazy var reference: FIRDatabaseReference =
    {
        return FIRDatabase.database().reference()
    }()

    private static let ramblsKey = "rambls"
    private static let chatsKey = "chats"
    private static let geohashKey = "geohash"
    
    func setup()
    {
    }
    
    func getRambls(latitude: Double, longitude: Double, completion: @escaping PersistorRamblCompletion)
    {
        let geohash = Geohash.encode(latitude: latitude, longitude: longitude)
        //        let closeRamblsQuery = (ref?.child("rambls").queryLimited(toFirst: 100))!
        
        //        let closeRamblsQuery = (ref?.child("rambls").queryOrdered(byChild: "latitude").queryStarting(atValue: "28.37862").queryEnding(atValue: "28.37864"))!
        //        closeRamblsQuery = (ref?.child("rambls").queryOrdered(byChild: "longitude").queryStarting(atValue: "-81.549605").queryEnding(atValue: "-81.549606"))!
        
        // TODO: geohashes might return squares/rectangles so we will have trouble when user is at the edge.
        // We need to query the adjacents rectangles so a larger query might br needed.
        // Right now precision is 5. Maybe search by the first four.
        // We might need to change the precision to avoid bringing a lot of rambls.
        let closeRamblsQuery = (reference.child(FireBasePersistor.ramblsKey).queryOrdered(byChild: FireBasePersistor.geohashKey).queryEqual(toValue:geohash))
        
        closeRamblsQuery.observe(.value, with: { (snapshot) -> Void in
            if !snapshot.hasChildren() {
                completion(nil, nil)
                return
            }
            
            var allRambls = [Rambl]()
            let rambls = snapshot.value as! [String:[String:String]]
            for key in rambls.keys {
                if let ramblDict = rambls[key], let rambl = RamblImplementor.fromDict(ramblDict: ramblDict)
                {
                    allRambls.append(rambl)
                }
            }
            completion(allRambls, nil)
        })
        
        // TODO: Callbacks are removed by calling the off() method on your Firebase database reference.
        
    }
    
    func getRambls(user: String, completion: PersistorRamblCompletion)
    {
        // TODO: Get Rambls
    }
    
    func getChats(rambl: Rambl, completion: @escaping PersistorChatCompletion)
    {
        let user = ContributionCreatorImplementor().user ?? ""
        
        // TODO: Should also do the opposite query (toValue:user + "_" + rambl.user )
        let chatsQuery = (reference.child(FireBasePersistor.chatsKey)
            .queryOrdered(byChild: "id").queryEqual(toValue:rambl.user + "_" + user)
        )
        chatsQuery.observe(.value, with: { (snapshot) -> Void in
            if !snapshot.hasChildren() {
                completion(nil, nil)
                return
            }
            
            var allChats = [Chat]()
            let chats = snapshot.value as! [String:[String:String]]
            for key in chats.keys {
                if let chatDict = chats[key], let chat = ChatImplementor.fromDict(chatDict: chatDict)
                {
                    allChats.append(chat)
                }
            }
            completion(allChats, nil)
        })
    }
    
    func getChats(user: String, completion: PersistorChatCompletion)
    {
        
    }
    
    func save(rambl: Rambl, uploader: Uploader)
    {
        save(contribution: rambl, uploader: uploader, key: FireBasePersistor.ramblsKey)
    }
    
    func save(chat: Chat, uploader: Uploader)
    {
        save(contribution: chat, uploader: uploader, key: FireBasePersistor.chatsKey)
    }
}

private extension FireBasePersistor
{
    func save(contribution: Contribution, uploader: Uploader, key: String)
    {
        uploader.upload(uploadable: contribution) { [weak self] (uploadable, webURL, error) in
            guard webURL != nil else
            {
                return
            }
            self?.reference.child(key).child(contribution.id).setValue(contribution.toDict())
        }
    }
}
