//
//  URLSession+extension.swift
//  GuardianOpenPlatformExample
//
//  Created by Neil Taylor on 12/04/2019.
//  Copyright © 2019 Aberystwyth University. All rights reserved.
//

import Foundation

extension URLSession {
    
    func dataTask(with url: URL, debug: Bool, completionHandler handler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if debug {
                let debugError = NSError(domain: "NSURLErrorDomain", code: -1009, userInfo: nil)
                handler(nil, nil, debugError)
            }
            else {
                handler(data, response, error)
            }
        })
    }
    
}
