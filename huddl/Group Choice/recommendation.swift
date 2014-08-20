//
//  recommendation.swift
//  Group Choice
//
//  Created by Joel Schroeder on 8/20/14.
//  Copyright (c) 2014 BorstelDiz Enterprises. All rights reserved.
//

import UIKit

class recommendation: NSObject {
   
    var label = ""
    var likes = 0
    var dislikes = 0
    var owner = ""
    var location = ""
    var time = NSDate()
    var id = ""
    
    func getVoteTotal() -> Int {
        return self.likes - self.dislikes
    }
    
}
