//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController{
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
    var userName: String!
    var horsesNeeded: Int!

    //OUTLETS IN SCENE 4: THANK YOU/PAY
    //return to home
    @IBOutlet weak var roseBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var numHorsesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let archivedHorsesNeeded = NSKeyedUnarchiver.unarchiveObjectWithFile(neededHorseFilePath) as? Int {
            horsesNeeded = archivedHorsesNeeded
        }
        priceLbl.text = "$\(determinePrice(horsesNeeded))"
        numHorsesLabel.text = "For the \(horsesNeeded) horses, you owe:"
    }
    
    //FUNC & ACTION OF SCENE 4: THANK YOU/PAY
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
}




