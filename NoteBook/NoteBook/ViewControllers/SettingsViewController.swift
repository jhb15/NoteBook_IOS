//
//  SettingsViewController.swift
//  NoteBook
//
//  Created by jhb15 on 15/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var cahingLabel: UILabel!
    @IBOutlet weak var cacheSizeLabel: UILabel!
    @IBOutlet weak var clearCacheBtn: UIButton!
    @IBOutlet weak var cacheingSwitch: UISwitch!
    @IBOutlet weak var clearDefaultsButton: UIButton!
    
    var managedContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<ResponseCache>?
    let defaults:UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cacheingSwitch.addTarget(self, action: #selector(cacheSwitchedOff(_:)), for: .valueChanged)
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
        }
        managedContext = delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ResponseCache>(entityName: "ResponseCache")
        let sortDescriptor = NSSortDescriptor(key: "key", ascending: false, selector: #selector(NSString.localizedCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!, sectionNameKeyPath: nil, cacheName: nil)
        performFetchForController()
        
        updateView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performFetchForController()
        updateView()
    }
    
    func updateView() {
        cacheSizeLabel.text = "Responses Cached: \(fetchedResultsController?.fetchedObjects?.count ?? 0)"
        cacheingSwitch.isOn = defaults.bool(forKey: CACHING_USER_DEFAULT_ID)
        clearCacheBtn.isEnabled = false
        if cacheingSwitch.isOn {
            clearCacheBtn.isEnabled = true
            cahingLabel.text = "Caching Enabled"
        } else {
            cahingLabel.text = "Caching Disabled"
        }
    }
    
    @IBAction func clearCacheAction(_ sender: Any) {
        let alertCntrl = UIAlertController(title: "Clear Cache", message: "Are you sure you want to delete all of cached responses. This is used for offiline access to data.", preferredStyle: .alert)
        
        let yesBtn = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.clearCacheConfirm()
        })
        let noBtn = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertCntrl.addAction(yesBtn)
        alertCntrl.addAction(noBtn)
        present(alertCntrl, animated: true, completion: nil)
    }
    
    func clearCacheConfirm() {
        let cachedResponses = fetchedResultsController?.fetchedObjects
        if cachedResponses != nil && cachedResponses!.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ResponseCache")
            
            let batchDel = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext?.execute(batchDel)
                print("Cleared Cache")
            } catch let error as NSError {
                print("Error Clearing History, \(error.localizedDescription)")
            }
        }
        performFetchForController()
        updateView()
    }
    
    @IBAction func clearDefaults(_ sender: Any) {
        let alertController = UIAlertController(title: "Clearing User Defaults", message: "To clear the user defaults that app must restart, are you sure you want to continue?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive) {
            (action) in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            exit(0)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func cacheSwitchedOff(_ sender: UISwitch) {
        print(cacheingSwitch.isOn)
        defaults.set(cacheingSwitch.isOn, forKey: CACHING_USER_DEFAULT_ID)
        updateView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func performFetchForController() {
        do {
            try fetchedResultsController?.performFetch()
        }
        catch let error as NSError {
            print("The error was: \(error)")
            
        }
    }

}
