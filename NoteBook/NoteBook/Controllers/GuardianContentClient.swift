//
//  GuardianContentApi.swift
//  ExampleNoteBook
//
//  Created by Neil Taylor on 22/03/2019.
//  Copyright © 2019 Aberystwyth University. All rights reserved.
//

import Foundation

class GuardianContentClient {

    var apiKey: String
    
    var verbose: Bool
    
    let session = URLSession(configuration: .default)
    
    var cacheEnabled: Bool = true
    
    convenience init(apiKey: String) {
        self.init(apiKey: apiKey, verbose: false)
    }
    
    init(apiKey: String, verbose: Bool) {
        self.apiKey = apiKey
        self.verbose = verbose
    }
    
    func searchContent(for query: String,
                       usingFilters filters: GuardianContentFilters?,
                       withCallback callback: @escaping (_ data: GuardianOpenPlatformData?) -> Void) throws  {
        
        var parameters = ""
        if let parameterValues = filters?.queryParameters() {
            parameters = "&\(parameterValues)"
        }
        
        let urlString = "https://content.guardianapis.com/search?q=\(query)\(parameters)&api-key=\(apiKey)"
        
        try performDataTask(with: urlString, withCallback: callback)
    }
    
    func searchSections(for query: String,
                        withCallback callback: @escaping (_ data: GuardianOpenPlatformData?) -> Void) throws {
        
        let urlString = "https://content.guardianapis.com/sections?q=\(query)&api-key=\(apiKey)"
        try performDataTask(with: urlString, withCallback: callback)
    }
    
    func searchTags(for query: String,
                    usingFilters filters: GuardianContentTagFilters?,
                    withCallback callback: @escaping (_ data: GuardianOpenPlatformData?) -> Void) throws {
        
        var parameters = ""
        if let parameterValues = filters?.queryParameters() {
            parameters = "&\(parameterValues)"
        }
        
        let urlString = "https://content.guardianapis.com/tags?q=\(query)\(parameters)&api-key=\(apiKey)"
        
        try performDataTask(with: urlString, withCallback: callback)
    }
    
    func performDataTask(with urlString: String,
                         withCallback callback: @escaping (_ data: GuardianOpenPlatformData?) -> Void) throws  {
        
        let responseCache = NSCache<AnyObject, AnyObject>()
        
        guard let value = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let url = URL(string: value) else {
                
            if verbose {
                print("Invalid URL has been specified: \(urlString)")
            }
                
            throw GuardianContentClientError.InvalidUrl
        }
        
        //loading cache
        
        if self.cacheEnabled,
            let res = responseCache.object(forKey: value as AnyObject) {
            print("Accessing data cache")
            let json = res as! NSData
            callback(decodeJSON(json: json as Data))
        }
        
        let task = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let downloadedData = data {
                
                if self.verbose {
                    let text = "Completed with response: \(String(describing: response))" +
                               "\ndata length: \(downloadedData.count)" +
                               "\nerror: \(String(describing: error))"
                    print(text)
                    
                }
                
                //Cache Data
                responseCache.setObject(downloadedData as AnyObject, forKey: value as AnyObject)
                
                callback(self.decodeJSON(json: downloadedData))
            }
            
        }
        
        task.resume()
        
    }
    
    func decodeJSON(json: Data) -> GuardianOpenPlatformData? {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(GuardianOpenPlatformData.self, from: json)
            
            return data
        }
        catch let error as NSError {
            if verbose {
                print("There was an error: \(error.localizedDescription)")
            }
            return nil
        }
    }
    
    
}
