//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class PayoutManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var allHorseListsFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("allHorseLists").path!
    }
    var allHorseLists: [[horse]]!
    var firstPlaceHorseJersey: String!
    var secondPlaceHorseJersey: String!
    var thirdPlaceHorseJersey: String!
    var winNames: [String] = []
    var placeNames: [String] = []
    var showNames: [String] = []
    
    @IBOutlet weak var firstPlaceHorse: UITextField!
    @IBOutlet weak var secondPlaceHorse: UITextField!
    @IBOutlet weak var thirdPlaceHorse: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let archivedAllHorseList = NSKeyedUnarchiver.unarchiveObjectWithFile(allHorseListsFilePath) as? [[horse]] {
            allHorseLists = archivedAllHorseList
        }
        winPotTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "winPot")
        placePotTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "placePot")
        showPotTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "showPot")
    }
    func determineWinners() {
        for i in 0...(allHorseLists.count - 1) {
            for j in 0...(allHorseLists[i].count - 1) {
                switch allHorseLists[i][j].getJersey() {
                    case firstPlaceHorseJersey:
                        winNames.append(allHorseLists[i][j].getNameForWager("Win"))
                    case secondPlaceHorseJersey:
                        placeNames.append(allHorseLists[i][j].getNameForWager("Place"))
                    case thirdPlaceHorseJersey:
                        showNames.append(allHorseLists[i][j].getNameForWager("Show"))
                    default: break
                }
            }
        }
    }
    func isSafe(horseJerseyTxt: String!) -> Bool{
        for i in 0...(allHorseLists[0].count - 1){
            if horseJerseyTxt == allHorseLists[0][i].getJersey() {
                return true
            }
        }
        return false
    }
    @IBAction func onRegisterHorses(sender: AnyObject) {
        if (isSafe(firstPlaceHorse.text)) {
            firstPlaceHorseJersey = firstPlaceHorse.text
        }
        if (isSafe(secondPlaceHorse.text)) {
            secondPlaceHorseJersey = secondPlaceHorse.text
        }
        if (isSafe(thirdPlaceHorse.text)) {
            thirdPlaceHorseJersey = thirdPlaceHorse.text
        }
        determineWinners()
        reloadTable()
    }
    
    
    //UITABLEVIEW
    func reloadTable () {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.winPotTableView.reloadData()
        })
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.placePotTableView.reloadData()
        })
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.showPotTableView.reloadData()
        })
    }
    @IBOutlet weak var winPotTableView: UITableView!
    @IBOutlet weak var placePotTableView: UITableView!
    @IBOutlet weak var showPotTableView: UITableView!

    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return winNames.count
    }
     //create a cell for each table view row
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if tableView == self.winPotTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("winPot", forIndexPath: indexPath)
            cell!.textLabel!.text = winNames[indexPath.row]
            return cell!
        }
        if tableView == self.placePotTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("placePot", forIndexPath: indexPath)
            cell!.textLabel!.text = placeNames[indexPath.row]
            return cell!
        }
        if tableView == self.showPotTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("showPot", forIndexPath: indexPath)
            cell!.textLabel!.text = showNames[indexPath.row]
            return cell!
        }
    
        return cell!
    }
    
}



