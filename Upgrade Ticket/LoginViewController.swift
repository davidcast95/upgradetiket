//
//  LoginViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/29/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton:UIButton!
    var lastVC:UIViewController!
    
    var postParameter = ""
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if (activeUser.valueForKey("id") != nil) {
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Textfield
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.whiteColor()
        
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponded = textField.superview?.viewWithTag(nextTag) {
            nextResponded.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
            CloseInputView()
            self.Login(loginButton)
        }
        return true
    }

    //MARK: Action
    @IBAction func Login(sender: UIButton) {
        var flag = true
        if (usernameTextField.text == "") {
            usernameTextField.Required()
            flag = false
        }
        if (passwordTextField.text == "") {
            passwordTextField.Required()
            flag = false
        }
        if (passwordTextField.text?.characters.count < 8) {
            passwordTextField.PasswordInvalid()
            flag = false
        }
        
        if (flag) {
            LoginAPI()
        }
        
    }
    @IBAction func CancelPressed(sender: UIButton) {
        if let navigation = self.navigationController {
            navigation.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func BackToLogin(segue:UIStoryboardSegue) {
    }
    
    //MARK: Input
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        CloseInputView()
    }
    
    func CloseInputView() {
        self.view.endEditing(true)
    }

    
    
    //MARK: Function
    func SetLastVC(vc:UIViewController) {
        lastVC = vc
    }
    func InvalidUser() {
        usernameTextField.text = ""
        usernameTextField.Invalid("Invalid username")
        usernameTextField.layer.borderColor = UIColor.redColor().CGColor
        usernameTextField.layer.borderWidth = 1.0;
        usernameTextField.layer.cornerRadius = 5.0;
        passwordTextField.text = ""
        passwordTextField.Invalid("Invalid password")
        passwordTextField.layer.borderColor = UIColor.redColor().CGColor
        passwordTextField.layer.borderWidth = 1.0;
        passwordTextField.layer.cornerRadius = 5.0;
    }
    func Dismiss() {
        if let navigation = navigationController {
            navigation.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    //MARK: API
    func LoginAPI() {
        
        self.indicator.startAnimating()
        if let username = usernameTextField.text, let password = passwordTextField.text {
            postParameter = "username=\(username)&password=\(password)"
        
            print(postParameter)
            let link = "http://rico.webmurahbagus.com/admin/API/LoginAPI.php"
            AjaxPost(link, parameter: postParameter,
                done: { (data) in
                    do {
                        let user = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
                        if user?.count == 0 {
                            dispatch_async(dispatch_get_main_queue(),{
                                self.indicator.stopAnimating()
                                self.InvalidUser()
                            })
                        } else {
                            if let id = user![0]["id_member"] as? String {
                                activeUser.setValue(id, forKey: "id")
                            }
                            if let fullname = user![0]["fullname"] as? String {
                                activeUser.setValue(fullname, forKey: "name")
                            }
                            if let email = user![0]["email"] as? String {
                                activeUser.setValue(email, forKey: "email")
                            }
                            if let status = user![0]["status"] as? String {
                                activeUser.setValue(status, forKey: "status")
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.indicator.stopAnimating()
                                self.Dismiss()
                            })
                            
                        }
                        
                    } catch {
                        print("error")
                    }

                },
                error: {
                    self.indicator.stopAnimating()
                    self.Alert("Please check your internet connection!")
                })
        }

    }
    

}
