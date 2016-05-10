//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController{
    //FILE PATH TO THE STORED 'HORSES NEEDED' VARIABLE
    var neededHorseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horsesNeeded").path!
    }
    //FILE PATH TO THE STORED MAIN HORSE LIST
    var horseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horseList").path!
    }
    //FILE PATH TO THE 'CASH POT' VARIABLE
    var cashPotFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("cashPot").path!
    }
    
    //Universally used variables
    var userName: String!
    var horsesNeeded: Int!
    var cashPot: Int!

    //OUTLETS
    
    //roseBtn is clicked to return to the FirstViewController
    @IBOutlet weak var roseBtn: UIButton!
    
    //label that displays how much the user owes. Label that displays how many horses were purchased
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var numHorsesLabel: UILabel!
    
    //Functions (NON-IBACTION)
    
    /**
     * Method name: determinePrice
     * Description: determines the amount that the user owes based upon how may horses purchased
     * Parameters: numberOfHorses: Int
     * Return: Int
     */
    func determinePrice (numberOfHorses: Int) -> Int {
        switch numberOfHorses {
        case 1:
            return 10
        case 3:
            return 25
        case 5:
            return 40
        case 7:
            return 55
        default:
            return 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //INSTANTIATES THE UNIVERSAL VARIABLES
        if let archivedHorsesNeeded = NSKeyedUnarchiver.unarchiveObjectWithFile(neededHorseFilePath) as? Int {
            horsesNeeded = archivedHorsesNeeded
        }
        if let archivedCashPot = NSKeyedUnarchiver.unarchiveObjectWithFile(cashPotFilePath) as? Int {
            cashPot = archivedCashPot
        }
        
        priceLbl.text = "$\(determinePrice(horsesNeeded))"
        numHorsesLabel.text = "For the \(horsesNeeded) horses, you owe:"
        
        cashPot = cashPot + determinePrice(horsesNeeded)
        NSKeyedArchiver.archiveRootObject(cashPot, toFile: cashPotFilePath)
        
    }
}





