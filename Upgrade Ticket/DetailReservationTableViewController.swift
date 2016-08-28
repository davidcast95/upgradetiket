//
//  DetailReservationTableViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/25/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DetailReservationTableViewController: UITableViewController {

    let sectionsString = ["Tiket Information", "Payment Information","Passenger Information"]
    var numOfRowsInSection = [1,3,4 + 1]
    var loading = true
    @IBOutlet weak var buttonContainer: UIView!
    
    var paymentInformation = Array<String>()
    var passengersInformation = Array<String>()
    let paymentField = ["Card Holder","Payment Method","Rekening"]
    let passengerField = ["Fullname","ID Card","Passport"]
    var indexField = 0
    
    @IBOutlet var detailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        GenerateDetail()
        GetDetail()
        if viewTransaction.status != 2 {
            print("asd")
            buttonContainer.hidden = true
            buttonContainer.frame = CGRectMake(0, 0, 0, 0)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionsString.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numOfRowsInSection[section]
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsString[section]
    }
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 118
        } else {
            if loading {
                return tableView.frame.height - 118
            }
            return 44
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCellWithIdentifier("ticket-information",forIndexPath: indexPath) as? HistoryTableViewCell {
                let depart = "Depart at \(viewTransaction.departure.dateFormat) \(viewTransaction.departure.timeOnly)"
                var mutableAttrString = NSMutableAttributedString(string: depart)
                
                mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:0,length:10))
                mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSRange(location:10,length:depart.characters.count - 10))
                mutableAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(12), range: NSRange(location:10,length:depart.characters.count - 10))
                
                cell.depart.attributedText = mutableAttrString
                let arrive = "Arrive at \(viewTransaction.arrival.dateFormat) \(viewTransaction.arrival.timeOnly)"
                mutableAttrString = NSMutableAttributedString(string: arrive)
                
                mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location:0,length:10))
                mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSRange(location:10,length:arrive.characters.count - 10))
                mutableAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(12), range: NSRange(location:10,length:arrive.characters.count - 10))
                cell.arrive.attributedText = mutableAttrString
                cell.destinationFlight.text = "\(viewTransaction.from) → \(viewTransaction.to)"
                cell.flightDetail.text = viewTransaction.flight_number
                cell.passenger.text = viewTransaction.passenger.passengerFormat
                cell.subtotal.text = viewTransaction.total.currency
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("error-detail", forIndexPath: indexPath)
                return cell
            }
        } else {
            if loading {
                let cell = tableView.dequeueReusableCellWithIdentifier("loading-detail",forIndexPath: indexPath)
                return cell
            }
            if let cell = tableView.dequeueReusableCellWithIdentifier("cell-detail", forIndexPath: indexPath) as? DetailTransactionTableViewCell {
                if indexPath.section == 1 {
                    let index = indexPath.row
                    cell.field.text = paymentField[index]
                    cell.value.text = paymentInformation[index]
                }
                else {
                    let index = indexPath.row
                    if (index < passengersInformation.count) {
                        if (index % 4 == 0) {
                            cell.field.text = passengersInformation[index]
                            cell.value.text = ""
                            
                        } else {
                            cell.field.text = passengerField[indexField % passengerField.count]
                            indexField+=1
                            cell.value.text = passengersInformation[index]
                        }
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("error-detail", forIndexPath: indexPath)
                return cell
            }
        }
    }
    
    //MARK: Functions
    func GenerateDetail() {
        paymentInformation.append(viewTransaction.card_holder)
        paymentInformation.append(viewTransaction.payment_method)
        paymentInformation.append(viewTransaction.card_number)
    }

    //MARK: Connectivity
    func GetDetail() {
        if let userId = activeUser.valueForKey("id") {
            let postParameter = "iduser=\(userId)&idtransaksi=\(viewTransaction.id)"
            print(postParameter)
            AjaxPost("http://rico.webmurahbagus.com/admin/API/GetDetailAPI.php", parameter: postParameter, done: { data in
                do {
                    let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print(string)
                    let details = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
                    var i = 1
                    for detail in details! {
                        if let fullname = detail["fullname"] as? String, ktp = detail["no_ktp"] as? String, passport = detail["no_passport"] as? String {
                            self.passengersInformation.append("Person \(i)")
                            self.passengersInformation.append(fullname)
                            self.passengersInformation.append(ktp)
                            self.passengersInformation.append(passport)
                            i+=1
                        }
                    }
                    self.loading = false
                    self.numOfRowsInSection[2] = (self.passengersInformation.count)
                    self.indexField = 0
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                        
                    })
                    
                } catch {
                    let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print(string)
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
