//
//  SignupViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var fullnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var usernameInvalid = false
    var emailInvalid = false
    var keyboardHeight:CGFloat = 300
    var offsetScrollY:CGFloat = 0
    var isKeyboardShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.delegate = self
        fullnameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        confirmTextfield.delegate = self
        if view.frame.width < 500 {
            scrollView.contentSize = CGSizeMake(contentView.frame.width, 680)
            contentView.frame = CGRectMake(0, 0, contentView.frame.width, 680)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    
    @IBAction func UsernameDidEnd(sender: UITextField) {
        usernameInvalid = false
        if let username = usernameTextfield.text {
            let postParameter = "username=\(username)"
            let link = "http://rico.webmurahbagus.com/admin/API/CekUsername.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                    print(responseData)
                    if responseData == "1" {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.usernameTextfield.Invalid("Username has been used")
                        })
                        
                    }
                }
            })
        }
    }
    @IBAction func EmailDidEnd(sender: AnyObject) {
        if let email = emailTextfield.text {
            if email.IsValidEmail() {
                let postParameter = "email=\(email)"
                let link = "http://rico.webmurahbagus.com/admin/API/CekEmail.php"
                AjaxPost(link, parameter: postParameter, done: { (data) in
                    if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                        print(responseData)
                        if responseData == "1" {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.emailTextfield.Invalid("Email has been registered")
                            })
                            
                        }
                    }
                })
            } else {
                emailTextfield.Invalid("Invalid email")
            }
        }

    }
    @IBAction func SIgnUpTapped(sender: AnyObject) {
        if (Validation()) {
            SignUpAPI()
            
        }
    }
    
    @IBAction func PasswordDidEnd(sender: AnyObject) {
        if passwordTextfield.text?.characters.count < 8 {
            passwordTextfield.PasswordInvalid()
        }
    }

    //MARK: Function

    func Validation() -> Bool {
        var valid = true
        
        if usernameTextfield.text == "" || fullnameTextfield.text == "" || emailTextfield.text == "" || passwordTextfield.text == "" || confirmTextfield.text == "" {
            if (usernameTextfield.text == "") {
                usernameTextfield.Required()
            }
            if (fullnameTextfield.text == "") {
                fullnameTextfield.Required()
            }
            if (emailTextfield.text == "") {
                emailTextfield.Required()
            }
            if (passwordTextfield.text == "") {
                passwordTextfield.Required()
            }
            if (confirmTextfield.text == "") {
                confirmTextfield.Required()
            }
            valid = false
        }

        if passwordTextfield.text?.characters.count < 8 {
            passwordTextfield.PasswordInvalid()
            confirmTextfield.text = ""
            valid = false
        }
        else if passwordTextfield.text != confirmTextfield.text {
            passwordTextfield.PasswordDoesntMatch()
            confirmTextfield.PasswordDoesntMatch()
            valid = false
        }
        
        
        
        return valid
    }
    
    //MARK: API
    func SignUpAPI() {
        self.indicator.startAnimating()
        
        if let username = usernameTextfield.text, let password = passwordTextfield.text, let fullname = fullnameTextfield.text, let email = emailTextfield.text {
            let postParameter = "username=\(username)&fullname=\(fullname)&email=\(email)&password=\(password)"
            let link = "http://rico.webmurahbagus.com/admin/API/InsertmemberAPI.php"
            AjaxPost(link, parameter: postParameter,
                     done: { (data) in
                        if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                            if responseData == "1" {
                                dispatch_async(dispatch_get_main_queue(), {
                                    if let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("confirmationemail") as?ConfirmationEmailViewController {
                                        destinationVC.username = self.usernameTextfield.text!
                                        self.presentViewController(destinationVC, animated: true, completion: nil)
                                    }
                                    
                                    
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.indicator.stopAnimating()
                                    let alertController = UIAlertController(title: "Sorry, our server cannot be reached!", message:
                                        "", preferredStyle: UIAlertControllerStyle.Alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                                    
                                    self.presentViewController(alertController, animated: true, completion: nil)
                                    
                                })
                            }
                        }
                    },
                     error: {
                        self.indicator.stopAnimating()
                        self.Alert("Please check your internet connection!")
                    })        }
    }
    
    @IBAction func Tapped(sender: AnyObject) {
        offsetScrollY = 0
        UIView.animateWithDuration(0.5, animations: {
            self.scrollView.contentOffset = CGPointMake(0, 200)
        })
        isKeyboardShow = false
        view.endEditing(true)
    }
    
    @IBAction func Scroll(sender: UIPanGestureRecognizer) {
        if isKeyboardShow {
            let point = sender.translationInView(self.view)
            offsetScrollY -= point.y / 3
            if (offsetScrollY > 0 && offsetScrollY < 200) {
                scrollView.contentOffset = CGPointMake(0, offsetScrollY)
            }
            if (offsetScrollY < 0) {
                offsetScrollY = 0
            }
            if (offsetScrollY > 400) {
                offsetScrollY = 400
            }
        }
    }
    
    
    //MARK: Text Field
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        isKeyboardShow = true
        let textfieldY = textField.frame.origin.y
        let keyboardY = self.view.frame.height - keyboardHeight
        if keyboardY - textfieldY < 0 {
            let offset = textfieldY - keyboardY
            offsetScrollY = offset
            UIView.animateWithDuration(0.5, animations: {
                self.scrollView.contentOffset = CGPointMake(0, offset)
            })
        }
        return true
    }
    
}
