//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class BetNumberViewController: UIViewController {
    var neededHorseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horsesNeeded").path!
    }
    var horseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horseList").path!
    }
    var allHorseListsFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("allHorseLists").path!
    }
    var horsesNeeded: Int!
    var horseList: [horse]!
    var allHorseLists: [[horse]]!
    //OUTLETS IN SCENE 2: BET CHOICE
    
    @IBOutlet weak var socialGambBtn: UIButton!
    @IBOutlet weak var dealGambBtn: UIButton!
    @IBOutlet weak var profGambBtn: UIButton!
    @IBOutlet weak var winGambBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let archivedAllHorseLists = NSKeyedUnarchiver.unarchiveObjectWithFile(allHorseListsFilePath) as? [[horse]] {
            allHorseLists = archivedAllHorseLists
        }
        if allHorseLists.count == 1 {
            horseList = allHorseLists[0]
        }else {
            for i in 1...allHorseLists.count-1 {
                if horse.totalAvailableSpots(allHorseLists[i]) > 0 {
                    horseList = allHorseLists[i]
                }
            }
            if horseList == nil {
                createNewHorseList()
                horseList = allHorseLists[allHorseLists.count-1]
            }
        }
    }
    //FUNC & ACTION OF SCENE 2: BET CHOICE
    func storeHorsesNeeded (numHorses: Int) {
        horsesNeeded = numHorses
        NSKeyedArchiver.archiveRootObject(horsesNeeded, toFile: neededHorseFilePath)
    }
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
        NSKeyedArchiver.archiveRootObject(allHorseLists, toFile: allHorseListsFilePath)
        
    }
    
    @IBAction func onSocialGambPressed(sender: AnyObject) {
        if (horse.totalAvailableSpots(horseList)) >= 1 {
            storeHorsesNeeded(1)
        } else {
            createNewHorseList()
            storeHorsesNeeded(1)
        }
    }
    @IBAction func onDealGambPressed(sender: AnyObject) {
        if (horse.totalAvailableSpots(horseList)) >= 3 {
            storeHorsesNeeded(3)
        } else {
            createNewHorseList()
            storeHorsesNeeded(3)
        }
    }
    @IBAction func onProfGambPressed(sender: AnyObject) {
        if (horse.totalAvailableSpots(horseList)) >= 5 {
            storeHorsesNeeded(5)
        } else {
            createNewHorseList()
            storeHorsesNeeded(5)
        }
    }
    @IBAction func onWinGambPressed(sender: AnyObject) {
        if (horse.totalAvailableSpots(horseList)) >= 7 {
            storeHorsesNeeded(7)
        } else {
            createNewHorseList()
            storeHorsesNeeded(7)
        }
    }
    
}





