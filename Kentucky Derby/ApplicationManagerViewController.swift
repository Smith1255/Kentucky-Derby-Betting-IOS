//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class ApplicationManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //FILE PATH TO THE STORED MAIN HORSE LIST
    var allHorseListsFilePath : String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        return url.appendingPathComponent("allHorseLists").path
    }
    //FILE PATH TO THE 'CASH POT' VARIABLE
    var cashPotFilePath : String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        return url.appendingPathComponent("cashPot").path
    }
    
    //Universally used variables
    var allHorseLists: [[horse]]!
    var cashPot: Int!
    
    //Used for the UITABLEVIEW cells
    let cellReuseIdentifier = "protoCell"
    
    //Other class variables
    var newHorse = horse(horseName: "", jerseyNum: "", odds: "")
    var horseList: [horse]!
    
    //OUTLETS
    @IBOutlet weak var horseNameTxt: UITextField!
    @IBOutlet weak var horseJerseyTxt: UITextField!
    @IBOutlet weak var horseOddsTxt: UITextField!
    
    @IBOutlet weak var numberOfSpotsLbl: UILabel!
    
    @IBOutlet weak var horseListChooserSgm: UISegmentedControl!
    
    
    @IBOutlet weak var betterNameTxt: UITextField!
    @IBOutlet weak var betterJerseyTxt: UITextField!
    @IBOutlet weak var wagerTypeTxt: UITextField!
    @IBOutlet weak var amountPaidTxt: UITextField!
    
    //Functions (NON IBACTION; NON TABLE)
    
    /**
     * Method name: setNumSegments
     * Description: Sets the number of segments shown. The segments correspond to the horseLists
     * Parameters: none
     * Return: none
     */
    func setNumSegments() {
        let numOfSegments = (allHorseLists.count)
        switch numOfSegments {
        case 1:
            horseListChooserSgm.setEnabled(false, forSegmentAt: 1)
            horseListChooserSgm.removeSegment(at: 2, animated: true)
            horseListChooserSgm.removeSegment(at: 3, animated: true)
        case 2:
            horseListChooserSgm.setEnabled(true, forSegmentAt: 1)
            horseListChooserSgm.removeSegment(at: 2, animated: true)
            horseListChooserSgm.removeSegment(at: 3, animated: true)
        case 3:
            horseListChooserSgm.setEnabled(true, forSegmentAt: 1)
            horseListChooserSgm.insertSegment(withTitle: "Third", at: 2, animated: true)
            horseListChooserSgm.removeSegment(at: 4, animated: true)
        case 4:
            horseListChooserSgm.setEnabled(true, forSegmentAt: 1)
            horseListChooserSgm.insertSegment(withTitle: "Third", at: 2, animated: true)
            horseListChooserSgm.insertSegment(withTitle: "Fourth", at: 3, animated: true)
        default: break
        }
    }
    /**
     * Method name: archiveHorseList
     * Description: archives the changed horseLists in the main allHorseLists using NSKeyedArchiver
     * Parameters: none
     * Return: none
     */
    func archiveHorseList () {
        allHorseLists[allHorseLists.count-1] = horseList
        NSKeyedArchiver.archiveRootObject(allHorseLists, toFile: allHorseListsFilePath)
    }
    /**
     * Method name: copyAndEmpty
     * Description: creates a new (temp) horse list that is blank (no better's names) and all the same horses
     * Parameters: Horse Array
     * Return: Horse Array
     */
    func copyAndEmpty(_ listToCopy: [horse]) -> [horse]{
        var newHorse: horse!
        var newHorseList: [horse] = []
        for i in 0...listToCopy.count-1 {
            newHorse = horse(horseName: listToCopy[i].getName(), jerseyNum: listToCopy[i].getJersey(), odds: listToCopy[i].getOdds())
            newHorseList.append(newHorse)
        }
        return newHorseList
    }
    /**
     * Method name: reloadTable
     * Description: reloads the table to reflect changes
     * Parameters: none
     * Return: none
     */
    func reloadTable(){
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //INSTANTIATES THE UNIVERSAL VARIABLES
        if let archivedAllHorseList = NSKeyedUnarchiver.unarchiveObject(withFile: allHorseListsFilePath) as? [[horse]] {
            allHorseLists = archivedAllHorseList
        }
        if let archivedCashPot = NSKeyedUnarchiver.unarchiveObject(withFile: cashPotFilePath) as? Int{
            cashPot = archivedCashPot
        }
        horseList = allHorseLists[0]
        setNumSegments()
        
        //Sets the label to equal the total number of available spots in the current working horseList
        numberOfSpotsLbl.text = String(horse.totalAvailableSpots(horseList))
        
    }
    
    //IBACTION
    
    /**
     * Method name: onDeleteBetter
     * Description: deletes the name in the horse at the wager type specified by the betterNameTxt, wagerTypeTxt, and betterJerseyTxt fields
     */
    @IBAction func onDeleteBetter(_ sender: AnyObject) {
        for i in 0...horseList.count-1 {
            if horseList[i].getJersey() == betterJerseyTxt.text {
                if horseList[i].getNameForWager(wagerTypeTxt.text!) == betterNameTxt.text! {
                    horseList[i].changeBetterName("EMPTY", wager: "Win")
                    
                    //subtracts the amount paid out of the total pot
                    cashPot = cashPot - Int(amountPaidTxt.text!)!
                }
            }
        }
        
        archiveHorseList()
        NSKeyedArchiver.archiveRootObject(cashPot, toFile: cashPotFilePath)
        
        reloadTable()
    }
    /**
     * Method name: onListChose
     * Description: changes current working horse list to the one chosen by the horseListChooser segment
     */
    @IBAction func onListChosen(_ sender: AnyObject) {
        let chosenList = horseListChooserSgm.selectedSegmentIndex
        if chosenList < allHorseLists.count {
            horseList = allHorseLists[chosenList]
            reloadTable()
        }
        numberOfSpotsLbl.text = String(horse.totalAvailableSpots(horseList))
        
    }
    /**
     * Method name: onDeletePressed
     * Description: deletes the current working list by removing it from the array. If the current list is the last one, it clears it
     */
    @IBAction func onDeleteListPressed(_ sender: AnyObject) {
        if allHorseLists.count == 1 {
            allHorseLists[0] = copyAndEmpty(allHorseLists[0])
            horseList = allHorseLists[0]
            cashPot = 0
            NSKeyedArchiver.archiveRootObject(cashPot, toFile: cashPotFilePath)
        }else {
            let selectedList = horseListChooserSgm.selectedSegmentIndex
            horseList = allHorseLists[0]
            horseListChooserSgm.selectedSegmentIndex = 0
            allHorseLists.remove(at: selectedList)
            setNumSegments()
        }
        archiveHorseList()
        numberOfSpotsLbl.text = String(horse.totalAvailableSpots(horseList))
        reloadTable()
    }
    /**
     * Method name: onClearAllPressed
     * Description: deletes all of the lists but the first on
     */
    @IBAction func onClearAllPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Warning", message:"Are You Sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            self.allHorseLists.removeLast(self.allHorseLists.count-1)
            self.horseList = self.allHorseLists[0]
            self.setNumSegments()
            self.archiveHorseList()
            self.reloadTable()
            })
        self.present(alert, animated: true){}
        numberOfSpotsLbl.text = String(horse.totalAvailableSpots(horseList))
    }
    /**
     * Method name: onAddHorse
     * Description: adds or changes the specified horse using the text fields
     */
    @IBAction func onAddHorse(_ sender: AnyObject) {
        var isChange = false //if the user wants to just change the specified horse
        if (!(horseList.count == 0)) {
            for horse in 0...(horseList.count - 1) {
                //if the given jersey number exists, then the user wants to change the existing horse
                if horseJerseyTxt.text == horseList[horse].getJersey() {
                    horseList[horse].changeOdds(horseOddsTxt.text!)
                    isChange = true
                }
            }
        }
        if !isChange {
            newHorse = horse(horseName: horseNameTxt.text!, jerseyNum: horseJerseyTxt.text!, odds: horseOddsTxt.text!)
            horseList.append(newHorse)
            numberOfSpotsLbl.text = String(horse.totalAvailableSpots(horseList))
        }
        archiveHorseList()
        
        reloadTable()
    }
    
    //UITABLEVIEW
    @IBOutlet var tableView: UITableView!
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.horseList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        cell.horseNameCellLbl.text = self.horseList[(indexPath as NSIndexPath).row].getName()
        cell.horseOddsCellLbl.text = self.horseList[(indexPath as NSIndexPath).row].getOdds()
        cell.horseJerseyLbl.text = self.horseList[(indexPath as NSIndexPath).row].getJersey()
        cell.winCellNameLbl.text = self.horseList[(indexPath as NSIndexPath).row].getNameForWager("Win")
        cell.placeCellNameLbl.text = self.horseList[(indexPath as NSIndexPath).row].getNameForWager("Place")
        cell.showCellNameLbl.text = self.horseList[(indexPath as NSIndexPath).row].getNameForWager("Show")
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            horseList.remove(at: (indexPath as NSIndexPath).row)
            archiveHorseList()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            reloadTable()
        }
    }
    
}



