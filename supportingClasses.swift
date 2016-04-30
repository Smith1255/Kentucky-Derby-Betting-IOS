//
//  File.swift
//  Kentucky Derby
//
//  Created by Andrew Smith on 4/27/16.
//  Copyright © 2016 KM187. All rights reserved.
//

import Foundation

class horse: NSObject, NSCoding {
    private static var numSpotsAvail: Int = 0
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
    
    required convenience init?(coder decoder: NSCoder) {
        guard let horseName = decoder.decodeObjectForKey("horseName") as? String,
            let jerseyNum = decoder.decodeObjectForKey("jerseyNum") as? String,
            let odds = decoder.decodeObjectForKey("odds") as? String,
            let straightWager = decoder.decodeObjectForKey("straightWager") as? [String:String]
            else { return nil }
        
        self.init(
            horseName: horseName,
            jerseyNum: jerseyNum,
            odds: odds
            )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.horseName, forKey: "horseName")
        coder.encodeObject(self.jerseyNum, forKey: "jerseyNum")
        coder.encodeObject(self.odds, forKey: "odds")
        coder.encodeObject(self.straightWager, forKey: "straightWager")
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
    
    func addBetter(name: String, position: String) {
        straightWager[position] = name
    }
    func changeBetter(newName: String, wager: String) {
        straightWager[wager] = newName
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
    func changeBetterName(newName: String, wager: String) {
        straightWager[wager] = newName
    }
    func getNameForWager (wagerType: String) -> String {
        if (straightWager[wagerType]! != "EMPTY") {
            return straightWager[wagerType]!
        }else {
            return "NONE"
        }
    }
}