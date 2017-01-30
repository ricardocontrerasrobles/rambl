//
//  ChatViewModel.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

typealias UpdateChatListBinding = () -> Void

class ChatViewModel
{
    public var updateChatList: UpdateChatListBinding?
    public var audioPlayerStatus: AudioPlayerStatusBinding?
    private let rambl: Rambl
    private let audioRecorder: AudioRecorder
    private var audioPlayer: AudioPlayer
    private let persistor: Persistor
    private let uploader: Uploader
    private let contributionCreator: ContributionCreator
    private var chats: [Chat] = []
    
    init(rambl: Rambl,
         audioRecorder: AudioRecorder,
         audioPlayer: AudioPlayer,
         persistor: Persistor,
         uploader: Uploader,
         contributionCreator: ContributionCreator)
    {
        self.rambl = rambl
        self.audioRecorder = audioRecorder
        self.audioPlayer = audioPlayer
        self.persistor = persistor
        self.uploader = uploader
        self.contributionCreator = contributionCreator
        setup()
    }
    
    func startRecording()
    {
        audioRecorder.start()
    }
    
    func stopRecording()
    {
        audioRecorder.stop { [weak self] (localURL) in
            guard let localURL = localURL else
            {
                return
            }
            self?.save(localURL: localURL, type: .Audio)
        }
    }
    
    func numberOfChats() -> Int
    {
        return chats.count
    }
    
    func textForChat(index: Int) -> String
    {
        guard index >= 0 && index < chats.count else
        {
            assert(false, "This should not happen")
        }
        
        let chat = chats[index]
        let prefix = chat.user == contributionCreator.user ? "Me" : "Partner"
        return prefix + " - " + chat.date.userInterfaceString()
    }
    
    func playChat(index: Int)
    {
        guard index >= 0 && index < chats.count else
        {
            assert(false, "This should not happen")
        }
        let chat = chats[index]
        play(contribution: chat)
    }
    
    private func play(contribution: Contribution)
    {
        if let url = URL(string: uploader.uploadableURL(uploadable: contribution))
        {
            audioPlayer.audioPlayerStatus = audioPlayerStatus
            audioPlayer.play(url: url)
        }
    }
    
    private func setup()
    {
        self.persistor.getChats(rambl: rambl) { [weak self] (newChats, error) in
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
    
    private func save(localURL: URL, type: UploadMediaType)
    {
        guard let user = contributionCreator.user else
        {
            return
        }
        if let chat = contributionCreator.createChat(user: user,
                                                     date: Date(),
                                                     localURL: localURL,
                                                     type: .Audio,
                                                     ramblAuthor: rambl.user,
                                                     rambl: rambl.id)
        {
            persistor.save(chat: chat, uploader: uploader)
        }
    }
}
