//
//  NewNoteController.swift
//  NoteBook
//
//  Created by jhb15 on 02/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

class NewNoteController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    @IBOutlet weak var linksTableView: UITableView!
    
    var managedContext: NSManagedObjectContext?
    
    var cells = ["Cell1", "Cell2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linksTableView.delegate = self; linksTableView.dataSource = self;

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
        
        cell.textLabel?.text = cells[indexPath.row]
        
        return cell
    }

}
