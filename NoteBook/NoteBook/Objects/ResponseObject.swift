//
//  ResponseObject.swift
//  NoteBook
//
//  Created by jhb15 on 07/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import Foundation

class ResponseObject {
    var status:String?
    var userTier:String?
    var total:Int?
    var startIndex:Int?
    var pageSize:Int?
    var currentPage:Int?
    var pages:Int?
    var orderBy:String?
    var results:[ResultObject]?
    
    init?(json: [String: Any]) {
        guard let status = json["status"] as? String,
            let userTeir = json["userTeir"] as? String,
            let total = json["total"] as? Int,
            let startIndex = json["startIndex"] as? Int,
            let pageSize = json["pageSize"] as? Int,
            let currentPage = json["currentPage"] as? Int,
            let pages = json["pages"] as? Int,
            let orderBy = json["orderBy"] as? String,
            let resultsJSON = json["results"] as? [Any]
            else {
                return nil
        }
        
        for resultJSON in resultsJSON {
            guard let res = ResultObject(json: resultJSON as! [String : Any]) else {
                return nil
            }
            
            self.results?.append(res)
        }
        
        self.status = status
        self.userTier = userTeir
        self.total = total
        self.startIndex = startIndex
        self.pageSize = pageSize
        self.currentPage = currentPage
        self.pages = pages
        self.orderBy = orderBy
        
    }
}
