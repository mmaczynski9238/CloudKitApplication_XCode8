//
//  TableViewController.swift
//  CloudKitApplication
//
//  Created by Michael Maczynski on 10/4/16.
//  Copyright © 2016 Michael Maczynski. All rights reserved.
//
//

import UIKit
import CloudKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    var names = [CKRecord]()
    var refresh:UIRefreshControl!
    let publicData = CKContainer.defaultContainer().publicCloudDatabase

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refresh.addTarget(self, action: #selector(TableViewController.loadData), forControlEvents: .ValueChanged)
        tableView.addSubview(refresh)
        
        //
        loadData()
    }
    
    func loadData () {
        names = [CKRecord]()
        
        let publicData = CKContainer.defaultContainer().publicCloudDatabase
        let query = CKQuery(recordType: "Name", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        publicData.performQuery(query, inZoneWithID: nil) { (results:[CKRecord]?, error:NSError?) -> Void in
            if let names = results {
                self.names = names
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                })
            }
        }
        
        
        
    }
    
    
    @IBAction func sendName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Enter a Name", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in
            textField.placeholder = "Enter A Name"
        }
        
        alert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first!
            
            if textField.text != "" {
                let newName = CKRecord(recordType: "Name")
                newName["content"] = textField.text
                
                self.publicData.saveRecord(newName, completionHandler: { (record:CKRecord?, error:NSError?) -> Void in
                    if error == nil {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.beginUpdates()
                            self.names.insert(newName, atIndex: 0)
                            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                            self.tableView.endUpdates()
                            print("Name Saved Successfully")
                        })
                    }else{
                        print(error)
                    }
                })
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return names.count
    }
    
       //http://stackoverflow.com/questions/36844342/how-to-delete-a-ckrecord-at-indexpath-uitableview
        
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            let record = names[indexPath.row]
//            publicData.deleteRecordWithID(record.recordID, completionHandler: ({returnRecord, error in
//                // do error handling
//            })
//                names.removeAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        }
//    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if names.count == 0 {
            return cell
        }
        
        let Name = names[indexPath.row]
        
        if let NameContent = Name["content"] as? String {
            let schoolString = "JHHS"
//            let dateFormat = NSDateFormatter()
//            dateFormat.dateFormat = "MM/dd/yyyy"
//            let dateString = dateFormat.stringFromDate(Name.creationDate!)
            
            cell.textLabel?.text = NameContent
            cell.detailTextLabel?.text = schoolString
        }
        
        return cell
    }
    
}
