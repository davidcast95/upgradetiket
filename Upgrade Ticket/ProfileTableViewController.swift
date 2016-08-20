//
//  ProfileTableViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/13/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var fullNameButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    
    var nameTextfield : UITextField!
    var emailTextfield : UITextField!
    var passwordTextfield : UITextField!
    var newPasswordTextfield : UITextField!
    var confirmPasswordTextfield : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetMember()
        UpdateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ChangeNameClick(sender: UIButton) {
        let alert = UIAlertController(title: "You will change your name", message: "Please input your name and your password!", preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.ChangeName()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
    
        alert.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.nameTextfield = textField
            self.nameTextfield?.placeholder = "Your new name"
        }
        
        alert.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.passwordTextfield = textField
            self.passwordTextfield.secureTextEntry = true
            self.passwordTextfield?.placeholder = "Your password"
        }
        
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func EmailClick(sender: UIButton) {
        let alert = UIAlertController(title: "You will change your email", message: "Please input your email and password!", preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.ChangeEmail()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.emailTextfield = textField
            self.emailTextfield?.placeholder = "Your new email"
        }
        
        alert.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.passwordTextfield = textField
            self.passwordTextfield.secureTextEntry = true
            self.passwordTextfield?.placeholder = "Your password"
        }
        
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func PasswordClick(sender: UIButton) {
        let alert = UIAlertController(title: "You will change your password", message: "Please input your old password and new password!", preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.ChangePassword()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.passwordTextfield = textField
            self.passwordTextfield.secureTextEntry = true
            self.passwordTextfield?.placeholder = "Your old password"
        }
        
        alert.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.newPasswordTextfield = textField
            self.newPasswordTextfield.secureTextEntry = true
            self.newPasswordTextfield?.placeholder = "Your new password"
        }
        
        alert.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.confirmPasswordTextfield = textField
            self.confirmPasswordTextfield.secureTextEntry = true
            self.confirmPasswordTextfield?.placeholder = "Your confirm password"
        }
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func ChangeName() {
        if nameTextfield.text == "" || passwordTextfield.text == "" {
            Alert("Invalid input!")
        } else {
            ChangeNameAPI()
        }
    }
    
    func ChangeEmail() {
        if emailTextfield.text == "" || passwordTextfield.text == "" {
            Alert("Invalid input!")
        } else {
            ChangeEmailAPI()
        }
    }
    
    func ChangePassword() {
        if passwordTextfield.text == "" || newPasswordTextfield.text == "" || confirmPasswordTextfield.text == "" {
            Alert("Invalid input!")
        } else if (newPasswordTextfield.text?.characters.count < 8) {
            Alert("Password must be min 8 alphanumeric")
        } else if (newPasswordTextfield.text != confirmPasswordTextfield.text) {
            Alert("New Password doesn't match")
        } else {
            ChangePasswordAPI()
        }
    }
    
    //MARK: - API
    func GetMember() {
        if let id = activeUser.valueForKey("id") {
            let postParameter = "id=\(id)"
            let link = "http://rico.webmurahbagus.com/admin/API/GetMemberAPI.php"
            AjaxPost(link, parameter: postParameter, done: { data in
                do {
                    let user = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
                    if let fullname = user![0]["fullname"] as? String {
                        activeUser.setValue(fullname, forKey: "name")
                    }
                    if let email = user![0]["email"] as? String {
                        activeUser.setValue(email, forKey: "email")
                    }
                    if let status = user![0]["status"] as? String {
                        activeUser.setValue(status, forKey: "status")
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        self.UpdateData()
                    })
                } catch {
                    print("error")
                }
            })
        }
        
    }
    
    func ChangePasswordAPI() {
        if let id = activeUser.valueForKey("id") {
            let processingAlert = self.ProcessingAlert("Processing . . .")
            let postParameter = "id=\(id)&old=\(passwordTextfield.text!)&new=\(newPasswordTextfield.text!)&confirm=\(confirmPasswordTextfield.text!)"
            print(postParameter)
            let link = "http://rico.webmurahbagus.com/admin/API/ChangePasswordAPI.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                self.EndProcessingAlert(processingAlert, complete: {
                    if let result = String(data: data,encoding: NSUTF8StringEncoding) {
                        print(result)
                        if result == "1" {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.Alert("Your new password has been saved!")
                                self.GetMember()
                                self.UpdateData()
                            })
                            
                        } else if result == "-1" {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.Alert("Authorization Error")
                            })
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.Alert("Server is not responding, please try again later!")
                            })
                            
                        }
                    }
                })
            })
        }
    }

    
    func ChangeNameAPI() {
        if let id = activeUser.valueForKey("id") {
            let processingAlert = self.ProcessingAlert("Processing . . .")
            let postParameter = "id=\(id)&confirm=\(passwordTextfield.text!)&fullname=\(nameTextfield.text!)"
            let link = "http://rico.webmurahbagus.com/admin/API/ChangeFullnameAPI.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                self.EndProcessingAlert(processingAlert, complete: {
                    if let result = String(data: data,encoding: NSUTF8StringEncoding) {
                        print(result)
                        if result == "1" {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.Alert("Your new fullname has been saved!")
                                self.GetMember()
                                self.UpdateData()
                            })
                            
                        } else if result == "-1" {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.Alert("Authorization Error")
                            })
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.Alert("Server is not responding, please try again later!")
                            })
                            
                        }
                    }

                })
            })
        }
    }
    
    func ChangeEmailAPI() {
        if let email = emailTextfield.text {
            let postParameter = "email=\(email)"
            let link = "http://rico.webmurahbagus.com/admin/API/CekEmail.php"
            let processingAlert = self.ProcessingAlert("Processing . . .")
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                    print(responseData)
                    if responseData == "1" {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.Alert("Sorry, your email is not available!")
                        })
                    } else {
                        if let id = activeUser.valueForKey("id") {
                            let postParameter = "id=\(id)&confirm=\(self.passwordTextfield.text!)&email=\(email)"
                            let link = "http://rico.webmurahbagus.com/admin/API/ChangeEmailAPI.php"
                            self.AjaxPost(link, parameter: postParameter, done: { (data) in
                                self.EndProcessingAlert(processingAlert, complete: {
                                    if let result = String(data: data,encoding: NSUTF8StringEncoding) {
                                    print(result)
                                    if result == "1" {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.Alert("Your new email has been saved! Please check your inbox / spam for verification!")
                                            self.GetMember()
                                            self.UpdateData()
                                        })
                                    } else if result == "-1" {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.Alert("Authorization Error")
                                        })
                                        
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.Alert("Server is not responding, please try again later!")
                                        })
                                        
                                    }
                                }
                                })
                                
                            })
                        }
                    }
                }
            })
        }
    }
    
    func UpdateData() {
        if let name = activeUser.valueForKey("name") as? String {
            fullNameButton.setTitle(name, forState: .Normal)
        }
        if let status = activeUser.valueForKey("status") as? String {
            var emailText = ""
            if let email = activeUser.valueForKey("email") as? String {
                emailText += email
                
                if status == "-1" {
                    emailText += "(Not Verified)"
                }
            }
            emailButton.setTitle(emailText, forState: .Normal)
        }
    }
    
}
