//
//  AWSS3Uploader.swift
//  RamblCore
//
//  Created by Ricardo Contreras on 12/9/16.
//  Copyright © 2016 rcr. All rights reserved.
//

import Foundation
import AWSS3

internal class AWSS3Uploader : Uploader
{
    static let url = "https://s3.amazonaws.com"
    static let bucket = "rambls"
    private static let imagesPath = "images"
    
    func upload(uploadable: Uploadable, completion: @escaping UploaderCompletion)
    {
        guard let uploadRequest = AWSS3TransferManagerUploadRequest(),
            let localURL = uploadable.localURL else {
            completion(uploadable, nil, nil)
            return
        }
        uploadRequest.body = localURL
        uploadRequest.key = uploadable.path
        uploadRequest.bucket = AWSS3Uploader.bucket
        uploadRequest.contentType = uploadable.mediaType.rawValue + "/" + uploadable.mediaType.getExtension()
        uploadRequest.acl = AWSS3ObjectCannedACL.publicRead
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith { [weak self] (task) -> Any? in
            guard task.error == nil else
            {
                completion(uploadable, nil, task.error)
                return uploadRequest
            }
            
            guard task.result != nil,
                let url = self?.uploadableURL(uploadable: uploadable) else
            {
                completion(uploadable, nil, nil)
                return uploadRequest
            }
            
            completion(uploadable, url, nil)
            self?.deleteLocalFile(url: uploadable.localURL)
            return uploadRequest
        }
    }
    
    func uploadableURL(uploadable: Uploadable) -> String
    {
        return AWSS3Uploader.url + "/" + AWSS3Uploader.bucket + "/" + uploadable.path
    }
    
    func userImageURL(user: String) -> String
    {
        return AWSS3Uploader.url + "/" + AWSS3Uploader.bucket + "/" + AWSS3Uploader.imagesPath + "/" + user + UploadMediaType.Image.getExtension()
    }
}

private extension AWSS3Uploader
{
    func deleteLocalFile(url: URL?)
    {
        guard let url = url else
        {
            return
        }
        
        do
        {
            try FileManager.default.removeItem(atPath: url.absoluteString)
        }
        catch let error as NSError
        {
            print(error)
        }
    }
}
