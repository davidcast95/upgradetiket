//
//  SettingViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/13/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Actions
    @IBAction func LogoutTapped(sender: AnyObject) {
        activeUser.removeObjectForKey("id")
        activeUser.removeObjectForKey("name")
        activeUser.removeObjectForKey("email")
        if let homeVC = storyboard?.instantiateViewControllerWithIdentifier("home") as? HomeViewController {
            self.presentViewController(homeVC, animated: true, completion: nil)
        }
    }
    

}
