//
//  huddl.swift
//  Group Choice
//
//  Created by Daniel Borstelmann on 8/20/14.
//  Copyright (c) 2014 BorstelDiz Enterprises. All rights reserved.
//

import UIKit

class huddl: NSObject {
    
    var huddlName = ""
    var id = ""
    var group_id = ""
    var recs = recommendationHandler()

    
    
    init(hName: NSString) {
        self.huddlName = hName
    }
    
    //Returns list of huddles for one group from API
    class func getHuddlsByGroupId(id:NSString) -> NSMutableArray {
        var array = NSMutableArray()
        return array
    }
}
