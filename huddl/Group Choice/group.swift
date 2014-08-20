//
//  groupManager.swift
//  Group Choice
//
//  Created by Daniel Borstelmann on 7/27/14.
//  Copyright (c) 2014 BorstelDiz Enterprises. All rights reserved.
//

import UIKit


class group: NSObject {
    var groupName = ""
    var numEvents = 0
    var numPeople = 0
    var needsVote = false
    var hasChat = false
    var nextEvent_name = ""
    var nextEvent_dateTime = ""
    var numChats = 0
    var id = ""
    var friendList = NSMutableArray()
    var eventList = NSMutableArray()
    
    init(gName: NSString) {
        self.groupName = gName
    }
    
    func addEvent(date: NSString, desc: NSString, keys: NSArray) {
        
    }
    
    func addFriend(id: NSString) {
        friendList.addObject(id)
    }


}
