//
//  GroupsandEventsTableViewController.swift
//  Group Choice
//
//  Created by Daniel Borstelmann on 7/27/14.
//  Copyright (c) 2014 BorstelDiz Enterprises. All rights reserved.
//

import UIKit


let darkGrayColor:UInt = 0x757575
let darkBlueColor:UInt = 0x053162
let lightBlueColor:UInt = 0x0577FE
let mediumBlueColor:UInt = 0x084387
let orangeColor:UInt = 0xFFB700
let redColor:UInt = 0xFF4B66
let lightGrayColor:UInt = 0xE3E3E3
let white:UInt = 0xffffff
let black:UInt = 0x000000
let facebookBlue:UInt = 0x3B5998

let huddlURL = "https://176ff332.ngrok.com/"

var addName: UITextField = UITextField()
var addGroupView: UIView = UIView()
var addGroupPop: UIView = UIView()

var basicInfo = NSDictionary()
var friends = NSDictionary()
var sendToApi = NSMutableDictionary()
var groupList:Array = []

class GroupsandEventsTableViewController: UITableViewController, FBFriendPickerDelegate, UITextFieldDelegate {
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tabBarController.tabBar.selectedImageTintColor = UIColorFromRGB(orangeColor)
        
        var b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "logOut")
        b.tintColor = UIColorFromRGB(white)
        self.navigationItem.leftBarButtonItem = b

        tableView.backgroundColor = UIColorFromRGB(mediumBlueColor)
        
        var a = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addHit")
        a.tintColor = UIColorFromRGB(white)
        
        self.navigationItem.rightBarButtonItem = a
        
        self.basicData()
        
    }
    
    func basicData() {
        FBRequestConnection.startForMeWithCompletionHandler({(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            basicInfo = result as NSDictionary
            sendToApi["access_token"] = FBSession.activeSession().accessTokenData
            sendToApi["name"] = basicInfo["name"]
            sendToApi["id"] = basicInfo["id"]
            
            FBRequestConnection.startWithGraphPath("me/friends", completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                friends = result as NSDictionary
                sendToApi["friends"] = friends["data"]
                //self.sendBasic()
            })
        })
        
    }
    
    func sendBasic() {
        let manager = AFHTTPRequestOperationManager()
        
        var parameters  = ["name":sendToApi["name"], "fb_id":sendToApi["id"], "fb_access_token":sendToApi["access_token"]]
        
        manager.POST("\(huddlURL)login/", parameters: parameters,
        success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
            println(responseObject)
            manager.GET("\(huddlURL)whoami/", parameters: nil,
                success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                    println(responseObject)
                },
                failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                    println("Error: " + error.localizedDescription)
                })
        },
        failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
            println("Error: " + error.localizedDescription)
            println(operation.responseObject)
            var dict : Dictionary <String,String> = operation.responseObject as Dictionary
            if dict["message"] == "could not find user with that fb_id" {
                manager.POST("\(huddlURL)register/", parameters: parameters,
                    success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                        println(responseObject)
                        manager.GET("\(huddlURL)whoami/", parameters: nil,
                            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                                println(responseObject)
                            },
                            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                                println("Error: " + error.localizedDescription)
                            })
                    },
                    failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                        println("Error: " + error.localizedDescription)
                    })
            }
        })
        
    }
    
    func addHit() {
        
        addGroupView = UIView(frame: CGRectMake(0, 0, self.view.window.frame.size.width, self.view.window.frame.size.height))
        addGroupView.backgroundColor = UIColorFromRGB(darkGrayColor)
        addGroupView.alpha = 0.5;
        
        self.view.window.addSubview(addGroupView)
        
        UIView.animateWithDuration(0.5, animations: ({addGroupView.alpha = 0.5}))
        
        addGroupPop = UIView(frame: CGRectMake(40, 40, self.view.frame.size.width - 80, self.view.frame.size.height - 80))
        addGroupPop.backgroundColor = UIColorFromRGB(lightGrayColor)
        addGroupPop.layer.cornerRadius = 5
        addGroupPop.alpha = 1;
        
        addName.frame = CGRectMake(20, 20, 200, 20)
        addName.borderStyle = UITextBorderStyle.RoundedRect
        addName.backgroundColor = UIColorFromRGB(white)
        addGroupPop.addSubview(addName)
        
        var button: UIButton = UIButton(frame: CGRectMake(20, 60, 100, 100))
        button.addTarget(self, action: "addGroup", forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = UIColorFromRGB(darkBlueColor)
        button.setTitle("Add Group", forState: UIControlState.Normal)
        button.setTitleColor(UIColorFromRGB(white), forState: UIControlState.Normal)
        button.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        addGroupPop.addSubview(button)
        
        self.view.window.addSubview(addGroupPop)

        UIView.animateWithDuration(0.5, animations: ({addGroupPop.alpha = 1}))
        
    }
    
    func addGroup() {
        var firstString = addName.text
        
        var newGroup: group = group(gName: "\(firstString)")
        groupList.append(newGroup)
        
        self.tableView.reloadData()
        
        addGroupView.removeFromSuperview()
        addGroupPop.removeFromSuperview()
    }
    
    func logOut() {
        println("hello")
        FBSession.activeSession().closeAndClearTokenInformation()
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.POST("\(huddlURL)logout/", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println(responseObject)
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
            })
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return groupList.count
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 90;
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "\(indexPath.row)")
        
        var g: group = groupList[indexPath.row] as group
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColorFromRGB(lightBlueColor)
        }
        else {
            cell.backgroundColor = UIColorFromRGB(darkBlueColor)
        }
        
        
        //GROUP NAME
        var title: UILabel = UILabel(frame: CGRectMake(10, 10, 180, 36))
        title.textAlignment = NSTextAlignment.Left
        title.text = g.groupName
        title.textColor = UIColorFromRGB(white)
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        cell.addSubview(title)
        
        //NEXT EVENT ICON
        var nextImage: UIImageView = UIImageView(image: UIImage(named: "nextEvent"))
        nextImage.frame = CGRectMake(10, 55, 20, 20)
        nextImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.addSubview(nextImage)
        
        //NEXT EVENT DATE
        var nextStep: UILabel = UILabel(frame: CGRectMake(36, 65, 150, 15))
        nextStep.textAlignment = NSTextAlignment.Left
        //nextStep.text = "\(g.events[0].dateTime)"
        if indexPath.row % 2 == 0 {
            nextStep.textColor = UIColorFromRGB(darkBlueColor)
        }
        else {
            nextStep.textColor = UIColorFromRGB(lightBlueColor)
        }
        nextStep.font = UIFont(name: "HelveticaNeue", size: 11)
        cell.addSubview(nextStep)
        
        //NEXT EVENT DESCRIPTION
        var desc: UILabel = UILabel(frame: CGRectMake(36, 50, 150, 15))
        desc.textAlignment = NSTextAlignment.Left
        //desc.text = "\(g.events[0].description)"
        desc.textColor = UIColorFromRGB(orangeColor)
        desc.font = UIFont(name: "HelveticaNeue", size: 12)
        cell.addSubview(desc)
        
        //CHAT ICON
        if g.hasChat == true {
            var chatImage: UIImageView = UIImageView(image: UIImage(named: "Chat"))
            chatImage.frame = CGRectMake(275, 10, 20, 20)
            chatImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.addSubview(chatImage)
        }
        
        //VOTE ICON
        if g.needsVote == true {
            var voteImage: UIImageView = UIImageView(image: UIImage(named: "Vote"))
            voteImage.frame = CGRectMake(215, 10, 20, 20)
            voteImage.contentMode = UIViewContentMode.ScaleAspectFit
            cell.addSubview(voteImage)
        }

        
        //FRIENDS ICON
        var peepsImage: UIImageView = UIImageView(image: UIImage(named: "Friends"))
        peepsImage.frame = CGRectMake(270, 40, 30, 30)
        peepsImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.addSubview(peepsImage)
        
        //NUM FRIENDS
        var peeps: UILabel = UILabel(frame: CGRectMake(260, 70, 50, 20))
        peeps.textAlignment = NSTextAlignment.Center
        //peeps.text = "\(g.names.count) Friends"
        //if g.names.count == 1 {
        //    peeps.text = "\(g.names.count) Friend"
        //}
        //else {
        //    peeps.text = "\(g.names.count) Friends"
        //}
        peeps.textColor = UIColorFromRGB(white)
        peeps.font = UIFont(name: "HelveticaNeue", size: 11)
        cell.addSubview(peeps)
        
        //EVENTS ICON
        var evsImage: UIImageView = UIImageView(image: UIImage(named: "Events"))
        evsImage.frame = CGRectMake(210, 40, 30, 30)
        evsImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.addSubview(evsImage)
        
        //NUM EVENTS
        var evs: UILabel = UILabel(frame: CGRectMake(200, 70, 50, 20))
        evs.textAlignment = NSTextAlignment.Center
        //if g.events.count == 1 {
        //    evs.text = "\(g.events.count) Event"
        //}
        //else {
        //    evs.text = "\(g.events.count) Events"
        //}
        evs.textColor = UIColorFromRGB(white)
        evs.font = UIFont(name: "HelveticaNeue", size: 11)
        cell.addSubview(evs)
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var newView:FBFriendPickerViewController = FBFriendPickerViewController()
        newView.delegate = self
        newView.loadData()
        
        self.navigationController.pushViewController(newView, animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
