//
//  Date+Rambl.swift
//  Rambl
//
//  Created by Ricardo Contreras on 1/21/17.
//  Copyright © 2017 rcr. All rights reserved.
//

import Foundation

extension Date {
    
    private static let idDateFormat = "yyyyMMddHHmmss"
    private static let backendDateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    private static let userInterfaceFormat = "MM/dd/yyyy HH:mm"
    private static let formatterInstance = DateFormatter()
    
    static func from(idDateString: String) -> Date?
    {
        Date.formatterInstance.dateFormat = Date.idDateFormat
        return Date.formatterInstance.date(from: idDateString)
    }
    
    static func from(backendDateString: String) -> Date?
    {
        Date.formatterInstance.dateFormat = Date.backendDateFormat
        return Date.formatterInstance.date(from: backendDateString)
    }
    
    func idDateString() -> String {
        Date.formatterInstance.dateFormat = Date.idDateFormat
        return Date.formatterInstance.string(from: self)
    }
    
    func backendDateString() -> String {
        Date.formatterInstance.dateFormat = Date.backendDateFormat
        return Date.formatterInstance.string(from: self)
    }
    
    func userInterfaceString() -> String {
        Date.formatterInstance.dateFormat = Date.userInterfaceFormat
        return Date.formatterInstance.string(from: self)
    }
}
