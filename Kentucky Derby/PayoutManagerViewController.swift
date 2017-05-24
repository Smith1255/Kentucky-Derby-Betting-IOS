//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class PayoutManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    //Other class variables
    
    //specific pots designated for the winners of the 'Win', 'Place', and 'Show'
    var winPot: Int = 0
    var placePot: Int = 0
    var showPot: Int = 0
    
    //user inputted horse jersey numbers for the winning horses
    var firstPlaceHorseJersey: String!
    var secondPlaceHorseJersey: String!
    var thirdPlaceHorseJersey: String!
    
    //arrays holding the winning names
    var winNames: [String] = []
    var placeNames: [String] = []
    var showNames: [String] = []
    
    //OUTLETS
    @IBOutlet weak var firstPlaceHorse: UITextField!
    @IBOutlet weak var secondPlaceHorse: UITextField!
    @IBOutlet weak var thirdPlaceHorse: UITextField!
    
    @IBOutlet weak var winPotSld: UISlider!
    @IBOutlet weak var placePotSld: UISlider!
    
    @IBOutlet weak var totalPotLbl: UILabel!
    @IBOutlet weak var winPotLbl: UILabel!
    @IBOutlet weak var placePotLbl: UILabel!
    @IBOutlet weak var showPotLbl: UILabel!
    
    @IBOutlet weak var winPotIndividualLbl: UILabel!
    @IBOutlet weak var placePotIndividualLbl: UILabel!
    @IBOutlet weak var showPotIndividualLbl: UILabel!
    
    @IBOutlet weak var cashAmountLbl: UITextField!
    
    //Functions
    /**
     * Method name: determineWinners
     * Description: uses the given jersey numbers to place the winning names in the win, place, and show name arrays
     * Parameters: none
     * Return: none
     */
    func determineWinners() {
        for i in 0...(allHorseLists.count - 1) {
            for j in 0...(allHorseLists[i].count - 1) {
                switch allHorseLists[i][j].getJersey() {
                case firstPlaceHorseJersey:
                    winNames.append(allHorseLists[i][j].getNameForWager("Win"))
                    placeNames.append(allHorseLists[i][j].getNameForWager("Place"))
                    showNames.append(allHorseLists[i][j].getNameForWager("Show"))
                case secondPlaceHorseJersey:
                    placeNames.append(allHorseLists[i][j].getNameForWager("Place"))
                    showNames.append(allHorseLists[i][j].getNameForWager("Show"))
                case thirdPlaceHorseJersey:
                    showNames.append(allHorseLists[i][j].getNameForWager("Show"))
                default: break
                }
            }
        }
    }
    /**
     * Method name: isSafe
     * Description: determines if the given horse (jersey number) exists in the list of horse names
     * Parameters: horseJerseyTxt: String!
     * Return: Bool
     */
    func isSafe(_ horseJerseyTxt: String!) -> Bool{
        for i in 0...(allHorseLists[0].count - 1){
            if horseJerseyTxt == allHorseLists[0][i].getJersey() {
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //INSTANTIATES THE UNIVERSAL VARIABLES
        if let archivedAllHorseList = NSKeyedUnarchiver.unarchiveObject(withFile: allHorseListsFilePath) as? [[horse]] {
            allHorseLists = archivedAllHorseList
        }
        if let archivedCashPot = NSKeyedUnarchiver.unarchiveObject(withFile: cashPotFilePath) as? Int {
            cashPot = archivedCashPot
        }
        totalPotLbl.text = "$\(cashPot!)"
        
        winPotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "winPot")
        placePotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "placePot")
        showPotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "showPot")
    }
    //IBACTION
    
    /**
     * Method name: onRegisterHorses
     * Description: checks if the given horse is safe (see method documentation), and then sets the winning horses
     */
    @IBAction func onRegisterHorses(_ sender: AnyObject) {
        if (isSafe(firstPlaceHorse.text)) {
            firstPlaceHorseJersey = firstPlaceHorse.text
            
            if (isSafe(secondPlaceHorse.text)) {
                secondPlaceHorseJersey = secondPlaceHorse.text
                
                if (isSafe(thirdPlaceHorse.text)) {
                    thirdPlaceHorseJersey = thirdPlaceHorse.text
                    determineWinners()
                    reloadTable()
                }
            }
        }
    }
    /**
     * Method name: onWinPotSlide
     * Description: directly sets the pot amount for the 'Win' pot and indirectly sets the 'Place' pot
     */
    @IBAction func onWinPotSlide(_ sender: AnyObject) {
        var sidePot: Int!
        if winNames.count > 0 {
            winPotSld.maximumValue = Float(1)
            winPot = Int(winPotSld.value * Float(cashPot)) //the values of the slide as a percent of the total cash pot
            winPotLbl.text = "$\(winPot)"
            
            sidePot = cashPot - winPot
            
            //sets the value of the 'Place' pot to the remaining cash, also setting the place slider to the maximum
            placePot = sidePot
            placePotSld.maximumValue = Float(1)
            placePotSld.setValue(1, animated: true)
            placePotLbl.text = "$\(placePot)"
            
            winPotIndividualLbl.text = ":$\(Int(Double(winPot) / Double(winNames.count)))"
            placePotIndividualLbl.text = ":$\(Int(Double(placePot) / Double(placeNames.count)))"
        }
    }
    /**
     * Method name: onPlacePotSlide
     * Description: directly sets the pot amount for the 'Place' pot and indirectly sets the 'Show' pot
     */
    @IBAction func onPlacePotSlide(_ sender: AnyObject) {
        let sidePot: Int = Int(cashPot - winPot)
        
        if sidePot != 0 {
            placePot = Int(placePotSld.value * Float(sidePot))
            placePotLbl.text = "$\(placePot)"
            placePotIndividualLbl.text = ":$\(Int(Double(placePot) / Double(placeNames.count)))"
            
            showPot = cashPot - (placePot + winPot)
            showPotLbl.text = "$\(showPot)"
            showPotIndividualLbl.text = ":$\(Int(Double(showPot) / Double(showNames.count)))"
        }
    }
    /**
     * Method name: onAmountSubtracted
     * Description: subtracts the given amount from the cash pot
     */
    @IBAction func onAmountSubtracted(_ sender: AnyObject) {
        if winNames.count > 0 {
            cashPot = cashPot - Int(cashAmountLbl.text!)!
            NSKeyedArchiver.archiveRootObject(cashPot, toFile: cashPotFilePath)
            totalPotLbl.text = "$\(cashPot)"
        }
    }
    /**
     * Method name: onAmountAdded
     * Description: adds the given amount from the cash pot
     */
    @IBAction func onAmountAdded(_ sender: AnyObject) {
        if winNames.count > 0 {
            cashPot = cashPot + Int(cashAmountLbl.text!)!
            NSKeyedArchiver.archiveRootObject(cashPot, toFile: cashPotFilePath)
            totalPotLbl.text = "$\(cashPot)"
        }
        
    }
    
    //UITABLEVIEW
    func reloadTable () {
        DispatchQueue.main.async(execute: { () -> Void in
            self.winPotTableView.reloadData()
        })
        DispatchQueue.main.async(execute: { () -> Void in
            self.placePotTableView.reloadData()
        })
        DispatchQueue.main.async(execute: { () -> Void in
            self.showPotTableView.reloadData()
        })
    }
    @IBOutlet weak var winPotTableView: UITableView!
    @IBOutlet weak var placePotTableView: UITableView!
    @IBOutlet weak var showPotTableView: UITableView!
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.winPotTableView {
            return winNames.count
        }
        if tableView == self.placePotTableView {
            return placeNames.count
        }
        if tableView == self.showPotTableView {
            return showNames.count
        }
        return 0
    }
    //create a cell for each table view row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if tableView == self.winPotTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "winPot", for: indexPath)
            cell!.textLabel!.text = winNames[(indexPath as NSIndexPath).row]
            return cell!
        }
        if tableView == self.placePotTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "placePot", for: indexPath)
            cell!.textLabel!.text = placeNames[(indexPath as NSIndexPath).row]
            return cell!
        }
        if tableView == self.showPotTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "showPot", for: indexPath)
            cell!.textLabel!.text = showNames[(indexPath as NSIndexPath).row]
            return cell!
        }
        
        return cell!
    }
    
}



