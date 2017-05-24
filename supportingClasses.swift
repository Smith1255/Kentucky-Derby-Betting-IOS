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
    fileprivate var horseName: String = "NAME"
    fileprivate var jerseyNum: String = ""
    fileprivate var odds: String = "1/2"
    fileprivate var straightWager: [String: String] = [
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
        guard let horseName = decoder.decodeObject(forKey: "horseName") as? String,
            let jerseyNum = decoder.decodeObject(forKey: "jerseyNum") as? String,
            let odds = decoder.decodeObject(forKey: "odds") as? String,
            let straightWager = decoder.decodeObject(forKey: "straightWager") as? [String:String]
            else { return nil }
        
        self.init(
            horseName: horseName,
            jerseyNum: jerseyNum,
            odds: odds,
            straightWager: straightWager
        )
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.horseName, forKey: "horseName")
        coder.encode(self.jerseyNum, forKey: "jerseyNum")
        coder.encode(self.odds, forKey: "odds")
        coder.encode(self.straightWager, forKey: "straightWager")
    }
    func getName () -> String {
        return horseName
    }
    func getOdds () -> String {
        return odds
    }
    func changeOdds(_ newOdds: String) {
        odds = newOdds
    }
    func getJersey () -> String {
        return jerseyNum
    }
    func changeJersey (_ jerseyNum: String) {
        self.jerseyNum = jerseyNum
    }
    func getNameForWager (_ wagerType: String) -> String {
        return straightWager[wagerType]!
    }
    func changeBetterName(_ newName: String, wager: String) {
        straightWager[wager] = newName
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
    func isAvailable(_ wagerType: String) -> Bool {
        return (straightWager[wagerType] == "EMPTY")
    }
    func availableSpots(_ wagerType: String) -> Int! {
        if self.isAvailable(wagerType) {
            return 1
        }
        else {
            return 0
        }
    }
    func clearBetterNames() {
        straightWager["Win"] = "EMPTY"
        straightWager["Place"] = "EMPTY"
        straightWager["Show"] = "EMPTY"
    }
    
    static func totalAvailableSpots(_ horseList: [horse]) -> Int! {
        var numSpots = 0
        for i in 0...horseList.count-1 {
            numSpots += horseList[i].availableSpots("Win")
            numSpots += horseList[i].availableSpots("Place")
            numSpots += horseList[i].availableSpots("Show")
        }
        
        return numSpots
    }
    
    
    
}
