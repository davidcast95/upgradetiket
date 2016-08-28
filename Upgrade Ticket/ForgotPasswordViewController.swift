//
//  ForgotPasswordViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/29/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var email: DefaultUITextField!
    var validEmail = false
    var sessionID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func EmailDidEnd(sender: AnyObject) {
        if let emailval = email.text {
            if emailval.IsValidEmail() {
                let postParameter = "email=\(emailval)"
                let link = "http://rico.webmurahbagus.com/admin/API/CekVerifiedEmail.php"
                AjaxPost(link, parameter: postParameter, done: { (data) in
                    if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                        print(responseData)
                        if responseData == "0" {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.email.Invalid("Email is not registered")
                                self.validEmail = false
                            })
                            
                        } else {
                            self.validEmail = true
                            self.sessionID = responseData
                        }
                    }
                })
            } else {
                self.validEmail = false
                email.Invalid("Invalid email")
            }
        }
    }
    
    @IBAction func ResetPasswordTap(sender: AnyObject) {
        if let emailval = email.text {
            if emailval.IsValidEmail() {
                let postParameter = "email=\(emailval)"
                let link = "http://rico.webmurahbagus.com/admin/API/CekVerifiedEmail.php"
                AjaxPost(link, parameter: postParameter, done: { (data) in
                    if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                        print(responseData)
                        if responseData == "0" {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.email.Invalid("Email is not registered")
                                self.validEmail = false
                            })
                            
                        } else {
                            var sending = UIAlertController()
                            dispatch_async(dispatch_get_main_queue(), {
                                sending = self.ProcessingAlert("Sending request...")
                            })
                            self.validEmail = true
                            self.sessionID = responseData
                            self.AjaxPost("http://rico.webmurahbagus.com/admin/API/ResetPasswordMailAPI.php", parameter: "id=\(self.sessionID)", done: { (data) in
                                if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.EndProcessingAlert(sending, complete: {
                                            if responseData == "1" {
                                                if let successVC = self.storyboard?.instantiateViewControllerWithIdentifier("forgotpasswordsuccess") {
                                                    self.showViewController(successVC, sender: nil)
                                                }
                                            } else {
                                                self.Alert("Error occured!")
                                            }
                                        })
                                        
                                    })
                                }
                                
                            })
                        }
                    }
                })
            } else {
                self.validEmail = false
                email.Invalid("Invalid email")
            }
        }

    }

    @IBAction func CancelTap(sender: AnyObject) {
        if let nav = self.navigationController {
                nav.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

}
