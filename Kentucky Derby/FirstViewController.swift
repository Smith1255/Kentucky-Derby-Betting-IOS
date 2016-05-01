//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var userNameFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("userName").path!
    }
    var horseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horseList").path!
    }
    var neededHorseFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("horsesNeeded").path!
    }
    var firstTimeFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("firstTime").path!
    }
    
    var userName: String!
    var isFirstTime: Bool = true
    
    //OUTLETS IN SCENE 1: WELCOME SCREEN
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var labelLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let isFirstTime = NSKeyedUnarchiver.unarchiveObjectWithFile(firstTimeFilePath) as? Bool {
            self.isFirstTime = isFirstTime
        }
        if (isFirstTime) {
            isFirstTime = false
            let tempUserName: String = "None"
            let newHorse = horse(horseName: "Delete", jerseyNum: "", odds: "")
            let horseList: [horse] = [newHorse]
            let horsesNeeded = 1
            NSKeyedArchiver.archiveRootObject(tempUserName, toFile: userNameFilePath)
            NSKeyedArchiver.archiveRootObject(horseList, toFile: horseFilePath)
            NSKeyedArchiver.archiveRootObject(horsesNeeded, toFile: neededHorseFilePath)
            NSKeyedArchiver.archiveRootObject(isFirstTime, toFile: firstTimeFilePath)
        }
    }
    
    //FUNC & ACTION OF SCENE 1: WELCOME SCREEN
    @IBAction func onContinuePressed (sender: UIButton!) {
        userName = nameTxt.text!
        
        NSKeyedArchiver.archiveRootObject(userName, toFile: userNameFilePath)
    }
}







