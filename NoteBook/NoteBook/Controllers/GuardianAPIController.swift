//
//  GuardianAPIController.swift
//  NoteBook
//
//  Created by jhb15 on 02/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import Foundation

class GuardianAPIController {
    
    var session:URLSession?
    
    var query:QueryObject?
    
    func initialize() {
        if session == nil {
            let config = URLSessionConfiguration.default
            
            session = URLSession(configuration: config)
        }
        
        query = QueryObject()
    }
    
    /*
     This function will be called by the query GuardianQueryFormController and will be used to construct and perform
     an API request.
     */
    func performSearch(query: QueryObject) {
        initialize()
        
        let queryString = query.toString()
        
        let searchURL = URL(string: "https://content.guardianapis.com/search" + queryString)
        let searchTask = session!.dataTask(with: searchURL!, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let downloadedData = data {
                let text = "Completed with response: \(String(describing: response))\ndata length: \(downloadedData.count)\nerror: \(String(describing: error))"
                print(text)
                print(NSString(data: downloadedData, encoding: String.Encoding.utf8.rawValue)!)
                
            } else {
                print("No data recieved!")
            }
        })
        searchTask.resume()
    }
}