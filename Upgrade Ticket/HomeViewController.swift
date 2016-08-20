//
//  HomeViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 7/2/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var exploreButton: UIButton!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fullname = activeUser.valueForKey("name") as? String {
            signButton.setTitle("Hi, \(fullname)", forState: .Normal)
            signButton.enabled = false
        }
        
        logoImage.alpha = 0
        companyLabel.alpha = 0
        signButton.alpha = 0
        exploreButton.alpha = 0
        //animations
        UIView.animateWithDuration(2, delay: 0.2, options: .CurveEaseInOut, animations: {
            self.logoImage.frame.origin.y -= 100
            }, completion: nil)
        UIView.animateWithDuration(2, delay: 0.55, options: .CurveEaseInOut, animations: {
            self.companyLabel.alpha = 1
            }, completion: nil)
        UIView.animateWithDuration(3, delay: 0.4, options: .CurveEaseInOut, animations: {
            self.signButton.alpha = 0.6
            }, completion: nil)
        UIView.animateWithDuration(3, delay: 0.5, options: .CurveEaseInOut, animations: {
            self.exploreButton.alpha = 0.6
            }, completion: nil)
        UIView.animateWithDuration(2, delay: 0.45, options: .CurveEaseInOut, animations: {
            self.logoImage.alpha = 1
            }, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let fullname = activeUser.valueForKey("name") as? String {
            signButton.setTitle("Hi, \(fullname)", forState: .Normal)
            signButton.enabled = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    
}
