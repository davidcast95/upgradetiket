//
//  ProfileAccountViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/27/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ProfileAccountViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    var history = Array<Transaction>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GetHistory()
//        historyTableView.delegate = self
//        historyTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DoneButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return history.count
//    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("history-cell", forIndexPath: indexPath) as? HistoryTableViewCell
//        let i = indexPath.row
//        cell?.flightNumber = history[i].flight_number.text
//        
//        return cell
//    }

    
    func GetHistory() {
        if let userId = activeUser.valueForKey("id") {
            let postParameter = "iduser=\(userId)"
            AjaxPost("http://rico.webmurahbagus.com/admin/API/GetTransactionAPI.php", parameter: postParameter, done: { data in
                do {
                    let transactions = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
                    for transaction in transactions! {
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let tempTransaction = Transaction()
                        if let arrival = transaction["arrival"] as? String {
                            tempTransaction.arrival = arrival
                        }
                        if let departure = transaction["departure"] as? String {
                            tempTransaction.departure = departure
                        }
                        if let flight_number = transaction["flight_number"] as? String {
                            tempTransaction.flight_number = flight_number
                        }
                        if let payment_method = transaction["payment_method"] as? String {
                            tempTransaction.payment_method = payment_method
                        }
                        if let card_holder = transaction["card_holder"] as? String {
                            tempTransaction.card_holder = card_holder
                        }
                        if let card_number = transaction["card_number"] as? String {
                            tempTransaction.card_number = card_number
                        }
                        if let total = transaction["total"] as? Double {
                            tempTransaction.total = total
                        }
                        self.history.append(tempTransaction)
                    }
                    self.historyTableView.reloadData()
                    
                } catch {
                    print("error")
                }
            })
        } else {
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
            NSUserDefaults.standardUserDefaults().synchronize()
            let homeVC = storyboard?.instantiateViewControllerWithIdentifier("home")
            presentViewController(homeVC!, animated: true, completion: nil)
        }
    }
}
