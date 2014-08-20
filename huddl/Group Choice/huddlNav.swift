//
//  huddlNav.swift
//  Group Choice
//
//  Created by Daniel Borstelmann on 7/28/14.
//  Copyright (c) 2014 BorstelDiz Enterprises. All rights reserved.
//

import UIKit

class huddlNav: UINavigationController {

    func viewDidAppear(animated: Bool) () {
        println("hi")
        
        if FBSession.activeSession().isOpen {
            println("LOGGED IN")
            self.performSegueWithIdentifier("loggedIn", sender: self)
        }
        else {
            println("NEED TO SIGN IN")
            self.performSegueWithIdentifier("sign", sender: self)
        }

    }
    
}
