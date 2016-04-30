//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("objectsArray").path!
    }
    var userName: String?
    var totalBets: Int?
    var horseList: [horse]!
    var _horseList: [horse] {
        if (horseList.isEmpty) {
            horseList = []
        }
        return horseList
    }
    var horsesNeeded: Int?
    var temporaryHorseIndexList: [Int]!
    var temporaryHorseIndexList: [Int] {
        if temporaryHorseIndexList.isEmpty {
            temporaryHorseIndexList = []
        }
        return temporaryHorseIndexList
    }
    
    var newHorse = horse(horseName: "", jerseyNum: "", odds: "")
    
    let cellReuseIdentifier = "protoCell"
    
    @IBOutlet var tableView: UITableView!
    
    //OUTLETS IN SCENE 1: WELCOME SCREEN
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    
    //OUTLETS IN SCENE 2: BET CHOICE
    
    @IBOutlet weak var socialGambBtn: UIButton!
    @IBOutlet weak var dealGambBtn: UIButton!
    @IBOutlet weak var profGambBtn: UIButton!
    @IBOutlet weak var winGambBtn: UIButton!
    
    //OUTLETS IN SCENE 3: WIN PLACE SHOW
    @IBOutlet weak var showHorseBtn: UIButton!
    @IBOutlet weak var winBtn: UIButton!
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    
    @IBOutlet weak var horseOddsLbl: UILabel!
    @IBOutlet weak var horseLbl: UILabel!
    @IBOutlet weak var horseHolderView: UIView!
    
    @IBOutlet weak var horsesLeftStrinLbl: UILabel!
    @IBOutlet weak var horsesLeftNumLbl: UILabel!
    
    //OUTLETS IN SCENE 4: THANK YOU/PAY
     //return to home
    @IBOutlet weak var roseBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let archivedHorseList = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [horse] {
            horseList = archivedHorseList
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FUNC & ACTION OF SCENE 1: WELCOME SCREEN
    @IBAction func onContinuePressed (sender: UIButton!) {
        userName = nameTxt.text!
    }
    
    //FUNC & ACTION OF SCENE 2: BET CHOICE
    func generateRandomHorseIndex() -> Int!{
        if horseList.count > 0 {
            let randIndex = Int(arc4random_uniform(UInt32(horseList.count-1)))
            if !(horseList[randIndex].isBooked()) {
                return randIndex
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
    @IBAction func onSocialGambPressed(sender: AnyObject) {
        horsesNeeded = 1
        temporaryHorseIndexList.append(generateRandomHorseIndex())
    }
    @IBAction func onDealGambPressed(sender: AnyObject) {
        horsesNeeded = 3
    }
    @IBAction func onProfGambPressed(sender: AnyObject) {
        horsesNeeded = 5
    }
    @IBAction func onWinGambPressed(sender: AnyObject) {
        horsesNeeded = 7
    }
    
    
    
    //FUNC & ACTION OF SCENE 3: WIN PLACE SHOW
    func addUserBet (wagerType: String) {
        if (temporaryHorseIndexList.count != 0) {
            (horseList[temporaryHorseIndexList[temporaryHorseIndexList.count-1]]).changeBetterName(userName!, wager: wagerType)
        }
        temporaryHorseIndexList.removeAtIndex(temporaryHorseIndexList.count-1)
    }
    func updateBetScreenLabels () {
        if (temporaryHorseIndexList.count) == 0 {
            payBtn.hidden = false
            horsesLeftNumLbl.text = "\(temporaryHorseIndexList.count)"
        }
    }
    @IBAction func onShowHorsePressed(sender: AnyObject) {
        if temporaryHorseIndexList.count > 0 {
            temporaryHorseIndexList.append(generateRandomHorseIndex())
        }
        horseHolderView.hidden = false
        winBtn.hidden = false
        placeBtn.hidden = false
        showBtn.hidden = false
        horseLbl.hidden = false
        horseOddsLbl.hidden = false
        horsesLeftNumLbl.hidden = false
        horsesLeftStrinLbl.hidden = false
        
        horsesLeftNumLbl.text = "\(temporaryHorseIndexList.count)"
        horseLbl.text = (horseList[0]).getName()
        horseOddsLbl.text = horseList[temporaryHorseIndexList[0]].getOdds()
    }
    @IBAction func onWinPressed(sender: AnyObject) {
        addUserBet("Win")
        updateBetScreenLabels()
    }
    @IBAction func onPlacePressed(sender: AnyObject) {
        addUserBet("Place")
        updateBetScreenLabels()

    }
    @IBAction func onShowPressed(sender: AnyObject) {
        addUserBet("Show")
        updateBetScreenLabels()

    }
    
    //FUNC & ACTION OF SCENE 4: THANK YOU/PAY
    
    
    //APPLICATION MANAGER
    @IBOutlet weak var horseNameTxt: UITextField!
    @IBOutlet weak var horseJerseyTxt: UITextField!
    @IBOutlet weak var horseOddsTxt: UITextField!
    @IBAction func onAddHorse(sender: AnyObject) {
        newHorse = horse(horseName: horseNameTxt.text!, jerseyNum: horseJerseyTxt.text!, odds: horseOddsTxt.text!)
        horseList.append(newHorse)
        NSKeyedArchiver.archiveRootObject(horseList, toFile: filePath)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        
    }
    //UITABLEVIEW
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
            NSKeyedArchiver.archiveRootObject(horseList, toFile: filePath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }

}
    


