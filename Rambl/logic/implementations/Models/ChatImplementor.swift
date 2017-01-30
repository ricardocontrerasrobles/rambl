//
//  ChatImplementor.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

internal struct ChatImplementor : Chat
{
    var ramblAuthor: String
    var user: String
    var date: Date
    var rambl: String
    var mediaType: UploadMediaType
    var localURL: URL?
    var id:String {
        get
        {
            return rambl + "_" + user + "_" + date.idDateString()
        }
    }
    var path: String {
        get
        {
            return mediaType.rawValue + "/" + id + mediaType.getExtension()
        }
    }

    func toDict() -> [String:String]?
    {
        return [
            ModelsConstants.userKey : self.user,
            ModelsConstants.ramblKey : self.rambl,
            ModelsConstants.ramblAuthorKey : self.ramblAuthor,
            ModelsConstants.dateKey : self.date.backendDateString(),
            ModelsConstants.mediaTypeKey : self.mediaType.rawValue,
        ]
    }
    
    static func fromDict(chatDict : [String : String]) -> Chat?
    {
        guard check(chatDict: chatDict),
            let date = Date.from(backendDateString: chatDict[ModelsConstants.dateKey]!),
            let mediaType = UploadMediaType(rawValue: chatDict[ModelsConstants.mediaTypeKey]!) else
        {
            return nil
        }
        
        let chat = ChatImplementor(ramblAuthor: chatDict[ModelsConstants.ramblAuthorKey]!,
                                   user: chatDict[ModelsConstants.userKey]!,
                                   date: date,
                                   rambl: chatDict[ModelsConstants.ramblKey]!,
                                   mediaType: mediaType,
                                   localURL: nil)
        return chat
    }
}

private extension ChatImplementor
{
    static func check(chatDict : [String : String]) -> Bool
    {
        let isValid =
            chatDict[ModelsConstants.userKey] != nil &&
                chatDict[ModelsConstants.dateKey] != nil &&
                chatDict[ModelsConstants.mediaTypeKey] != nil &&
                chatDict[ModelsConstants.ramblKey] != nil &&
                chatDict[ModelsConstants.ramblAuthorKey] != nil
        return isValid
    }
}
