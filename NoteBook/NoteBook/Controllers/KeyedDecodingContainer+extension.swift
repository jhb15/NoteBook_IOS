//
//  KeyedDecodingContainer+extension.swift
//  GuardianOpenPlatformExample
//
//  Created by Neil Taylor on 10/04/2019.
//  Copyright © 2019 Aberystwyth University. All rights reserved.
//

import Foundation

/**
 Based on discussion at
 https://stackoverflow.com/questions/44594652/swift-4-json-decodable-simplest-way-to-decode-type-change/51246308#51246308
 
 Thank you user Suran (https://stackoverflow.com/users/621571/suran)
 */
extension KeyedDecodingContainer {
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: K, transformFrom: String.Type) throws -> Bool? {
        
        guard let value = try decodeIfPresent(transformFrom, forKey: key) else {
            return nil
        }
        return Bool(value)
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K, transformFrom: String.Type) throws -> Int? {
        
        guard let value = try decodeIfPresent(transformFrom, forKey: key) else {
            return nil
        }
        return Int(value)
    }
    
    func decodeIfPresent(_ type: Date.Type, forKey key: K, transformFrom: String.Type) throws -> Date? {
        
        guard let value = try decodeIfPresent(transformFrom, forKey: key) else {
            return nil
        }
        
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: value)!

    }
    
    
}
