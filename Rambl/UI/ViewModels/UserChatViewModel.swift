//
//  UserChatViewModel.swift
//  Rambl
//
//  Created by Ricardo Contreras on 7/2/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

class UserChatViewModel: ChatViewModel {
    
    override func setup()
    {
        self.persistor.getChats(user: "") { [weak self] (newChats, error) in
            guard error == nil else
            {
                print(error!)
                return
            }
            
            if let newChats = newChats
            {
                self?.chats = newChats
                self?.updateChatList?()
            }
        }
    }
}
