//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class BetPlacementViewController: UIViewController {
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
    var allHorseListsFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("allHorseLists").path!
    }
    var userName: String!
    var primaryHorseList: [horse]!
    var secondaryHorseList: [horse]!
    var horsesNeeded: Int!
    var temporaryHorseIndexList: [Int] = []
    var allHorseLists: [[horse]]!
    
    var horsesNeededFirstList: Int!
    var horsesNeededSecondList: Int = 0
    var randomHorse: horse!
    
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
        if let archivedUserName = NSKeyedUnarchiver.unarchiveObjectWithFile(userNameFilePath) as? String {
            userName = archivedUserName
        }
        if let archivedHorsesNeeded = NSKeyedUnarchiver.unarchiveObjectWithFile(neededHorseFilePath) as? Int {
            horsesNeeded = archivedHorsesNeeded
        }
        if let archivedAllHorseLists = NSKeyedUnarchiver.unarchiveObjectWithFile(allHorseListsFilePath) as? [[horse]] {
            allHorseLists = archivedAllHorseLists
        }
    }
    
    //@IBACTION AND FUNC OF SCENE 3: WIN PLACE SHOW
    func copyAndEmpty(listToCopy: [horse]) -> [horse]{
        var newHorse: horse!
        var newHorseList: [horse] = []
        for i in 0...listToCopy.count-1 {
            newHorse = horse(horseName: listToCopy[i].getName(), jerseyNum: listToCopy[i].getJersey(), odds: listToCopy[i].getOdds())
            newHorseList.append(newHorse)
        }
        return newHorseList
    }
    func createNewHorseList() {
        allHorseLists.append(copyAndEmpty(allHorseLists[0]))
    }
    func generateRandomHorseIndex(listNum: Int) -> Int!{
        var currentList: [horse]!
        if listNum == 1 {
            currentList = primaryHorseList
        }else if listNum == 2{
            currentList = secondaryHorseList
        }else {
            return nil
        }
        if (currentList.count > 0) {
            var randIndex: Int!
            while randIndex == nil {
                randIndex = Int(arc4random_uniform(UInt32(currentList.count)))
                if (currentList[randIndex].isBooked()) {
                    randIndex = nil
                }
            }
            return randIndex
        }else {
            return nil
        }
    }
    func archiveHorseList() {
        if secondaryHorseList == nil {
            allHorseLists[(allHorseLists.count)-1] = primaryHorseList
        }else {
            allHorseLists[(allHorseLists.count)-1] = secondaryHorseList
            allHorseLists[(allHorseLists.count)-2] = primaryHorseList
        }
        NSKeyedArchiver.archiveRootObject(allHorseLists, toFile: allHorseListsFilePath)
    }
    func endScene() {
        payBtn.hidden = false
        
        winBtn.hidden = true
        placeBtn.hidden = true
        showBtn.hidden = true
        winLbl.hidden = true
        placeLbl.hidden = true
        showLbl.hidden = true
        
        archiveHorseList()
    }
    @IBAction func onShowHorsePressed(sender: AnyObject) {
        if horsesNeeded > horse.totalAvailableSpots(allHorseLists[(allHorseLists.count) - 1]) {
            createNewHorseList()
            primaryHorseList = allHorseLists[(allHorseLists.count)-2]
            secondaryHorseList = allHorseLists[(allHorseLists.count)-1]
            
            horsesNeededFirstList = horse.totalAvailableSpots(primaryHorseList)
            horsesNeededSecondList = (horsesNeeded - horsesNeededFirstList)
        }else if horsesNeeded <= horse.totalAvailableSpots(allHorseLists[(allHorseLists.count) - 1]) {
            horsesNeededFirstList = horsesNeeded
            primaryHorseList = allHorseLists[(allHorseLists.count)-1]
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
        
        horsesLeftNumLbl.text = String(horsesNeeded)
        randomHorse = pickRandomHorse(listNeeded())
        hideUnavailableChoices()
        
    }
    func hideUnavailableChoices() {
        if !((randomHorse).isAvailable("Win")) {
            winBtn.enabled = false
        }else {
            winBtn.enabled = true
        }
        if !((randomHorse).isAvailable("Place")) {
            placeBtn.enabled = false
        }else {
            placeBtn.enabled = true
        }
        if !((randomHorse).isAvailable("Show")) {
            showBtn.enabled = false
        }else {
            showBtn.enabled = true
        }
    }
    func pickRandomHorse (listNum: Int) -> horse! {
        var randomHorseReturned: horse!
        let randIndex = generateRandomHorseIndex(listNum)
        if listNum == 1 {
            randomHorseReturned = primaryHorseList[randIndex]
            horsesNeededFirstList = horsesNeededFirstList - 1
        } else if listNum == 2 {
            randomHorseReturned = secondaryHorseList[randIndex]
            horsesNeededSecondList = horsesNeededSecondList - 1
            
        }else {
            return nil
        }
        horseLbl.text = (randomHorseReturned).getName()
        horseOddsLbl.text = (randomHorseReturned).getOdds()
        
        return randomHorseReturned
    }
    func listNeeded () -> Int! {
        if horsesNeededFirstList > 0 {
            return 1
        } else if horsesNeededSecondList > 0 {
            return 2
        } else {
            return nil
        }
    }
    func changeUserBet(randHorse: horse, wagerType: String) {
        (randHorse).changeBetterName(userName, wager: wagerType)
    }
    func handleBetButton (wagerType: String) {
        horsesLeftNumLbl.text = String(horsesNeededFirstList + horsesNeededSecondList)
        changeUserBet(randomHorse, wagerType: wagerType)
        if horsesNeededFirstList == 0 && horsesNeededSecondList == 0 {
            endScene()
        }else {
            randomHorse = pickRandomHorse(listNeeded())
        }
    }
    @IBAction func onWinPressed(sender: AnyObject) {
        handleBetButton("Win")
        hideUnavailableChoices()
    }
    @IBAction func onPlacePressed(sender: AnyObject) {
        handleBetButton("Place")
        hideUnavailableChoices()
    }
    @IBAction func onShowPressed(sender: AnyObject) {
        handleBetButton("Show")
        hideUnavailableChoices()
    }
}

