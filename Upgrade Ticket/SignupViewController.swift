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
            contentView.frame = CGRectMake(0, 0, contentView.frame.width, 800)
            print(contentView.frame)
            
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
            let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sit amet pharetra eros, eget varius ex. Etiam vestibulum mi ipsum, eget euismod est sollicitudin eu. Quisque vulputate est ut pharetra molestie. In sit amet consequat enim. Praesent dignissim tincidunt congue. Sed ex arcu, interdum pellentesque urna quis, tincidunt tempus lectus. Nullam pulvinar massa quis sodales cursus. Sed in odio varius, iaculis magna vitae, consectetur ligula. Nunc in elit dolor.\nEtiam sit amet nisl vel odio eleifend venenatis. In et nulla non sem molestie luctus. Vestibulum varius, magna vel pellentesque sagittis, dui lacus auctor dolor, quis malesuada diam nibh et enim. In non arcu non massa lobortis porttitor. Curabitur eleifend consectetur nisl quis facilisis. Etiam feugiat rhoncus rutrum. Ut sit amet mi id diam consequat congue eget id dolor. Maecenas pharetra, leo et euismod aliquam, velit augue congue sapien, lacinia venenatis justo elit vitae lorem. Nam accumsan dignissim condimentum.\nSuspendisse augue urna, congue rutrum tortor ac, convallis efficitur felis. Maecenas at nisl eget nunc tristique sagittis. Praesent ultrices turpis eu nulla venenatis luctus. Phasellus semper ullamcorper risus, vehicula imperdiet arcu vestibulum eget. Vivamus placerat quis magna id pulvinar. Curabitur purus ex, pharetra in semper vitae, sollicitudin commodo leo. Sed et iaculis mi. Fusce facilisis, velit quis fermentum mollis, tortor arcu laoreet quam, sit amet iaculis velit turpis quis lorem. Aliquam bibendum magna eu sagittis vehicula. Duis aliquam diam cursus faucibus interdum. Nam a lectus et nisl fringilla lobortis ut vitae ex. Curabitur non iaculis ante. Nullam aliquam ex ac consequat accumsan. Praesent ac quam massa. Maecenas vestibulum, nibh id pellentesque ornare, erat nisi semper justo, sit amet porta magna augue a massa.\nNullam ultricies urna et odio luctus imperdiet. Nunc id lorem a nulla lobortis commodo. Aliquam ultrices gravida elit vitae auctor. Pellentesque vitae iaculis diam. Integer velit diam, feugiat at finibus quis, vulputate sed risus. Duis nec massa id metus volutpat fermentum a ac eros. Suspendisse tristique tortor vel lectus vestibulum volutpat. In semper placerat mollis. Curabitur bibendum dictum tempus. Nullam eu laoreet augue. Nulla justo velit, rutrum convallis fermentum sit amet, egestas vitae sapien. Aenean eget purus varius, sagittis erat at, lobortis risus. Nam diam dolor, lobortis sed molestie a, convallis at quam. Vivamus id ligula eu sapien congue pellentesque sed sed mi. Nulla varius mattis augue.\nNullam pulvinar nunc eu dictum vulputate. Sed lobortis justo dolor, id iaculis orci ullamcorper a. Sed facilisis faucibus massa quis interdum. Maecenas hendrerit rhoncus ligula, vitae posuere purus. Fusce in elementum massa, vitae laoreet nisl. Phasellus feugiat, nunc et tempor mollis, purus urna tempus purus, in ultricies tortor ipsum in enim. Donec id ultricies odio. Ut eu vestibulum tellus. Mauris tincidunt auctor tempor. Nam sit amet porta mauris."
            let alert = UIAlertController(title: "Agrement Term & Conditions", message: message, preferredStyle: .Alert)
            
            let ok = UIAlertAction(title: "Agree", style: .Default, handler: { (action) -> Void in
                self.SignUpAPI()
            })
            let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
            }
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            presentViewController(alert, animated: true, completion: nil)
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
