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
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var exploreButton: UIButton!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetAdmin()
        
        if let fullname = activeUser.value(forKey: "name") as? String {
            signButton.setTitle("Hi, \(fullname)", for: UIControlState())
            signButton.isEnabled = false
        }
        
        logoImage.alpha = 0
        signButton.alpha = 0
        exploreButton.alpha = 0
        //animations
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions(), animations: {
            self.logoImage.frame.origin.y -= 100
            }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.4, options: UIViewAnimationOptions(), animations: {
            self.signButton.alpha = 1
            }, completion: nil)
        UIView.animate(withDuration: 1.5, delay: 0.5, options: UIViewAnimationOptions(), animations: {
            self.exploreButton.alpha = 1
            }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0.45, options: UIViewAnimationOptions(), animations: {
            self.logoImage.alpha = 1
            }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let fullname = activeUser.value(forKey: "name") as? String {
            signButton.setTitle("Hi, \(fullname)", for: UIControlState())
            signButton.isEnabled = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func GetAdmin() {
        let link = "http://rico.webmurahbagus.com/admin/API/GetAdminAPI.php"
        let postParameter = "e28f6189d541eb618b5fc84c984f12c0=1"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            do {
                let _admin = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : AnyObject]
                if let phone = _admin!["phone"] as? String, let rekening = _admin!["rekening"] as? String, let conversion_points = _admin!["conversion_points"] as? String {
                    admin.phone = phone
                    admin.rekening = rekening
                    admin.conversion_points = conversion_points
                }
            } catch {
                print("error")
            }
        })

    }
    
}
