//
//  SettingsViewModel.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SettingsViewModel
{
    private let uploader: Uploader
    private let contributionCreator: ContributionCreator
    private static let imagesPath = "images"
    private static let statusKey = "statusKey"
    private static let defaultStatus = "I'm rambling" // TODO: This should be localized
    
    init(uploader: Uploader,
         contributionCreator: ContributionCreator)
    {
        self.uploader = uploader
        self.contributionCreator = contributionCreator
    }
    
    func upload(image: UIImage)
    {
        guard let user = contributionCreator.user else
        {
            return
        }
        let localURL = URL(fileURLWithPath: NSTemporaryDirectory().appending(SettingsViewModel.imageName(user: user)))
        if let data = UIImageJPEGRepresentation(image, 0.4)
        {
            do
            {
            try data.write(to: localURL)
            }
            catch
            {
            }
            
            let uploadable = contributionCreator.createUploadable(localURL: localURL,
                                                                  path: SettingsViewModel.imagePath(user: user),
                                                                  mediaType: .Image)
            uploader.upload(uploadable: uploadable, completion: { (uploaded, url, error) in
                SDImageCache.shared().clearDisk()
                SDImageCache.shared().clearMemory()
            })
        }
    }
    
    func userImageURL() -> String?
    {
        guard let user = contributionCreator.user else
        {
            return nil
        }
        return uploader.userImageURL(user: user)
    }
    
    static func save(status: String)
    {
        UserDefaults.standard.set(status, forKey: SettingsViewModel.statusKey)
    }
    
    static func getStatus() -> String
    {
        let status = UserDefaults.standard.string(forKey: SettingsViewModel.statusKey)
        return status ?? SettingsViewModel.defaultStatus
    }
    
    private static func imageName(user: String) -> String
    {
        let imageType = UploadMediaType.Image
        return user + imageType.getExtension()
    }
    
    private static func imagePath(user: String) -> String
    {
        return SettingsViewModel.imagesPath + "/" + SettingsViewModel.imageName(user: user)
    }
}
