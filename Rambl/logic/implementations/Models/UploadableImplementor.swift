//
//  UploadableImplementor.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/28/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

internal struct UploadableImplementor : Uploadable
{
    var mediaType: UploadMediaType
    var path: String
    var localURL: URL?
}
