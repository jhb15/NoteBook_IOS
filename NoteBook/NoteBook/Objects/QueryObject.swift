//
//  QueryObject.swift
//  NoteBook
//
//  Created by jhb15 on 07/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import Foundation

class QueryObject {
    var queryText: String?
    var dateFrom: Date?
    var dateTo: Date?
    var orderBy: ORDER?
    var showFields: [SHOWFIELD]?
    
    init() {
        //TODO Constructor for query
    }
    
    func reset() {
        //TODO Implement resetting query
    }
    
    func toString() -> String {
        //TODO Will build the query to append to API request
        return ""
    }
    
    enum ORDER: String {
        case newest, pldest, relevance
    }
    
    enum SHOWFIELD: String {
        case trailText, headline, body, lastModified, score, byline, starRating, all
    }
}
