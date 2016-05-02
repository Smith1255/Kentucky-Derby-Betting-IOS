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
    var horsesNeeded: Int!
    //OUTLETS IN SCENE 2: BET CHOICE
    
    @IBOutlet weak var socialGambBtn: UIButton!
    @IBOutlet weak var dealGambBtn: UIButton!
    @IBOutlet weak var profGambBtn: UIButton!
    @IBOutlet weak var winGambBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //FUNC & ACTION OF SCENE 2: BET CHOICE
    func storeHorsesNeeded (numHorses: Int) {
        horsesNeeded = numHorses
        NSKeyedArchiver.archiveRootObject(horsesNeeded, toFile: neededHorseFilePath)
    }
    @IBAction func onSocialGambPressed(sender: AnyObject) {
        storeHorsesNeeded(1)
    }
    @IBAction func onDealGambPressed(sender: AnyObject) {
        storeHorsesNeeded(3)
    }
    @IBAction func onProfGambPressed(sender: AnyObject) {
        storeHorsesNeeded(5)
    }
    @IBAction func onWinGambPressed(sender: AnyObject) {
        storeHorsesNeeded(7)
    }
    
}





