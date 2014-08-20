//
//  recommendationHandler.swift
//  Group Choice
//
//  Created by Joel Schroeder on 8/20/14.
//  Copyright (c) 2014 BorstelDiz Enterprises. All rights reserved.
//

import UIKit

class recommendationHandler: NSObject {
    
    var recs = NSMutableArray()
    
    func addRecommendation (tRec: recommendation){
        
        recs.addObject(tRec)
    
    }
    
    func removeRecommendation (tRec: recommendation){
        
        recs.removeObject(tRec)
    
    }
    
}
