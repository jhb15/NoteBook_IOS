//
//  DataTypes.swift
//  ExampleNoteBook
//
//  Created by Neil Taylor on 21/03/2019.
//  Copyright © 2019 Aberystwyth University. All rights reserved.
//

import Foundation

struct GuardianOpenPlatformData: Codable {
    var response: GuardianOpenPlatFormResponse
}

struct GuardianOpenPlatFormResponse: Codable {
    var status: String
    var userTier: String
    var total: Int
    var startIndex: Int?
    var pageSize: Int?
    var currentPage: Int?
    var pages: Int?
    var orderBy: String?
    var results: [GuardianOpenPlatformResult]?
}

struct GuardianOpenPlatformTag: Codable {
    
    var id: String
    var type: String
    var sectionId: String
    var sectionName: String
    var webTitle: String
    var webUrl: URL?
    var apiUrl: URL?
    var references: [GuardianOpenPlatformReference]?
    
    /**
     Creates a new instance by decoding from the given decoder.
     
     - Note:
     - The required keyword is used to indicate that any subclasses must
     implement this interface.
     */
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        type = try values.decode(String.self, forKey: .type)
        sectionId = try values.decode(String.self, forKey: .sectionId)
        sectionName = try values.decode(String.self, forKey: .sectionName)
        webTitle = try values.decode(String.self, forKey: .webTitle)
        
        webUrl = try values.decodeIfPresent(URL.self, forKey: .webUrl)
        apiUrl = try values.decodeIfPresent(URL.self, forKey: .apiUrl)
        
        references = try values.decodeIfPresent([GuardianOpenPlatformReference].self, forKey: .references)
    }
}

struct GuardianOpenPlatformReference: Codable {
    var id: String
    var type: String
}

struct GuardianOpenPlatformFields: Codable {
    var headline: String?
    var standfirst: String?
    var trailText: String?
    var byline: String?
    var main: String?
    var body: String?
    var newspaperPageNumber: Int?
    var wordcount: Int?
    var commentCloseDate: Date?
    var commentable: Bool?
    var firstPublicationDate: Date?
    var isInappropriateForSponsorship: Bool?
    var isPremoderated: Bool?
    var lastModified: Date?
    var newspaperEditionDate: Date?
    var productionOffice: String?
    var publication: String?
    var shortUrl: URL?
    var shouldHideAdverts: Bool?
    var showInRelatedContent: Bool?
    var thumbnail: URL?
    var legallySensitive: Bool?
    var lang: String?
    var bodyText: String?
    var charCount: Int?
    var shouldHideHeaderRevenue: Bool?
    var showAffiliateLinks: Bool?
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        headline = try values.decodeIfPresent(String.self, forKey: .headline)
        standfirst = try values.decodeIfPresent(String.self, forKey: .standfirst)
        trailText = try values.decodeIfPresent(String.self, forKey: .trailText)
        byline = try values.decodeIfPresent(String.self, forKey: .byline)
        main = try values.decodeIfPresent(String.self, forKey: .main)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        
        productionOffice = try values.decodeIfPresent(String.self, forKey: .productionOffice)
        publication = try values.decodeIfPresent(String.self, forKey: .publication)
        lang = try values.decodeIfPresent(String.self, forKey: .lang)
        bodyText = try values.decodeIfPresent(String.self, forKey: .bodyText)
        
        newspaperPageNumber = try values.decodeIfPresent(Int.self, forKey: .newspaperPageNumber, transformFrom: String.self)
        wordcount = try values.decodeIfPresent(Int.self, forKey: .wordcount, transformFrom: String.self)
        charCount = try values.decodeIfPresent(Int.self, forKey: .charCount, transformFrom: String.self)
        
        commentable = try values.decodeIfPresent(Bool.self, forKey: .commentable, transformFrom: String.self)
        isInappropriateForSponsorship = try values.decodeIfPresent(Bool.self, forKey: .isInappropriateForSponsorship, transformFrom: String.self)
        isPremoderated = try values.decodeIfPresent(Bool.self, forKey: .isPremoderated, transformFrom: String.self)
        shouldHideAdverts = try values.decodeIfPresent(Bool.self, forKey: .shouldHideAdverts, transformFrom: String.self)
        showInRelatedContent = try values.decodeIfPresent(Bool.self, forKey: .showInRelatedContent, transformFrom: String.self)
        legallySensitive = try values.decodeIfPresent(Bool.self, forKey: .legallySensitive, transformFrom: String.self)
        shouldHideHeaderRevenue = try values.decodeIfPresent(Bool.self, forKey: .shouldHideHeaderRevenue, transformFrom: String.self)
        showAffiliateLinks = try values.decodeIfPresent(Bool.self, forKey: .showAffiliateLinks, transformFrom: String.self)
        
        commentCloseDate = try values.decodeIfPresent(Date.self, forKey: .commentCloseDate, transformFrom: String.self)
        firstPublicationDate = try values.decodeIfPresent(Date.self, forKey: .firstPublicationDate, transformFrom: String.self)
        lastModified = try values.decodeIfPresent(Date.self, forKey: .lastModified, transformFrom: String.self)
        newspaperEditionDate = try values.decodeIfPresent(Date.self, forKey: .newspaperEditionDate, transformFrom: String.self)
        
        shortUrl = try values.decodeIfPresent(URL.self, forKey: .shortUrl)
        thumbnail = try values.decodeIfPresent(URL.self, forKey: .thumbnail)
    }
}

struct GuardianOpenPlatformEdition: Codable {
    
    var id: String
    var webTitle: String
    var webUrl: URL?
    var apiUrl: URL?
    var code: String
    
}

struct GuardianOpenPlatformResult: Codable {
    var id: String
    var type: String?
    var sectionId: String?
    var sectionName: String?
    var webPublicationDate: Date?
    var webTitle: String
    var webUrl: URL?
    var apiUrl: URL?
    var fields: GuardianOpenPlatformFields?
    var references: [GuardianOpenPlatformReference]?
    
    /**
     
     */
    var editions: [GuardianOpenPlatformEdition]?
    var isHosted: Bool?
    var pillarId: String?
    var pillarName: String?
    
    /**
     Creates a new instance by decoding from the given decoder.
     
     - Note:
        - The required keyword is used to indicate that any subclasses must
          implement this interface.
     */
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        sectionId = try values.decodeIfPresent(String.self, forKey: .sectionId)
        sectionName = try values.decodeIfPresent(String.self, forKey: .sectionName)
        
        if let webPublicationDateString = try values.decodeIfPresent(String.self, forKey: .webPublicationDate) {
           let formatter = ISO8601DateFormatter()
           webPublicationDate = formatter.date(from: webPublicationDateString)!
        }
        
        webTitle = try values.decode(String.self, forKey: .webTitle)
        
        webUrl = try values.decodeIfPresent(URL.self, forKey: .webUrl)
        apiUrl = try values.decodeIfPresent(URL.self, forKey: .apiUrl)
        
        fields = try values.decodeIfPresent(GuardianOpenPlatformFields.self, forKey: .fields)
        
        references = try values.decodeIfPresent([GuardianOpenPlatformReference].self, forKey: .references)
        
        editions = try values.decodeIfPresent([GuardianOpenPlatformEdition].self, forKey: .editions)
        
        isHosted = try values.decodeIfPresent(Bool.self, forKey: .isHosted)
        pillarId = try values.decodeIfPresent(String.self, forKey: .pillarId)
        pillarName = try values.decodeIfPresent(String.self, forKey: .pillarName)
    }
}

// MARK: - Enumerations for filters

/**
 Valid filter settings for the `rights` filter.
 */
enum GuardianContentRightsFilter: String {
    case syndicatable
    case subscriptionDatabases = "subscription-databases"
    case developerCommunity = "developer-community"
}

/**
 Valid filter settings for the `show-elements` filter.
 */
enum GuardianContentElementsFilter: String {
    case audio
    case image
    case video
    case all
}

/**
 Valid filter settings for the `use-date` filter.
 */
enum GuardianContentDateFilter: String, CaseIterable {
    case published
    case firstPublication = "first-publication"
    case newspaperEdition = "newspaper-edition"
    case lastModified = "last-modified"
}

/**
 Valid filter settings for the 'order-date' filter.
 */
enum GuardianContentOrderDateFilter: String, CaseIterable {
    case published
    case newspaperEdition = "newspaper-edition"
    case lastModified = "last-modified"
}

/**
 Valid filter settings for the `order-by` filter.
 */
enum GuardianContentOrderFilter: String, CaseIterable {
    case newest
    case oldest
    case relevance
}

/**
 Valid filter settings for 'show-fields' filter. Not all have been added but just some
 that the user may want.
 */
enum GuardianContentShowFields: String, CaseIterable {
    case trailText
    case thumbnail
    case headline
    case body
    case lastModified
    case wordcount
    case byline
}

// MARK: - Filters

class GuardianContentTagFilters {
    
    /**
     A section corresponds to one of the main areas on the website.
     An article is associated with one section.
     */
    var section: String?
    
    /**
     A comma separated list of values, although 'all' would be the most useful value.
     */
    var showReferences: String?
    
    var page: Int?
    
    var pageSize: Int?
    
    /**
     Generates a string that lists the query parameters that
     are to be used for the filter settings. If there are multiple filter
     settings with values, they will be separated by the `&` character.
     
     - Returns: A string of the format: `<filter-name>=<filter-value>&<filter-name>=<filter-value>`.
       If no filter values have been specified, the result will be an empty string.
     */
    func queryParameters() -> String {
        var result = [String]()
        
        if let sectionValue = section {
            result.append("section=\(sectionValue)")
        }
        
        if let showReferencesValue = showReferences {
            result.append("show-references=\(showReferencesValue)")
        }
        
        if let pageValue = page {
            result.append("page=\(pageValue)")
        }
        
        if let pageSizeValue = pageSize {
            result.append("page-size=\(pageSizeValue)")
        }
        
        return result.reduce("", { (result, item) -> String in
            (result == "") ? "\(item)" : "\(result)&\(item)"
        })
    }
    
}

/**
 Specified filter values that can be applied to a search for
 Content using the Guardian's Open Platform API. These filters
 are in addition to filters that are in common with the
 superclass of GuardianContentTagFilters.
 */
class GuardianContentFilters: GuardianContentTagFilters {
    
    /**
     A comma separated list of tag values that are used to provide
     meta-groups for content. From the documentation, these are
     used in different ways, e.g. to identify journalists ('profile/georgemonbiot')
     news events such as ('football/world-cup-2018') and
     */
    var tag: String?
    var productionOffice: String?
    var rights: GuardianContentRightsFilter?
    var showTags: String?
    var showElements: GuardianContentElementsFilter?
    var orderBy: GuardianContentOrderFilter?
    var orderDate: GuardianContentOrderDateFilter?
    var useDate: GuardianContentDateFilter?
    var fromDate: Date?
    var toDate: Date?
    var showFields: [GuardianContentShowFields]?
    
    override func queryParameters() -> String {
        
        var result = [String]()
        
        if let tagValue = tag {
            result.append("tag=\(tagValue)")
        }
        
        if let productionOfficeValue = productionOffice {
            result.append("production-office=\(productionOfficeValue)")
        }
        
        if let rightsValue = rights {
            result.append("rights=\(rightsValue.rawValue)")
        }
        
        if let showElementsValue = showElements {
            result.append("show-elements=\(showElementsValue.rawValue)")
        }
        
        if let showTagsValue = showTags {
            result.append("show-tags=\(showTagsValue)")
        }
        
        if let orderByValue = orderBy {
            result.append("order-by=\(orderByValue.rawValue)")
        }
        
        if let orderDateValue = orderDate {
            result.append("order-date=\(orderDateValue.rawValue)")
        }
        
        if let fromDateValue = fromDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            result.append("from-date=\(formatter.string(from: fromDateValue))")
        }
        
        if let toDateValue = toDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            result.append("to-date=\(formatter.string(from: toDateValue))")
        }
        
        if let useDateValue = useDate {
            result.append("use-date=\(useDateValue.rawValue)")
        }
        
        //Added to append the show fields filter onto the request.
        if let showFieldValues = showFields {
            var str: [String] = []
            for field in showFieldValues {
                str.append(field.rawValue)
            }
            result.append( "show-fields=" + str.joined(separator: ","))
        }
        
        return result.reduce(super.queryParameters(), { (result, item) -> String in
            (result == "") ? "\(item)" : "\(result)&\(item)"
        })
    }
    
}

enum GuardianContentClientError: Error {
    case InvalidUrl
}
