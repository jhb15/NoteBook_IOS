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
    }
    
    /*
     This function will be called by the query GuardianQueryFormController and will be used to construct and perform
     an API request.
     */
    func performSearch(query: QueryObject) {
        initialize()
        
        let queryString = query.toQuery()
        
        let url = "https://content.guardianapis.com/search" + queryString + "&api-key=42573d7e-fb83-4aef-956f-2c52a9bca421"
        let searchURL = URL(string: url)
        print(searchURL?.absoluteString ?? "Unknown")                                           ////DEBUG CODE
        
        let searchTask = session!.dataTask(with: searchURL!, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let downloadedData = data {
                let text = "Completed with response: \(String(describing: response))\ndata length: \(downloadedData.count)\nerror: \(String(describing: error))"
                print(text)
                print(NSString(data: downloadedData, encoding: String.Encoding.utf8.rawValue)!)
                
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(GuardianOpenPlatformData.self, from: downloadedData)
                    
                    print(decodedData)
                    //TODO Implement
                    
                } catch let error as NSError {
                    print("Error decoding JSON response, Description: \(error.localizedDescription)")
                }
                
            } else {
                print("No data recieved! \(String(describing: error?.localizedDescription))")
            }
        })
        searchTask.resume()
    }
}
