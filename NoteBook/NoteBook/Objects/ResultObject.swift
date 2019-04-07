//
//  ResultObject.swift
//  NoteBook
//
//  Created by jhb15 on 07/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import Foundation

class ResultObject {
    var id:String
    var sectionId:String
    var sectionName:String
    var webPublicationDate:String
    var webTitle:String
    var webUrl:String
    var apiUrl:String
    
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let sectionId = json["sectionId"] as? String,
            let sectionName = json["sectionName"] as? String,
            let webPublicationDate = json["webPublicationDate"] as? String,
            let webTitle = json["webTitle"] as? String,
            let webUrl = json["webUrl"] as? String,
            let apiUrl = json["apiUrl"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.sectionId = sectionId
        self.sectionName = sectionName
        self.webPublicationDate = webPublicationDate
        self.webTitle = webTitle
        self.webUrl = webUrl
        self.apiUrl = apiUrl
    }
}
