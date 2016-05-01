//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class ApplicationManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var horseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horseList").path!
    }
    
    var horseList: [horse]!
    var newHorse = horse(horseName: "", jerseyNum: "", odds: "")
    
    let cellReuseIdentifier = "protoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let archivedHorseList = NSKeyedUnarchiver.unarchiveObjectWithFile(horseFilePath) as? [horse] {
            horseList = archivedHorseList
        }
    }
    
    //APPLICATION MANAGER
    @IBOutlet weak var horseNameTxt: UITextField!
    @IBOutlet weak var horseJerseyTxt: UITextField!
    @IBOutlet weak var horseOddsTxt: UITextField!
    @IBAction func onAddHorse(sender: AnyObject) {
        newHorse = horse(horseName: horseNameTxt.text!, jerseyNum: horseJerseyTxt.text!, odds: horseOddsTxt.text!)
        horseList.append(newHorse)
        NSKeyedArchiver.archiveRootObject(horseList, toFile: horseFilePath)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        
    }
    //UITABLEVIEW
    @IBOutlet var tableView: UITableView!
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.horseList.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CustomTableViewCell") as! CustomTableViewCell
        
        cell.horseNameCellLbl.text = self.horseList[indexPath.row].getName()
        cell.horseOddsCellLbl.text = self.horseList[indexPath.row].getOdds()
        cell.winCellNameLbl.text = self.horseList[indexPath.row].getNameForWager("Win")
        cell.placeCellNameLbl.text = self.horseList[indexPath.row].getNameForWager("Place")
        cell.showCellNameLbl.text = self.horseList[indexPath.row].getNameForWager("Show")
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            tableView.beginUpdates()
            horseList.removeAtIndex(indexPath.row)
            NSKeyedArchiver.archiveRootObject(horseList, toFile: horseFilePath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }
    
}



