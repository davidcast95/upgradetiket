//
//  ProceedViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ProceedViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var settingView : UIView!
    var tag = 0
    var textfields = Array<UITextField>()
    var isSettingShow = false
    var mask = Mask()
    var screen = CGRect()
    var isKeyboardShow = false
    @IBOutlet weak var tableView: UITableView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen = view.frame
        CreateMask()
        RespositioningSettingView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CreateMask() {
        mask.FitToScreen(screen)
        let tap = UITapGestureRecognizer(target: self, action: #selector(MaskClicked))
        tap.delegate = self
        mask.addGestureRecognizer(tap)
        view.addSubview(mask)
        self.view.sendSubviewToBack(self.mask)
    }
    
    func RespositioningSettingView() {
        if !isSettingShow {
            var frame = settingView.frame
            frame.origin.y = screen.height
            frame.origin.x = 0
            frame.size = CGSizeMake(screen.width, 100)
            settingView.frame = frame
        }
    }
    
    //Actions
    func MaskClicked(sender: UITapGestureRecognizer) {
        if isSettingShow {
            UIView.animateWithDuration(0.5, animations: {
                self.mask.Hide()
                var frame = self.settingView.frame
                frame.origin.y = self.screen.height
                self.settingView.frame = frame
                }, completion: { finished in
                    self.isSettingShow = false
                    self.view.sendSubviewToBack(self.mask)
            })
        }
    }
    @IBAction func SettingClicked(sender: UIButton) {
        if activeUser.valueForKey("id") != nil {
            if !isSettingShow {
                self.view.bringSubviewToFront(self.mask)
                self.view.bringSubviewToFront(self.settingView)
                UIView.animateWithDuration(0.5, animations: {
                    self.mask.Show()
                    var frame = self.settingView.frame
                    frame.origin.y = self.screen.height - 100
                    self.settingView.frame = frame
                    }, completion: { finished in
                        self.isSettingShow = true
                })
            }
        } else {
            let VC = storyboard?.instantiateViewControllerWithIdentifier("login")
            self.showViewController(VC!, sender: self)
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFlight.passenger + 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < searchFlight.passenger {
            return 256
        } else {
            if searchFlight.isRoundTrip {
                return 500
            } else {
                return 303
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < searchFlight.passenger {
            let cell = tableView.dequeueReusableCellWithIdentifier("person-cell", forIndexPath: indexPath) as! PersonTableViewCell
            cell.personLabel.text = "Passenger \(indexPath.row + 1)"
            cell.selectionStyle = .None
            
            cell.fullNameTextfield.tag = tag
            tag += 1
            cell.fullNameTextfield.delegate = self
            textfields.append(cell.fullNameTextfield)
            cell.IDCardTextField.tag = tag
            tag += 1
            cell.IDCardTextField.delegate = self
            textfields.append(cell.IDCardTextField)
            cell.passportTextfield.tag = tag
            tag += 1
            cell.passportTextfield.delegate = self
            textfields.append(cell.passportTextfield)
            if (indexPath.row + 1 == searchFlight.passenger) {
                cell.passportTextfield.returnKeyType = .Go
            }
            
            return cell
        } else {
            if searchFlight.isRoundTrip {
                let cell = tableView.dequeueReusableCellWithIdentifier("roundtrip-ticket-cell", forIndexPath:  indexPath) as! RoundTripTicketTableViewCell
                
                cell.destinationFlight.text = "\(reservation.flight.from.cityAlias) → \(reservation.flight.to.cityAlias)"
                cell.airlinesDestination.text = ": AirAsia"
                cell.flightNumberDestination.text = ": \(reservation.flight.number)"
                cell.departureDestination.text = ": \(reservation.flight.departure.dateFormat) \(reservation.flight.departure.timeOnly)"
                cell.arrivalDestination.text = ": \(reservation.flight.arrival.dateFormat) \(reservation.flight.departure.timeOnly)"
                cell.passengerDestination.text = ": \(searchFlight.passenger.passengerFormat)"
                cell.priceDestination.text = ": \(reservation.flight.new.currency)"
                
                cell.returningFlight.text = "\(reservation.back.from.cityAlias) → \(reservation.back.to.cityAlias)"
                cell.airlinesReturning.text = ": AirAsia)"
                cell.flightNumberReturning.text = ": \(reservation.back.number)"
                cell.departureReturning.text = ": \(reservation.back.departure.dateFormat) \(reservation.back.departure.timeOnly)"
                cell.arrivalReturning.text = ": \(reservation.back.arrival.dateFormat) \(reservation.back.arrival.timeOnly)"
                cell.passengerReturning.text = ": \(searchFlight.passenger.passengerFormat)"
                cell.priceReturning.text = ": \(reservation.back.new.currency)"
                
                let subtotal = reservation.flight.new * Double(searchFlight.passenger) + (reservation.back.new * Double(searchFlight.passenger))
                cell.subtotal.text = ": \(subtotal.currency)"
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("oneway-ticket-cell", forIndexPath: indexPath) as! OneWayTicketTableViewCell
                
                cell.destinationFlight.text = "\(reservation.flight.from.cityAlias) → \(reservation.flight.to.cityAlias)"
                cell.airlinesLabel.text = ": AirAsia"
                cell.flightNumberLabel.text = ": \(reservation.flight.number)"
                cell.departureLabel.text = ": \(reservation.flight.departure.dateFormat), \(reservation.flight.departure.timeOnly)"
                cell.arrivalLabel.text = ": \(reservation.flight.arrival.dateFormat), \(reservation.flight.arrival.timeOnly)"
                cell.passengerLabel.text = ": \(searchFlight.passenger.passengerFormat)"
                cell.priceLabel.text = ": \(reservation.flight.new.currency)"
                let subtotal = reservation.flight.new * Double(searchFlight.passenger)
                cell.subtotalLabel.text = ": \(subtotal.currency)"
                return cell
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CloseInputView()
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        isKeyboardShow = true
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
        textField.backgroundColor = UIColor.whiteColor()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            CloseInputView()
            Validation(proceedButton)
        }
        return false
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        CloseInputView()
    }
    
    func CloseInputView() {
        isKeyboardShow = false
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    
    @IBAction func Validation(sender: UIButton) {
        reservation.passengers.removeAll()
        var valid = true
        var j = 0
        for _ in 0..<searchFlight.passenger {
            if (textfields[j].text == "") {
                textfields[j].layer.borderColor = UIColor.redColor().CGColor
                textfields[j].layer.borderWidth = 1.0;
                textfields[j].layer.cornerRadius = 5.0;
                valid = false
            }
            j+=1
            if textfields[j].text == "" {
                textfields[j].layer.borderColor = UIColor.redColor().CGColor
                textfields[j].layer.borderWidth = 1.0;
                textfields[j].layer.cornerRadius = 5.0;
                valid = false
            }
            j+=1
            if textfields[j].text == "" {
                textfields[j].layer.borderColor = UIColor.redColor().CGColor
                textfields[j].layer.borderWidth = 1.0;
                textfields[j].layer.cornerRadius = 5.0;
                valid = false
            }
            j+=1
            reservation.passengers.append(Passenger(fullname: textfields[j-3].text!, idcard: textfields[j-2].text!, passport: textfields[j-1].text!))
        }
        if (valid) {
            let paymentVC = storyboard?.instantiateViewControllerWithIdentifier("payment") as! PaymentViewController
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    @IBAction func BackToProceed(segue: UIStoryboardSegue) {
        
    }

}
