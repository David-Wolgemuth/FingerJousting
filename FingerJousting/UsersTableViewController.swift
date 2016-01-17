//
//  UsersTableViewController.swift
//  FingerJousting
//
//  Created by David Wolgemuth on 1/16/16.
//  Copyright © 2016 E-D. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController
{
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        askForUsernameAlert()
    }
    func askForUsernameAlert()
    {
        Connection.sharedInstance
        let alert = UIAlertController(title: "UserName", message: "Please Enter a UserName", preferredStyle: .Alert)
        let save = UIAlertAction(title: "Save", style: .Default) {
            (action: UIAlertAction!) -> Void in
            let userName = alert.textFields![0].text!
            Connection.sharedInstance.sendToServer(userName: userName)
        }
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        alert.addAction(save)
        presentViewController(alert, animated: true, completion: nil)
    }
}
