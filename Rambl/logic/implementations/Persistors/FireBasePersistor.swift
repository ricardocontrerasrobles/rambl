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
    private lazy var reference: FIRDatabaseReference = 
    {
        return FIRDatabase.database().reference()
    }()
    static private let user = UIDevice.current.identifierForVendor?.uuidString
    private static let ramblsKey = "rambls"
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
        
    }
    
    func getRambls(user: String, completion: PersistorRamblCompletion)
    {
        // TODO: Get Rambls
    }
    
    func getChats(rambl: Rambl, completion: PersistorChatCompletion)
    {
        // TODO: Get chats
    }
    
    func saveRambl(localURL:URL, uploader: Uploader, type: ContributionMediaType, latitude:Double, longitude:Double, locationName:String, status: String, completion: PersistorSimpleCompletion)
    {
        guard let user = FireBasePersistor.user else
        {
            completion(nil)
            return
        }
        
        // TODO: Should we have a status?
        let rambl = RamblImplementor(user: user,
                                     date: Date(),
                                     mediaType: type,
                                     localURL: localURL,
                                     latitude: latitude,
                                     longitude: longitude,
                                     locationName: locationName,
                                     status: status)
        uploader.upload(contribution: rambl) { [weak self] (contribution, webURL, error) in
            guard error == nil else
            {
                return
            }
            self?.reference.child(FireBasePersistor.ramblsKey).child(rambl.id).setValue(rambl.toDict())
        }
    }
}
