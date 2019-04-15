//
//  File.swift
//  NoteBook
//
//  Created by jhb15 on 14/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UrlResponseCache {
    
    let expiryIntervalSec: Double = 60 * 60 * 24
    var managedContext: NSManagedObjectContext?
    
    init() {
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
            
        }
        managedContext = delegate.persistentContainer.viewContext
    }
    
    func getCachedData(key: String) -> Data? {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "ResponseCache")
        fetchReq.returnsDistinctResults = true
        
        let predicate = NSPredicate(format: "key == %@", key as NSString)
        
        fetchReq.predicate = predicate
        
        do {
            if let result = try managedContext?.fetch(fetchReq) as? [ResponseCache] {
                if result.count > 0 {
                    if hasExpired(expiry: result[0].expiryDate!) {
                        print("Removing Expired Cache! key: " + (result[0].key ?? "nil"))
                        managedContext?.delete(result[0])
                    }
                    return result[0].data
                }
            }
        } catch let error as NSError {
            print("Error trying to retreive from the cache. desc: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func cacheData(key: String, data: Data) {
        let responseCache = ResponseCache(entity: ResponseCache.entity(), insertInto: managedContext)
        responseCache.key = key
        responseCache.data = data
        responseCache.expiryDate = Date().addingTimeInterval(TimeInterval(expiryIntervalSec))
        
        do {
            try managedContext?.save()
            print("Response for \(key) cached!")
        } catch let error as NSError {
            print("Error cacheing result! desc: \(error.localizedDescription)")
        }
    }
    
    func clearExpiredData() {
        let fetchRequest = NSFetchRequest<ResponseCache>(entityName: "ResponseCache")
        let sortDescriptor = NSSortDescriptor(key: "expiryDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
            let results = fetchedResultsController.fetchedObjects!
            for res in results {
                if hasExpired(expiry: res.expiryDate!) {
                    managedContext?.delete(res)
                } else {
                    return //This is done becuase the responses should be ordered by expiry so as soon as we hit a non expired entity we can stop.
                }
            }
        } catch let error as NSError {
            print("Error retriveing cached data! desc: \(error.localizedDescription)")
        }
        
    }
    
    func hasExpired(expiry: Date) -> Bool {
        let today = Date()
        let comp = today.compare(expiry)
        if comp == ComparisonResult.orderedAscending {
            return false
        }
        return true
    }
}
