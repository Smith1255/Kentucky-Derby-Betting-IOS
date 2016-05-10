//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class BetNumberViewController: UIViewController {
    //FILE PATH TO THE STORED 'HORSES NEEDED' VARIABLE
    var neededHorseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horsesNeeded").path!
    }
    
    //Universally used variables
    var horsesNeeded: Int! //Number of horses that the user selects to bet on
    
    //OUTLETS (# horses wanted buttons)
    
    @IBOutlet weak var socialGambBtn: UIButton!
    @IBOutlet weak var dealGambBtn: UIButton!
    @IBOutlet weak var profGambBtn: UIButton!
    @IBOutlet weak var winGambBtn: UIButton!
    
    //Functions (NON IBACTION)
    func storeHorsesNeeded (numHorses: Int) {
        horsesNeeded = numHorses
        NSKeyedArchiver.archiveRootObject(horsesNeeded, toFile: neededHorseFilePath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //IBACTION
    
    /**
     * Method name: onSocialGambPressed
     * Description: stores one (1) in the universal variable horsesNeeded
     */
    @IBAction func onSocialGambPressed(sender: AnyObject) {
        storeHorsesNeeded(1)
    }
    /**
     * Method name: onDealGambPressed
     * Description: stores one (3) in the universal variable horsesNeeded
     */
    @IBAction func onDealGambPressed(sender: AnyObject) {
        storeHorsesNeeded(3)
    }
    /**
     * Method name: onProfGambPressed
     * Description: stores one (5) in the universal variable horsesNeeded
     */
    @IBAction func onProfGambPressed(sender: AnyObject) {
        storeHorsesNeeded(5)
    }
    /**
     * Method name: onWinGambPressed
     * Description: stores one (7) in the universal variable horsesNeeded
     */
    @IBAction func onWinGambPressed(sender: AnyObject) {
        storeHorsesNeeded(7)
    }
    
}





