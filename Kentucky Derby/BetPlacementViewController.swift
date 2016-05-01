//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class BetPlacementViewController: UIViewController {
    var horseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horseList").path!
    }
    var userNameFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("userName").path!
    }
    var neededHorseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horsesNeeded").path!
    }
    var userName: String!
    var horseList: [horse]!
    var horsesNeeded: Int!
    var temporaryHorseIndexList: [Int] = []

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
    
    @IBOutlet weak var winLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var showLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let archivedHorseList = NSKeyedUnarchiver.unarchiveObjectWithFile(horseFilePath) as? [horse] {
            horseList = archivedHorseList
        }
        if let archivedUserName = NSKeyedUnarchiver.unarchiveObjectWithFile(userNameFilePath) as? String {
            userName = archivedUserName
        }
        if let archivedHorsesNeeded = NSKeyedUnarchiver.unarchiveObjectWithFile(neededHorseFilePath) as? Int {
            horsesNeeded = archivedHorsesNeeded
        }
    }
    
    
    //@IBACTION AND FUNC OF SCENE 3: WIN PLACE SHOW
    func addUserBet (wagerType: String) {
        (horseList[getNextHorseIndex()!]).changeBetterName(userName, wager: wagerType)
        temporaryHorseIndexList.removeAtIndex(temporaryHorseIndexList.count-1)
    }
    func generateRandomHorseIndex() -> Int!{
        if (horseList.count > 0) {
            let randIndex = Int(arc4random_uniform(UInt32(horseList.count)))
            if !(horseList[randIndex].isBooked()) {
                return randIndex
            }else {
                return nil
            }
        }else {
            return nil
        }
    }
    func getNextHorseIndex () -> Int? {
        if temporaryHorseIndexList.count > 0 {
            return temporaryHorseIndexList[temporaryHorseIndexList.count-1]
        }else {
            return nil
        }
    }
    func newHorseLabels () {
        horsesLeftNumLbl.text = "\(temporaryHorseIndexList.count)"
        horseLbl.text = (horseList[getNextHorseIndex()!]).getName()
        horseOddsLbl.text = (horseList[getNextHorseIndex()!]).getOdds()
    }
    func endScene() {
        payBtn.hidden = false
        
        winBtn.hidden = true
        placeBtn.hidden = true
        showBtn.hidden = true
        winLbl.hidden = true
        placeLbl.hidden = true
        showLbl.hidden = true

        horsesLeftNumLbl.text = "\(temporaryHorseIndexList.count)"
        
        NSKeyedArchiver.archiveRootObject(horseList, toFile: horseFilePath)        
    }
    @IBAction func onShowHorsePressed(sender: AnyObject) {
        while horsesNeeded > 0 {
            temporaryHorseIndexList.append(generateRandomHorseIndex())
            horsesNeeded = horsesNeeded - 1
        }
        showHorseBtn.hidden = true
        horseHolderView.hidden = false
        winBtn.hidden = false
        placeBtn.hidden = false
        showBtn.hidden = false
        winLbl.hidden = false
        placeLbl.hidden = false
        showLbl.hidden = false
        horseLbl.hidden = false
        horseOddsLbl.hidden = false
        horsesLeftNumLbl.hidden = false
        horsesLeftStrinLbl.hidden = false

        horsesLeftNumLbl.text = "\(temporaryHorseIndexList.count)"
        horseLbl.text = (horseList[getNextHorseIndex()!]).getName()
        horseOddsLbl.text = (horseList[getNextHorseIndex()!]).getOdds()
    }
    @IBAction func onWinPressed(sender: AnyObject) {
        addUserBet("Win")
        if temporaryHorseIndexList.count == 0 {
            endScene()
        } else {
            newHorseLabels()
        }
    }
    @IBAction func onPlacePressed(sender: AnyObject) {
        addUserBet("Place")
        if temporaryHorseIndexList.count == 0 {
            endScene()
        }else {
            newHorseLabels()
        }
        
    }
    @IBAction func onShowPressed(sender: AnyObject) {
        addUserBet("Show")
        if temporaryHorseIndexList.count == 0 {
            endScene()
        }else {
            newHorseLabels()
        }
        
    }
}
