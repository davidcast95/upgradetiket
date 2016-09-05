//
//  Utility.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/6/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import Foundation
import UIKit

struct NavigationProperties {
    var color:UIColor = UIColor.blueColor()
    var height:CGFloat = 100
}

var navigationProperties = NavigationProperties()


extension Double {
    var currency:String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.groupingSeparator = "."
        return "Rp. \(formatter.stringFromNumber(self)!),-"
    }
}

extension Int {
    var points:String {
        return "\(self) pts"
    }
}

extension Array {
    mutating func RemoveByCityAlias(search:City) {
        var i = 0
        for value in self {
            if let obj = value as? City {
                if obj.isSame(search) {
                    self.removeAtIndex(i)
                }
            }
            i += 1
        }
    }
    
}

extension City {
    var cityAlias:String {
        return "\(self.city) (\(self.alias))"
    }
}

extension NSDate {
    var longFormat:String {
        let format = NSDateFormatter()
        format.dateStyle = .FullStyle
        return format.stringFromDate(self)
    }
}

extension Int {
    var passengerFormat:String {
        return "\(self)" + ((self > 1) ? " passengers" : " passenger")
    }
}

extension NSDate {
    func AddDays(days:Double) -> NSDate {
        return self.dateByAddingTimeInterval(3600.0*24.0*days)
    }
    var dateFormat:String {
        let formater = NSDateFormatter()
        formater.dateStyle = .MediumStyle
        formater.timeStyle = .NoStyle
        return formater.stringFromDate(self)
    }
    var sqlDate:String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(self)
    }
    
    var timeOnly:String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(self)
    }
    
}

extension UIViewController {
    func Alert(message:String) {
        let alertController = UIAlertController(title: message, message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func ProcessingAlert(message:String) -> UIAlertController {
        let processingAlertController = UIAlertController(title: message, message: "", preferredStyle: .Alert)
        self.presentViewController(processingAlertController, animated: true, completion: nil)
        return processingAlertController
    }
    func EndProcessingAlert(target:UIAlertController,complete: () -> Void) {
        target.dismissViewControllerAnimated(true, completion: complete)
    }
    func AjaxPost(link:String,parameter:String,done: (data: NSData) -> Void) {
        if let requestURL = NSURL(string: link) {
            let urlRequest = NSMutableURLRequest(URL: requestURL)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = parameter.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data,response,error ) -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    let statuscode = httpResponse.statusCode
                    if (statuscode == 200) {
                        if let verified_data = data {
                            done(data: verified_data)
                        }
                    }
                } else {
                    self.Alert("Please check your internet connection!")
                }
            }
            task.resume()
        }
    }
    
    func AjaxPost(link:String,parameter:String,done: (data: NSData) -> Void, error: () -> Void) {
        if let requestURL = NSURL(string: link) {
            let urlRequest = NSMutableURLRequest(URL: requestURL)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = parameter.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data,response,error ) -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    let statuscode = httpResponse.statusCode
                    if (statuscode == 200) {
                        if let verified_data = data {
                            done(data: verified_data)
                        }
                    }
                } else {
                    error!
                }
            }
            task.resume()
        }
    }
    
    func AjaxPost(link:String,parameter:String,done: (data: NSData) -> Void, error: () -> Void, completion: () -> Void) {
        if let requestURL = NSURL(string: link) {
            let urlRequest = NSMutableURLRequest(URL: requestURL)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = parameter.dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data,response,error ) -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    let statuscode = httpResponse.statusCode
                    if (statuscode == 200) {
                        if let verified_data = data {
                            done(data: verified_data)
                        }
                    }
                } else {
                    error
                }
            }
            task.resume()
            completion()
        }
    }
    

}

extension UITextField {
    func Required() {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: "this field is required", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
    }
    func PasswordDoesntMatch() {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: "password doesn't match", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
    }
    func PasswordInvalid() {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: "password min 8 alphanumeric", attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
    }
    func Invalid(message:String) {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
    }
    func Success(message:String) {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
    
    func IsValidEmail() -> Bool {
        let regexEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regexEmail)
        return emailTest.evaluateWithObject(self)
    }
    var dateTime : NSDate
    {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        return dateFromString
    }
    
}


