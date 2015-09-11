//
//  ViewController.swift
//  HitList
//
//  Created by 刘业清 on 15/7/3.
//  Copyright (c) 2015年 Guadoo Group. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var people = [NSManagedObject]()
    
    @IBAction func addName(sender: AnyObject) {
        var alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as! UITextField
            self.saveName(textField.text)
            
            //替换reloadData()，使得添加新的一行后，有动画效果
            //self.tableView.reloadData()
            let indexPath = NSIndexPath(forRow: (self.people.count-1), inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated:true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //3
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        
        if let results = fetchedResults {
            people = results
        }else{
            println("(Could not fetch \(error), \(error!.userInfo))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveName(name: String){
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        var error: NSError?
        if !managedContext.save(&error){
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        //5
        people.append(person)
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let person = people[indexPath.row]
        
        cell.textLabel!.text = person.valueForKey("name") as! String?
        
        return cell
    }

}

