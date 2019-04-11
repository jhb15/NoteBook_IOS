//
//  NewNoteController.swift
//  NoteBook
//
//  Created by jhb15 on 02/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

class NewNoteController: UIViewController {
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("error - unable to access failure")
            exit(EXIT_FAILURE)
            
        }
        managedContext = delegate.persistentContainer.viewContext
    }
    
    @IBAction func newNote(_ sender: UIBarButtonItem) {
        print("Adding New Note!")
        
        let note = Note(entity: Note.entity(), insertInto: managedContext)
        note.title = noteTitle.text
        note.content = noteContent.text
        note.created_at = Date(); note.updated_at = Date()
        //TODO Add Links
        
        do {
            try managedContext?.save()
            print("note added")
        }
        catch let error as NSError {
            print("error with \(error)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelNote(_ sender: UIBarButtonItem) {
        print("Canceling Add Note!")
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
