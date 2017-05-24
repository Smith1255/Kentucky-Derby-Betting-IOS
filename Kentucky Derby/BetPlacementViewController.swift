//
//  ViewController.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import UIKit

class BetPlacementViewController: UIViewController {
    //FILE PATH TO THE STORED USER NAME
    var userNameFilePath : String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        return url.appendingPathComponent("userName").path
    }
    //FILE PATH TO THE STORED 'HORSES NEEDED' VARIABLE
    var neededHorseFilePath : String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        return url.appendingPathComponent("horsesNeeded").path
    }
    //FILE PATH TO THE STORED MAIN HORSE LIST
    var allHorseListsFilePath : String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        return url.appendingPathComponent("allHorseLists").path
    }
    
    //Universally used variables
    var userName: String!
    var horsesNeeded: Int!
    var allHorseLists: [[horse]]!
    
    //Secondary, temp Horse lists
    
    var primaryHorseList: [horse]!
    var secondaryHorseList: [horse]!
    var temporaryHorseIndexList: [Int] = []
    
    //Other class variables
    var horsesNeededFirstList: Int!
    var horsesNeededSecondList: Int = 0
    var randomHorse: horse!
    
    //OUTLETS
    
    @IBOutlet weak var showHorseBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!

    @IBOutlet weak var horseHolderView: UIView!
    //All Outlets in the Horse Holder View
    @IBOutlet weak var horseOddsLbl: UILabel!
    @IBOutlet weak var horseLbl: UILabel!
    @IBOutlet weak var horsesLeftStrinLbl: UILabel!
    @IBOutlet weak var horsesLeftNumLbl: UILabel!
    
    //Bet placement buttons
    @IBOutlet weak var winBtn: UIButton!
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet weak var showBtn: UIButton!
   
    @IBOutlet weak var winLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var showLbl: UILabel!
    
    //Functions (NON IBACTION)
    
    /**
     * Method name: createNewHorseList()
     * Description: creates a new blank (no better's names) horse list using a copy of the 'Master' first list
     * Parameters: none
     */
    func createNewHorseList() {
        allHorseLists.append(copyAndEmpty(allHorseLists[0]))
    }
    /**
     * Method name: listNeeded
     * Description: determines the horse list that is needed presently. This is used to ensure that all lists are filled prior to filling a new                                                                               one
     * Parameters: none
     * Return: Int
     */
    func listNeeded () -> Int! {
        if horsesNeededFirstList > 0 {
            return 1
        } else if horsesNeededSecondList > 0 {
            return 2
        } else {
            return nil
        }
    }
    /**
     * Method name: copyAndEmpty
     * Description: creates a new (temp) horse list that is blank (no better's names) and all the same horses
     * Parameters: Horse Array
     * Return: Horse Array
     */
    func copyAndEmpty(_ listToCopy: [horse]) -> [horse]{
        var newHorse: horse!
        var newHorseList: [horse] = []
        for i in 0...listToCopy.count-1 {
            newHorse = horse(horseName: listToCopy[i].getName(), jerseyNum: listToCopy[i].getJersey(), odds: listToCopy[i].getOdds())
            newHorseList.append(newHorse)
        }
        return newHorseList
    }
    /**
     * Method name: generateRandomHorseIndex
     * Description: generates a random index that corresponds to a random horse in the working horse list
     * Parameters: listNum: Int
     * Return: Int
     */
    func generateRandomHorseIndex(_ listNum: Int) -> Int!{
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
    /**
     * Method name: pickRandomHorse
     * Description: picks random horse using the randomly generated index. Updates labels
     * Parameters: ListNum: Int
     * Return: horse
     */
    func pickRandomHorse (_ listNum: Int) -> horse! {
        var randomHorseReturned: horse!
        let randIndex = generateRandomHorseIndex(listNum)
        if listNum == 1 {
            randomHorseReturned = primaryHorseList[randIndex!]
            horsesNeededFirstList = horsesNeededFirstList - 1
        } else if listNum == 2 {
            randomHorseReturned = secondaryHorseList[randIndex!]
            horsesNeededSecondList = horsesNeededSecondList - 1
            
        }else {
            return nil
        }
        horseLbl.text = (randomHorseReturned).getName()
        horseOddsLbl.text = (randomHorseReturned).getOdds()
        
        return randomHorseReturned
    }
    /**
     * Method name: hideUnavailableChoices
     * Description: hides the choices on the screen that have already been chosen. Displays if not
     * Parameters: none
     * Return: none
     */
    func hideUnavailableChoices() {
        if !((randomHorse).isAvailable("Win")) {
            winBtn.isEnabled = false
        }else {
            winBtn.isEnabled = true
        }
        if !((randomHorse).isAvailable("Place")) {
            placeBtn.isEnabled = false
        }else {
            placeBtn.isEnabled = true
        }
        if !((randomHorse).isAvailable("Show")) {
            showBtn.isEnabled = false
        }else {
            showBtn.isEnabled = true
        }
    }
    /**
     * Method name: changeUserBet
     * Description: changes the name on the given horse to the current universal UserName from 'EMPTY'
     * Parameters: Horse: horse, wagerType: String
     * Return: none
     */
    func changeUserBet(_ Horse: horse, wagerType: String) {
        (Horse).changeBetterName(userName, wager: wagerType)
    }
    /**
     * Method name: handleBetButton
     * Description: places the user's name into the horse with the given wager type. Ends the betting if no horses (needed) are left. Picks new horse if not
     * Parameters: wagerType: String
     * Return: none
     */
    func handleBetButton (_ wagerType: String) {
        horsesLeftNumLbl.text = String(horsesNeededFirstList + horsesNeededSecondList)
        changeUserBet(randomHorse, wagerType: wagerType)
        if horsesNeededFirstList == 0 && horsesNeededSecondList == 0 {
            endScene()
        }else {
            randomHorse = pickRandomHorse(listNeeded())
        }
    }
    /**
     * Method name: archiveHorseList
     * Description: archives the changed horseLists in the main allHorseLists using NSKeyedArchiver
     * Parameters: none
     * Return: none
     */
    func archiveHorseList() {
        if secondaryHorseList == nil {
            allHorseLists[(allHorseLists.count)-1] = primaryHorseList
        }else {
            allHorseLists[(allHorseLists.count)-1] = secondaryHorseList
            allHorseLists[(allHorseLists.count)-2] = primaryHorseList
        }
        NSKeyedArchiver.archiveRootObject(allHorseLists, toFile: allHorseListsFilePath)
    }
    /**
     * Method name: endScene
     * Description: hides uneeded buttons, shows the pay button, and archives all the horse lists
     * Parameters: none
     * Return: none
     */
    func endScene() {
        payBtn.isHidden = false
        
        winBtn.isHidden = true
        placeBtn.isHidden = true
        showBtn.isHidden = true
        winLbl.isHidden = true
        placeLbl.isHidden = true
        showLbl.isHidden = true
        
        archiveHorseList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //INSTANTIATES THE UNIVERSAL VARIABLES
        if let archivedUserName = NSKeyedUnarchiver.unarchiveObject(withFile: userNameFilePath) as? String {
            userName = archivedUserName
        }
        if let archivedHorsesNeeded = NSKeyedUnarchiver.unarchiveObject(withFile: neededHorseFilePath) as? Int {
            horsesNeeded = archivedHorsesNeeded
        }
        if let archivedAllHorseLists = NSKeyedUnarchiver.unarchiveObject(withFile: allHorseListsFilePath) as? [[horse]] {
            allHorseLists = archivedAllHorseLists
        }
    }
    
    //@IBACTION
    
    /**
     * Method name: onShowHorsePressed
     * Description: When the user chooses to show horse choices
     */
    @IBAction func onShowHorsePressed(_ sender: AnyObject) {
        //If there are more needed horses than there are spots in the current list
        if horsesNeeded > horse.totalAvailableSpots(allHorseLists[(allHorseLists.count) - 1]) {
            createNewHorseList()
            primaryHorseList = allHorseLists[(allHorseLists.count)-2] //This list needs to be filled first (It is partially full)
            secondaryHorseList = allHorseLists[(allHorseLists.count)-1]
            
            horsesNeededFirstList = horse.totalAvailableSpots(primaryHorseList) //The number of spots left in first list
            horsesNeededSecondList = (horsesNeeded - horsesNeededFirstList)
        }//There are enough spots in the current list to fulfil needed horses
        else if horsesNeeded <= horse.totalAvailableSpots(allHorseLists[(allHorseLists.count) - 1]) {
            horsesNeededFirstList = horsesNeeded
            primaryHorseList = allHorseLists[(allHorseLists.count)-1]
        }
        showHorseBtn.isHidden = true
        horseHolderView.isHidden = false
        winBtn.isHidden = false
        placeBtn.isHidden = false
        showBtn.isHidden = false
        winLbl.isHidden = false
        placeLbl.isHidden = false
        showLbl.isHidden = false
        horseLbl.isHidden = false
        horseOddsLbl.isHidden = false
        horsesLeftNumLbl.isHidden = false
        horsesLeftStrinLbl.isHidden = false
        
        horsesLeftNumLbl.text = String(horsesNeeded)
        randomHorse = pickRandomHorse(listNeeded())
        hideUnavailableChoices()
        
    }
    /**
     * Method name: onWinPressed
     * Description: places the userName into the 'Win' bet type of the randomHorse (declared either at load or after last bet button press)
     */
    @IBAction func onWinPressed(_ sender: AnyObject) {
        handleBetButton("Win")
        hideUnavailableChoices()
    }
    /**
     * Method name: onPlacePressed
     * Description: places the userName into the 'Place' bet type of the randomHorse
     */
    @IBAction func onPlacePressed(_ sender: AnyObject) {
        handleBetButton("Place")
        hideUnavailableChoices()
    }
    /**
     * Method name: onShowPressed
     * Description: places the userName into the 'Show' bet type of the randomHorse
     */
    @IBAction func onShowPressed(_ sender: AnyObject) {
        handleBetButton("Show")
        hideUnavailableChoices()
    }
}

