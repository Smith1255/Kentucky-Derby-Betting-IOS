//: Playground - noun: a place where people can play
//
//  File.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import Foundation

class horse: NSObject, NSCoding {
    private var horseName: String = "NAME"
    private var jerseyNum: String = ""
    private var odds: String = "1/2"
    private var straightWager: [String: String] = [
        "Win": "EMPTY",
        "Place": "EMPTY",
        "Show": "EMPTY",
        ]
    init (horseName: String, jerseyNum: String, odds: String) {
        self.horseName = horseName
        self.jerseyNum = jerseyNum
        self.odds = odds
    }
    convenience init (horseName: String, jerseyNum: String, odds: String, straightWager: [String: String]) {
        self.init(
            horseName: horseName,
            jerseyNum: jerseyNum,
            odds: odds
        )
        self.straightWager["Win"] = straightWager["Win"]
        self.straightWager["Place"] = straightWager["Place"]
        self.straightWager["Show"] = straightWager["Show"]
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let horseName = decoder.decodeObjectForKey("horseName") as? String,
            let jerseyNum = decoder.decodeObjectForKey("jerseyNum") as? String,
            let odds = decoder.decodeObjectForKey("odds") as? String,
            let straightWager = decoder.decodeObjectForKey("straightWager") as? [String:String]
            else { return nil }
        
        self.init(
            horseName: horseName,
            jerseyNum: jerseyNum,
            odds: odds,
            straightWager: straightWager
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.horseName, forKey: "horseName")
        coder.encodeObject(self.jerseyNum, forKey: "jerseyNum")
        coder.encodeObject(self.odds, forKey: "odds")
        coder.encodeObject(self.straightWager, forKey: "straightWager")
    }
    func changeOdds(newOdds: String) {
        odds = newOdds
    }
    func getName () -> String {
        return horseName
    }
    func getOdds () -> String {
        return odds
    }
    func getJersey () -> String {
        return jerseyNum
    }
    func changeBetterName(newName: String, wager: String) {
        straightWager[wager] = newName
    }
    func getNameForWager (wagerType: String) -> String {
        return straightWager[wagerType]!
    }
    func isBooked() -> Bool {
        if (straightWager["Win"] == "EMPTY") {
            return false
        }
        else if (straightWager["Place"] == "EMPTY") {
            return false
        }
        else if (straightWager["Show"] == "EMPTY") {
            return false
        }
        else {return true}
    }
    func isAvailable(wagerType: String) -> Bool {
        return (straightWager[wagerType] == "EMPTY")
    }
    func availableSpots(wagerType: String) -> Int! {
        if self.isAvailable(wagerType) {
            return 1
        }
        else {
            return 0
        }
    }
    static func totalAvailableSpots(horseList: [horse]) -> Int! {
        var numSpots = 0
        for i in 0...horseList.count-1 {
            numSpots += horseList[i].availableSpots("Win")
            numSpots += horseList[i].availableSpots("Place")
            numSpots += horseList[i].availableSpots("Show")
        }
        
        return numSpots
    }
    
    func clearBetterNames() {
        straightWager["Win"] = "EMPTY"
        straightWager["Place"] = "EMPTY"
        straightWager["Show"] = "EMPTY"
    }
    
    
}