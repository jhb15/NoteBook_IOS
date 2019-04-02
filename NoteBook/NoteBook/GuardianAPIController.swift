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
    
    func initialize() {
        if session == nil {
            let config = URLSessionConfiguration.default
            
            session = URLSession(configuration: config)
        }
    }
    
    /*
     Placeholder.
    */
    func performSearch() {
        initialize()
        
        let searchURL = URL(string: "https://content.guardianapis.com/search")
        let searchTask = session!.dataTask(with: searchURL!, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let errorResult = error {
                
            }
            
            if let data = data {
                
            }
        })
        searchTask.resume()
    }
}
