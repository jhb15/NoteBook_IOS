//
//  Response.swift
//  NoteBook
//
//  Created by jhb15 on 07/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import Foundation

struct Response:Codable {
    var status: String?
    var userTier: String?
    var total: Int?
    var startIndex: Int?
    var pageSize: Int?
    var currentPage: Int?
    var pages: Int?
    var orderBy: String?
    var results: [Result]?
}

struct Result:Codable {
    var id: String?
    var sectionId: String?
    var sectionName: String?
    var webPublicationDate: String?
    var webTitle: String?
    var webUrl: String?
    var apiUrl: String?
    var fields: Fields?
}

struct Fields:Codable {
    var trailText: String?
    var headline: String?
    var body: String?
    var lastModified: String?
}

