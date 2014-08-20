//
//  groupManager.swift
//  Group Choice
//
//  Created by Daniel Borstelmann on 7/27/14.
//  Copyright (c) 2014 BorstelDiz Enterprises. All rights reserved.
//

import UIKit

struct friend {
    var name = ""
    var numGroups = 0
    var numEvents = 0
    var isFacebook = false
}

class group: NSObject {
    var groupName = ""
    var numEvents = 0
    var numPeople = 0
    var needsVote = false
    var hasChat = false
    var nextEvent_name = ""
    var nextEvent_dateTime = ""
    var numChats = 0
    
    init(gName: NSString) {
        self.groupName = gName
    }
    
    func addEvent(date: NSString, desc: NSString, keys: NSArray) {
        
    }
    
    func addFriend(friendName: NSString, facebook: Bool) {
    }


}
