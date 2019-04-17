//
//  NoteDetailController.swift
//  NoteBook
//
//  Created by jhb15 on 06/04/2019.
//  Copyright © 2019 jhb15. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var contentTextArea: UITextView!
    @IBOutlet weak var linksTable: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    
    var noteItem: Note?
    var isEditable = false
    var managedContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showData()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if isEditable {
            let alertCntrl = UIAlertController(title: "You Where in Edit Mode", message: "You where in edit mode when leaving note detail screen, should the changes be saved?", preferredStyle: .alert)
            
            let noBtn = UIAlertAction(title: "No", style: .default, handler: nil)
            let yesBtn = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                self.saveChanges()
            }) //Destructive as it makes changes
            
            alertCntrl.addAction(noBtn)
            alertCntrl.addAction(yesBtn)
            present(alertCntrl, animated: true, completion: nil)
        }
        super.willMove(toParent: parent)
    }
    
    func showData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT_WITH_TIME
        
        linksTable.delegate = self; linksTable.dataSource = self
        
        titleLabel.text = noteItem?.title
        var times = ""
        if let cre = noteItem?.created_at,
            let upd = noteItem?.updated_at {
            times = "Created: " + dateFormatter.string(from: cre) + " \nUpdated: " + dateFormatter.string(from: upd)
        } else {
            times = "Created: err Updated: err"
        }
        timestampLabel.text = times
        contentTextArea.text = noteItem?.content
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        linksTable.reloadData()
    }
    
    @IBAction func toggleEditMode(_ sender: Any) {
        titleLabel.isEditable = !titleLabel.isEditable
        contentTextArea.isEditable = !contentTextArea.isEditable
        if isEditable {
            editBtn.setTitle("Edit Note", for: .normal)
            titleLabel.backgroundColor = PRIMARY_COLOUR
            contentTextArea.backgroundColor = PRIMARY_COLOUR
            saveChanges()
        } else {
            editBtn.setTitle("Save Changes", for: .normal)
            titleLabel.backgroundColor = SECONDARY_COLOUR
            contentTextArea.backgroundColor = SECONDARY_COLOUR
        }
        isEditable = !isEditable
        linksTable.reloadData()
    }
    
    func saveChanges() {
        noteItem?.title = titleLabel.text
        noteItem?.content = contentTextArea.text
        noteItem?.updated_at = Date()
        do {
            try managedContext?.save()
            print("Note Updated")
        }
        catch let error as NSError {
            print("error with \(error)")
        }
        showData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let view = segue.destination as? WebViewController,
            let indexPath = linksTable.indexPathForSelectedRow {
            if let link = noteItem!.links?.object(at: indexPath.row) as? Link {
                view.link = link
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let links = noteItem!.links {
            return links.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let links = noteItem!.links
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
        
        let link = links?.object(at: indexPath.row) as! Link
        cell.textLabel?.text = link.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let link = noteItem?.links?.object(at: indexPath.row) as? Link {
                link.removeFromNote(noteItem!)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

}
