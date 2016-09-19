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
    var color:UIColor = UIColor.blue
    var height:CGFloat = 100
}

var navigationProperties = NavigationProperties()


extension Double {
    var currency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return "Rp. \(formatter.string(for: self)!),-"
    }
}



extension Int {
    var points:String {
        return "\(self) pts"
    }
    
    var timerFormat: String {
        var remain = self
        let h = remain / 3600
        remain %= 3600
        let m = remain / 60
        remain %= 60
        let s = remain
        return "\(h > 9 ? "\(h):" : h > 0 ? "0\(h):" : "")\(m > 9 ? "\(m):" : m > 0 ? "0\(m):" : "00:")\(s > 9 ? "\(s)" : s > 0 ? "0\(s)" : "00")"
    }
}

extension Array {
    mutating func RemoveByCityAlias(_ search:City) {
        var i = 0
        for value in self {
            if let obj = value as? City {
                if obj.isSame(search) {
                    self.remove(at: i)
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

extension Int {
    var passengerFormat:String {
        return "\(self)" + ((self > 1) ? " passengers" : " passenger")
    }
}

extension Date {
    func AddDays(_ days:Double) -> Date {
        return self.addingTimeInterval(3600.0*24.0*days)
    }
    var dateFormat:String {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .none
        return formater.string(from: self)
    }
    var sqlDate:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    var timeOnly:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    var longFormat:String {
        let format = DateFormatter()
        format.dateStyle = .full
        return format.string(from: self)
    }
}

extension UIViewController {
    func Alert(_ message:String) {
        let alertController = UIAlertController(title: message, message:
            "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func ProcessingAlert(_ message:String) -> UIAlertController {
        let processingAlertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        self.present(processingAlertController, animated: true, completion: nil)
        return processingAlertController
    }
    func EndProcessingAlert(_ target:UIAlertController,complete: @escaping () -> Void) {
        DispatchQueue.main.async(execute: {
            target.dismiss(animated: true, completion: complete)
        })
    }
    func AjaxPost(_ link:String,parameter:String,done: @escaping (_ data: Data) -> Void) {
        if let requestURL = URL(string: link) {
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = parameter.data(using: String.Encoding.utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data,response,error ) -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    let statuscode = httpResponse.statusCode
                    print("status code : \(statuscode)")
                    if (statuscode == 200) {
                        if let verified_data = data {
                            done(verified_data)
                        }
                    }
                } else {
                    self.Alert("Please check your internet connection!")
                }
            })
            task.resume()
        }
    }
    
    func AjaxPost(_ link:String,parameter:String,done: @escaping (_ data: Data) -> Void, error: () -> Void) {
        if let requestURL = URL(string: link) {
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = parameter.data(using: String.Encoding.utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data,response,error ) -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    let statuscode = httpResponse.statusCode
                    print("status code : \(statuscode)")
                    if (statuscode == 200) {
                        if let verified_data = data {
                            done(verified_data)
                        }
                    }
                } else {
                    error
                }
            }) 
            task.resume()
        }
    }
    
    func AjaxPost(_ link:String,parameter:String,done: @escaping (_ data: Data) -> Void, error: () -> Void, completion: () -> Void) {
        if let requestURL = URL(string: link) {
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = parameter.data(using: String.Encoding.utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data,response,error ) -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    let statuscode = httpResponse.statusCode
                    print("status code : \(statuscode)")
                    if (statuscode == 200) {
                        if let verified_data = data {
                            done(verified_data)
                        }
                    }
                } else {
                    error
                }
            }) 
            task.resume()
            completion()
        }
    }
    

}

extension UITextField {
    func Required() {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: "this field is required", attributes: [NSForegroundColorAttributeName : UIColor.red])
    }
    func PasswordDoesntMatch() {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: "password doesn't match", attributes: [NSForegroundColorAttributeName : UIColor.red])
    }
    func PasswordInvalid() {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: "password min 8 alphanumeric", attributes: [NSForegroundColorAttributeName : UIColor.red])
    }
    func Invalid(_ message:String) {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSForegroundColorAttributeName : UIColor.red])
    }
    func Success(_ message:String) {
        self.text = ""
        self.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSForegroundColorAttributeName : UIColor.red])
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = characters.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
    
    func IsValidEmail() -> Bool {
        let regexEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regexEmail)
        return emailTest.evaluate(with: self)
    }
    var dateTime : Date
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString : Date = dateFormatter.date(from: self)!
        return dateFromString
    }
    
}


