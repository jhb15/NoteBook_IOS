//
//  ResultCache+CoreDataProperties.swift
//  NoteBook
//
//  Created by jhb15 on 13/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//
//

import Foundation
import CoreData


extension ResultCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ResultCache> {
        return NSFetchRequest<ResultCache>(entityName: "ResultCache")
    }

    @NSManaged public var responses: [GuardianOpenPlatformData]?
    @NSManaged public var last_updated: NSDate?
    @NSManaged public var query: HistoricQuery?

}
