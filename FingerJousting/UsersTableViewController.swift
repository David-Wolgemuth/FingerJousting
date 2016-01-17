//
//  UsersTableViewController.swift
//  FingerJousting
//
//  Created by David Wolgemuth on 1/16/16.
//  Copyright © 2016 E-D. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController, UsersController
{
    override func viewDidLoad()
    {
        tableView.delegate = self
        tableView.dataSource = self
    }
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
            Connection.sharedInstance.getAllUsers(self)
        }
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        alert.addAction(save)
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem)
    {
        Connection.sharedInstance.getAllUsers(self)
    }
    func usersArrayDidFill()
    {
        tableView.reloadData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Connection.sharedInstance.allUsers.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserNameCell")
        cell?.textLabel?.text = Connection.sharedInstance.allUsers[indexPath.row]
        return cell!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let username = Connection.sharedInstance.allUsers[indexPath.row]
        Connection.sharedInstance.requestGame(withUser: username)
    }
}
