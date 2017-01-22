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
    static let bucket = "rambls"
    static let url = "https://s3.amazonaws.com"
    
    func upload(contribution: Contribution, completion: @escaping UploaderCompletion)
    {
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = contribution.localURL
        uploadRequest?.key = contribution.path
        uploadRequest?.bucket = AWSS3Uploader.bucket
        uploadRequest?.contentType = contribution.mediaType.rawValue + "/" + contribution.mediaType.getExtension()
        uploadRequest?.acl = AWSS3ObjectCannedACL.publicRead
        
        let transferManager = AWSS3TransferManager.default()
        transferManager?.upload(uploadRequest).continue(_:) { [weak self] (task) -> AnyObject! in
            
            guard task.error == nil else
            {
                completion(contribution, nil, task.error)
                return uploadRequest
            }
            
            guard task.exception == nil, task.result != nil,
                let url = self?.url(contribution: contribution) else
            {
                completion(contribution, nil, nil)
                return uploadRequest
            }
            
            completion(contribution, url, nil)
            return uploadRequest
        }
    }
    
    func getURL() -> String
    {
        return AWSS3Uploader.url + "/" + AWSS3Uploader.bucket
    }
}

private extension AWSS3Uploader
{
    func url(contribution: Contribution) -> URL?
    {
        return URL(string: getURL() + "/" + contribution.path)
    }
}
