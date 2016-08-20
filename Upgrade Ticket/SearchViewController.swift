//
//  SearchViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/6/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var roundTripImage: UIImageView!
    @IBOutlet weak var originButton:UIButton!
    @IBOutlet weak var destButton:UIButton!
    @IBOutlet weak var dateFlightTextField: UITextField!
    @IBOutlet weak var dateReturnTextField: UITextField!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var switchMode: UISwitch!
    var today = NSDate()
    var datepickerFlight = true
    var datepicker = UIDatePicker()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check cities in core data
        
        
        
        UpdateCity()
        ReadCityData()
        table.reloadData()
        //default date
        today = UIDatePicker().date
        searchFlight.dateFlight = today
        searchFlight.dateReturn = today.AddDays(1)
        dateFlightTextField.text = searchFlight.dateFlight.longFormat
        dateReturnTextField.text = searchFlight.dateReturn.longFormat
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? SearchCityViewController {
            destination.identifier = segue.identifier!
            searchFlight.origin = searchFlight.FindCityByCityAlias((originButton.titleLabel?.text)!)
            searchFlight.dest = searchFlight.FindCityByCityAlias((destButton.titleLabel?.text)!)
        }
        if ((segue.identifier) == "result")  {
            searchFlight.activeResult = .Flight
            if let destination = segue.destinationViewController as? FlightViewController {
                destination.postParameter = "from=\(searchFlight.origin.id)&to=\(searchFlight.dest.id)&date=\(searchFlight.dateFlight.sqlDate)&passenger=\(searchFlight.passenger)"
            }
            
        }
        
        CloseInputView()
    }
    
    //Functions
    func UpdateCity() {
        originButton.titleLabel?.text = searchFlight.origin.cityAlias
        destButton.titleLabel?.text = searchFlight.dest.cityAlias
        
    }
    
    //Action
    @IBAction func SwitchMode(sender: UISwitch) {
        searchFlight.oneWay = !switchMode.on
        if switchMode.on {
            roundTripImage.image = UIImage(named: "arrows")
        } else {
            
            roundTripImage.image = UIImage(named: "one-arrow")
        }
        table.reloadData()
    }
    @IBAction func PersonDidBegin(sender: UITextField) {
        sender.text = ""
    }
    @IBAction func PersonChange(sender:UITextField) {
        if (sender.text == "") {
            searchFlight.passenger = 1
        } else {
            searchFlight.passenger = Int(sender.text!)!
        }
    }
    @IBAction func PersonDidEnd(sender: UITextField) {
        sender.text = searchFlight.passenger.passengerFormat
    }
    @IBAction func DateFlightBegin(sender: UITextField) {
        datepickerFlight = true
        sender.inputView = datepicker
        datepicker.minimumDate = today
        datepicker.datePickerMode = UIDatePickerMode.Date
        datepicker.addTarget(self, action: "DatePickerChange:", forControlEvents: .ValueChanged)
    }
    @IBAction func DateReturnBegin(sender: UITextField) {
        datepickerFlight = false
        sender.inputView = datepicker
        datepicker.minimumDate = searchFlight.dateFlight
        datepicker.datePickerMode = UIDatePickerMode.Date
        datepicker.addTarget(self, action: "DatePickerChange:", forControlEvents: .ValueChanged)
    }
    @IBAction func BackToSearch(segue:UIStoryboardSegue) {
    }
    
    func DatePickerChange(sender: UIDatePicker) {
        if (datepickerFlight) {
            searchFlight.dateFlight = sender.date
            searchFlight.dateReturn = sender.date.AddDays(1)
            dateFlightTextField.text = searchFlight.dateFlight.longFormat
            dateReturnTextField.text = searchFlight.dateReturn.longFormat
        } else {
            searchFlight.dateReturn = sender.date
            dateReturnTextField.text = searchFlight.dateReturn.longFormat
        }
    }
    
    //Table
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        CloseInputView()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 4) {
            if (searchFlight.oneWay) {
                return 0
                
            }
            else {
                return 80
            }
        }
        
        return 80
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func CloseInputView() {
        self.view.endEditing(true)
    }
    
    //Touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        CloseInputView()
    }
    
    func ReadCityData() {
        //check in core data
        let citiesContext = FecthFromCoreData("Cities")
        
        for cityContext in citiesContext {
            let tempCity = City()
            tempCity.id = (cityContext.valueForKey("id") as? Int)!
            tempCity.city = (cityContext.valueForKey("city") as? String)!
            tempCity.alias = (cityContext.valueForKey("alias") as? String)!
            
            searchFlight.cities.append(tempCity)
            print(tempCity.cityAlias)
        }
        
        let link = "http://rico.webmurahbagus.com/admin/API/GetDestinationAPI.php"
        if let requestURL = NSURL(string: link) {
            let urlRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data,response,error ) -> Void in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    let statuscode = httpResponse.statusCode
                    if (statuscode == 200) {
                        do {
                            let cities = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [[String : AnyObject]]
                            print(cities?.count)
                            for city in cities! {
                                let tempCity = City()
                                if let name = city["city"] as? String {
                                    tempCity.city = name
                                }
                                if let alias = city["alias"] as? String {
                                    tempCity.alias = alias
                                }
                                if let id = city["id_destination"] as? String {
                                    tempCity.id = Int(id)!
                                }
                                if !searchFlight.IsCityExist(tempCity) {
                                    searchFlight.cities.append(tempCity)
                                    tempCity.SaveToCoreData()
                                    
                                    dispatch_async(dispatch_get_main_queue(),{
                                        
                                        searchFlight.Default()
                                        self.table.reloadData()
                                        
                                    })
                                }
                            }
                            
                        } catch {
                            print("error")
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Please check your internet connection!", message:
                        "", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
            task.resume()
        }
        
        dispatch_async(dispatch_get_main_queue(),{
            
            searchFlight.Default()
            self.table.reloadData()
            
        })
        
    }
    
    

}
