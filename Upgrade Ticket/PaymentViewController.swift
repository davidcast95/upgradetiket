//
//  PaymentViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/29/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UIPickerViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var cardHolderTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    var paymentMethodPicker = UIPickerView()
    var paymentMethod = ["Transfer Bank"]
    
    //MARK: Setting Properties
    
    @IBOutlet weak var settingView: UIView!
    var isSettingShow = false
    var mask = Mask()
    var screen = CGRect()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen = view.frame
        CreateMask()
        RespositioningSettingView()
        for i in 0..<reservation.passengers.count {
            print(reservation.passengers[i].fullname)
        }
        paymentMethodPicker.delegate = self
        paymentMethodTextField.text = paymentMethod[0]
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setting Extension
    
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
    @IBAction func SettingClicked(sender: AnyObject) {
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
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paymentMethod.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentMethod[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paymentMethodTextField.text = paymentMethod[row]
    }

    @IBAction func paymentMethodBeginEditing(sender: UITextField) {
        sender.inputView = paymentMethodPicker
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        CloseInputView()
    }
    
    func CloseInputView() {
        view.endEditing(true)
    }
    
    @IBAction func ConfirmPressed(sender: UIButton) {
        if (paymentMethodTextField.text != "" && cardHolderTextField.text != "" && cardNumberTextField.text != "") {
            CreateReservation()
        } else {
            if (paymentMethodTextField.text == "") {
                paymentMethodTextField.layer.borderColor = UIColor.redColor().CGColor
                paymentMethodTextField.layer.borderWidth = 1.0;
                paymentMethodTextField.layer.cornerRadius = 5.0;
            }
            
            if (cardHolderTextField.text == "") {
                cardHolderTextField.layer.borderColor = UIColor.redColor().CGColor
                cardHolderTextField.layer.borderWidth = 1.0;
                cardHolderTextField.layer.cornerRadius = 5.0;
            }
            
            if (cardNumberTextField.text == "") {
                cardNumberTextField.layer.borderColor = UIColor.redColor().CGColor
                cardNumberTextField.layer.borderWidth = 1.0;
                cardNumberTextField.layer.cornerRadius = 5.0;
            }
        }
    }
    
    func CreateReservation() {
        if let id = activeUser.valueForKey("id") as? String {
            self.indicator.startAnimating()
            let flight = reservation.flight
            let postParameter = "id_jadwal=\(flight.id)&flight_number=\(flight.number)&id_member=\(id)&person=\(searchFlight.passenger)&date=\(searchFlight.dateFlight.sqlDate)&total=\(flight.price * Double(reservation.passengers.count))&payment_method=\(paymentMethodTextField.text!)&card_holder=\(cardHolderTextField.text!)&card_number=\(cardNumberTextField.text!)"
            
            let link = "http://rico.webmurahbagus.com/admin/API/InserttransactionAPI.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                dispatch_async(dispatch_get_main_queue(),{
                    if let result = String(data: data,encoding: NSUTF8StringEncoding) {
                        self.CreateDetailReservation(result)
                    }
                })
            })
        }
    }
    
    func CreateDetailReservation(id:String) {
        var success = true
        for passenger in reservation.passengers {
            print(passenger.fullname)
            let postParameter = "id_transaksi=\(id)&fullname=\(passenger.fullname)&no_ktp=\(passenger.idcard)&no_passport=\(passenger.passport)"
            let link = "http://rico.webmurahbagus.com/admin/API/InsertdetailAPI.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                    if responseData != "1" {
                        print(responseData)
                        success = false
                    }
                }
            })
        }
        if (success) {
            self.indicator.stopAnimating()
            self.Thankyou(id)
        }
    }
    
    func Thankyou(id:String) {
        let postParameter = "idtransaksi=\(id)"
        var link = "http://rico.webmurahbagus.com/admin/API/MailAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            if let result = String(data: data, encoding: NSUTF8StringEncoding) {
                print(result)
            }
        })
        link = "http://rico.webmurahbagus.com/admin/API/NotifMailAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            if let result = String(data: data, encoding: NSUTF8StringEncoding) {
                print(result)
            }
        })
        let thanyouVC = self.storyboard?.instantiateViewControllerWithIdentifier("thankyou")
        self.showViewController(thanyouVC!, sender: self)
    }
}
