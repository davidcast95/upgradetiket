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
        thankyou = false
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
            let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sit amet pharetra eros, eget varius ex. Etiam vestibulum mi ipsum, eget euismod est sollicitudin eu. Quisque vulputate est ut pharetra molestie. In sit amet consequat enim. Praesent dignissim tincidunt congue. Sed ex arcu, interdum pellentesque urna quis, tincidunt tempus lectus. Nullam pulvinar massa quis sodales cursus. Sed in odio varius, iaculis magna vitae, consectetur ligula. Nunc in elit dolor.\nEtiam sit amet nisl vel odio eleifend venenatis. In et nulla non sem molestie luctus. Vestibulum varius, magna vel pellentesque sagittis, dui lacus auctor dolor, quis malesuada diam nibh et enim. In non arcu non massa lobortis porttitor. Curabitur eleifend consectetur nisl quis facilisis. Etiam feugiat rhoncus rutrum. Ut sit amet mi id diam consequat congue eget id dolor. Maecenas pharetra, leo et euismod aliquam, velit augue congue sapien, lacinia venenatis justo elit vitae lorem. Nam accumsan dignissim condimentum.\nSuspendisse augue urna, congue rutrum tortor ac, convallis efficitur felis. Maecenas at nisl eget nunc tristique sagittis. Praesent ultrices turpis eu nulla venenatis luctus. Phasellus semper ullamcorper risus, vehicula imperdiet arcu vestibulum eget. Vivamus placerat quis magna id pulvinar. Curabitur purus ex, pharetra in semper vitae, sollicitudin commodo leo. Sed et iaculis mi. Fusce facilisis, velit quis fermentum mollis, tortor arcu laoreet quam, sit amet iaculis velit turpis quis lorem. Aliquam bibendum magna eu sagittis vehicula. Duis aliquam diam cursus faucibus interdum. Nam a lectus et nisl fringilla lobortis ut vitae ex. Curabitur non iaculis ante. Nullam aliquam ex ac consequat accumsan. Praesent ac quam massa. Maecenas vestibulum, nibh id pellentesque ornare, erat nisi semper justo, sit amet porta magna augue a massa.\nNullam ultricies urna et odio luctus imperdiet. Nunc id lorem a nulla lobortis commodo. Aliquam ultrices gravida elit vitae auctor. Pellentesque vitae iaculis diam. Integer velit diam, feugiat at finibus quis, vulputate sed risus. Duis nec massa id metus volutpat fermentum a ac eros. Suspendisse tristique tortor vel lectus vestibulum volutpat. In semper placerat mollis. Curabitur bibendum dictum tempus. Nullam eu laoreet augue. Nulla justo velit, rutrum convallis fermentum sit amet, egestas vitae sapien. Aenean eget purus varius, sagittis erat at, lobortis risus. Nam diam dolor, lobortis sed molestie a, convallis at quam. Vivamus id ligula eu sapien congue pellentesque sed sed mi. Nulla varius mattis augue.\nNullam pulvinar nunc eu dictum vulputate. Sed lobortis justo dolor, id iaculis orci ullamcorper a. Sed facilisis faucibus massa quis interdum. Maecenas hendrerit rhoncus ligula, vitae posuere purus. Fusce in elementum massa, vitae laoreet nisl. Phasellus feugiat, nunc et tempor mollis, purus urna tempus purus, in ultricies tortor ipsum in enim. Donec id ultricies odio. Ut eu vestibulum tellus. Mauris tincidunt auctor tempor. Nam sit amet porta mauris."
            let agreement = UIAlertController(title: "Agreement Term & Conditions", message: message, preferredStyle: .Alert)
            
            let ok = UIAlertAction(title: "Agree", style: .Default, handler: { (action) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.CreateReservation(reservation.flight)
                    if (reservation.back.id != "0") {
                        self.CreateReservation(reservation.back)
                    }
                })
            })
            let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
            }
            
            agreement.addAction(ok)
            agreement.addAction(cancel)
            
            presentViewController(agreement, animated: true, completion: nil)
            
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
    
    func CreateReservation(flight:Flight) {
        if let id = activeUser.valueForKey("id") as? String {
            print("Creating transasction = \(flight.id)")
            self.indicator.startAnimating()
            let postParameter = "id_jadwal=\(flight.id)&flight_number=\(flight.airlines.airlines) \(flight.number)&id_member=\(id)&person=\(searchFlight.passenger)&total=\(Int(flight.price * Double(reservation.passengers.count)))&payment_method=\(paymentMethodTextField.text!)&card_holder=\(cardHolderTextField.text!)&card_number=\(cardNumberTextField.text!)"
            print(postParameter)
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
        var i = 0
        for passenger in reservation.passengers {
            let postParameter = "id_transaksi=\(id)&fullname=\(passenger.fullname)&no_ktp=\(passenger.idcard)&no_passport=\(passenger.passport)"
            let link = "http://rico.webmurahbagus.com/admin/API/InsertdetailAPI.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: NSUTF8StringEncoding) {
                    if responseData != "1" {
                        success = false
                    }
                    else if (success && i + 1 == reservation.passengers.count) {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.indicator.stopAnimating()
                            self.Thankyou(id)
                        })
                    } else {
                        i += 1
                    }
                }
            })
            
        }
    }
    
    func Thankyou(id:String) {
        let postParameter = "idtransaksi=\(id)"
        var link = "http://rico.webmurahbagus.com/admin/API/MailAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            if let result = String(data: data, encoding: NSUTF8StringEncoding) {
                print("mailapi = \(result)")
            }
        })
        link = "http://rico.webmurahbagus.com/admin/API/NotifMailAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            if let result = String(data: data, encoding: NSUTF8StringEncoding) {
                print("notif api = \(result)")
            }
        })
        if (!thankyou) {
            thankyou = true
            let thanyouVC = self.storyboard?.instantiateViewControllerWithIdentifier("thankyou")
            self.showViewController(thanyouVC!, sender: self)
        }
    }
}
