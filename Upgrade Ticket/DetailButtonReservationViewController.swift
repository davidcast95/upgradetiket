//
//  DetailButtonReservationViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DetailButtonReservationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmTap(sender: AnyObject) {
        let alert = UIAlertController(title: "Confirm Reservation", message: "You will confirm this reservation", preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.Confirm()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func CancelTap(sender: AnyObject) {
        let alert = UIAlertController(title: "Cancel Reservation", message: "Are you sure to cancel this reservation? This action cannot be undo!", preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            self.Cancel()
        })
        let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func FindTransactionById(id:Int) -> Transaction {
        for hist in history {
            if hist.id == id {
                return hist
            }
        }
        return Transaction()
    }
    
    func Confirm() {
        let processingAlert = self.ProcessingAlert("Processing . . .")
        let postParameter = "idtransaksi=\(viewTransaction.id)"
        print(postParameter)
        let link = "http://rico.webmurahbagus.com/admin/API/ConfirmTransactionAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            self.EndProcessingAlert(processingAlert, complete: {
                if let result = String(data: data,encoding: NSUTF8StringEncoding) {
                    if result == "1" {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.FindTransactionById(viewTransaction.id).status = 4
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                }

            })
        })

    }
    
    func Cancel() {
        let processingAlert = self.ProcessingAlert("Processing . . .")
        let postParameter = "idtransaksi=\(viewTransaction.id)"
        print(postParameter)
        let link = "http://rico.webmurahbagus.com/admin/API/CancelTransactionAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            self.EndProcessingAlert(processingAlert, complete: {
                if let result = String(data: data,encoding: NSUTF8StringEncoding) {
                    if result == "1" {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.FindTransactionById(viewTransaction.id).status = 1
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                }
                
            })
        })

    }
    
}
