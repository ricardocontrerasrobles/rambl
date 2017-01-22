//
//  RamblImplementor.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/18/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

internal struct RamblImplementor : Rambl
{
    var user:String
    var date:Date
    var mediaType:ContributionMediaType
    var localURL:URL?
    var latitude:Double
    var longitude:Double
    var locationName:String
    var status:String
    var id:String {
        get
        {
            return user + "_" + date.idDateString()
        }
    }
    var path: String {
        get
        {
            return mediaType.rawValue + "/" + id + mediaType.getExtension()
        }
    }
    var geohash:String {
        get {
            return Geohash.encode(latitude: self.latitude, longitude: self.longitude)
        }
    }
    
    func toDict() -> [String:String]?
    {
        return [
            ModelsConstants.userKey : self.user,
            ModelsConstants.dateKey : self.date.backendDateString(),
            ModelsConstants.mediaTypeKey : self.mediaType.rawValue,
            ModelsConstants.latitudeKey : "\(self.latitude)",
            ModelsConstants.longitudeKey : "\(self.longitude)",
            ModelsConstants.geohashKey : self.geohash,
            ModelsConstants.locationNameKey : self.locationName,
            ModelsConstants.statusKey : self.status
        ]
    }
    
    static func fromDict(ramblDict : [String : String]) -> Rambl?
    {
        guard check(ramblDict: ramblDict),
            let date = Date.from(backendDateString: ramblDict[ModelsConstants.dateKey]!),
            let mediaType = ContributionMediaType(rawValue: ramblDict[ModelsConstants.mediaTypeKey]!),
            let latitude = Double(ramblDict[ModelsConstants.latitudeKey]!),
            let longitude = Double(ramblDict[ModelsConstants.longitudeKey]!) else
        {
            return nil
        }
        
        let rambl = RamblImplementor(
            user: ramblDict[ModelsConstants.userKey]!,
            date: date,
            mediaType: mediaType,
            localURL: nil,
            latitude: latitude,
            longitude: longitude,
            locationName: ramblDict[ModelsConstants.locationNameKey]!,
            status: ramblDict[ModelsConstants.statusKey]!)
        
        // TODO: Instead of using webURL we can use the unique ID
        // Maybe comply with the func to compare
        return rambl
    }
}

private extension RamblImplementor
{
    static func check(ramblDict : [String : String]) -> Bool
    {
        let isValid =
            ramblDict[ModelsConstants.userKey] != nil &&
                ramblDict[ModelsConstants.dateKey] != nil &&
                ramblDict[ModelsConstants.mediaTypeKey] != nil &&
                ramblDict[ModelsConstants.latitudeKey] != nil &&
                ramblDict[ModelsConstants.longitudeKey] != nil &&
                ramblDict[ModelsConstants.locationNameKey] != nil &&
                ramblDict[ModelsConstants.statusKey] != nil
        return isValid
    }
}

