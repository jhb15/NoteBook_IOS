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
    
    /*
     This function creates human readable string representing th content of the query.
     */
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Guardian Date Format
        
        var options: String = "["
        for opt in showFields {
            options += opt + ", "
        }
        options += "]"
        
        let string = "[q: " + queryText + ", dateFrom: " + dateFormatter.string(from: dateFrom) + ", dateTo: " + dateFormatter.string(from: dateFrom)
            + ", orderBy: " + orderBy + ", showFields: " + options + "]"
        
        return string
    }
    
    /*
     This function builds the query to add onto the end of an API Endpoint
     */
    func toQuery() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Guardian Date Format
        
        let escapedQuery = queryText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let options = showFields.joined(separator: ",")
        
        let to = dateFormatter.string(from: dateTo); let from = dateFormatter.string(from: dateFrom)
        
        var query = "?q=" + escapedQuery! + "&format=json&from-date=" + from + "&to-date=" + to
        query += "&order-by=" + orderBy + "&show-fields=" + options
        
        return query
    }
    
    /*enum ORDER: String {
        case newest, pldest, relevance
    }
    
    enum SHOWFIELD: String {
        case trailText, headline, body, lastModified, score, byline, starRating, all
    }*/
}
