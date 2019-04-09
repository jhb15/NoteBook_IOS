//
//  QueryObject.swift
//  NoteBook
//
//  Created by jhb15 on 07/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import Foundation

struct QueryObject {
    var queryText: String
    var dateFrom: Date
    var dateTo: Date
    var orderBy: String
    var showFields: [String]
    
    /*init() {
        //TODO Constructor for query
    }
    
    func reset() {
        //TODO Implement resetting query
    }*/
    
    /*
     This function will build the query to be appended to the Guardian API endpoint.
     TODO change from debugging to actual output!
     */
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd" //Guardian Date Format
        
        var options: String = "["
        for opt in showFields {
            options += opt + ", "
        }
        
        return "[q: " + queryText + ", dateFrom: " + dateFormatter.string(from: dateFrom) + ", dateTo: " + dateFormatter.string(from: dateFrom)
            + ", orderBy: " + orderBy + ", showFields: " + options + "]"
    }
    
    /*enum ORDER: String {
        case newest, pldest, relevance
    }
    
    enum SHOWFIELD: String {
        case trailText, headline, body, lastModified, score, byline, starRating, all
    }*/
}
