//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class ApplicationManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allHorseListsFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("allHorseLists").path!
    }
    
    var horseList: [horse]!
    var allHorseLists: [[horse]]!
    var newHorse = horse(horseName: "", jerseyNum: "", odds: "")
    
    let cellReuseIdentifier = "protoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let archivedAllHorseList = NSKeyedUnarchiver.unarchiveObjectWithFile(allHorseListsFilePath) as? [[horse]] {
            allHorseLists = archivedAllHorseList
        }
        horseList = allHorseLists[allHorseLists.count-1]
        setNumSegments()
        
    }
    
    //APPLICATION MANAGER
    func setNumSegments() {
        let numOfSegments = (allHorseLists.count)
        switch numOfSegments {
        case 1:
            horseListChooserSgm.setEnabled(false, forSegmentAtIndex: 1)
            horseListChooserSgm.removeSegmentAtIndex(2, animated: true)
            horseListChooserSgm.removeSegmentAtIndex(3, animated: true)
        case 2:
            horseListChooserSgm.setEnabled(true, forSegmentAtIndex: 1)
        case 3:
            horseListChooserSgm.setEnabled(true, forSegmentAtIndex: 1)
            horseListChooserSgm.insertSegmentWithTitle("Third", atIndex: 3, animated: false)
        case 4:
            horseListChooserSgm.setEnabled(true, forSegmentAtIndex: 1)
            horseListChooserSgm.insertSegmentWithTitle("Fourth", atIndex: 4, animated: false)
        default: break
        }
    }
    func archiveHorseList () {
        allHorseLists[allHorseLists.count-1] = horseList
        NSKeyedArchiver.archiveRootObject(allHorseLists, toFile: allHorseListsFilePath)
    }
    @IBOutlet weak var horseNameTxt: UITextField!
    @IBOutlet weak var horseJerseyTxt: UITextField!
    @IBOutlet weak var horseOddsTxt: UITextField!
    
    @IBOutlet weak var horseListChooserSgm: UISegmentedControl!
    
    @IBAction func onListChosen(sender: AnyObject) {
        let chosenList = horseListChooserSgm.selectedSegmentIndex
        if chosenList < allHorseLists.count {
            horseList = allHorseLists[chosenList]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
    }
    @IBAction func onDeleteListPressed(sender: AnyObject) {
        let selectedList = horseListChooserSgm.selectedSegmentIndex
        horseList = allHorseLists[0]
        horseListChooserSgm.selectedSegmentIndex = 0
        allHorseLists.removeAtIndex(selectedList)
        horseList = allHorseLists[0]
        setNumSegments()
        archiveHorseList()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    @IBAction func onAddHorse(sender: AnyObject) {
        newHorse = horse(horseName: horseNameTxt.text!, jerseyNum: horseJerseyTxt.text!, odds: horseOddsTxt.text!)
        horseList.append(newHorse)
        archiveHorseList()
        
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
            archiveHorseList()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }
    
}



