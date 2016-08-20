//
//  FlightViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/16/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
import CoreData

class FlightViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate {
    
    //MARK : General Property
    var screen:CGRect!
    var isSearching = true
    var isDisconnected = false
    @IBOutlet var tapListener: UITapGestureRecognizer!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Slider Property
    @IBOutlet weak var sliderView: UIView!
    var buttonWidth = CGFloat()
    var selectView = UIView()
    var menus = ["Bizniz","First"]
    var idMenus = ["b","f"]
    var buttons = Array<UIButton>()
    var indexMenu = 0
    
    // MARK: - Settings Property
    var isSettingShow = false
    var mask = Mask()
    var emptyResult = false
    @IBOutlet weak var settingView: UIView!
    
    // MARK: - Input Form Property
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var dateFlightInput: UITextField!
    @IBOutlet weak var passengerInput: UITextField!
    var datePicker = UIDatePicker()
    var today = NSDate()
    
    // MARK: - Table Property
    @IBOutlet var flightTableView: UITableView!
    var postParameter = ""
    var flightResults = Array<Flight>()
    var flightDisplay = Array<Flight>()
    var displayCell = Array<Bool>()
    
    
    // MARK: - Core
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(Refresh), forControlEvents: .ValueChanged)
        flightTableView.addSubview(refreshControl)
        tapListener.cancelsTouchesInView = false
        
        screen = self.view.frame
        ReadCityData()
        ReadAirlinesData()
        self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", forState: .Normal)
        dateFlightInput.text = today.dateFormat
        CreateMask()
        RespositioningSettingView()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        if searchFlight.isRoundTrip {
            backButton.hidden = false
        } else {
            backButton.hidden = true
        }
        searchFlight.Print()
        self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", forState: .Normal)
        GetResult()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        layoutSlider()
    }
    
    //MARK: Function
    func layoutSlider() {
        let frame = sliderView.frame
        buttonWidth = frame.width / CGFloat(menus.count)
        var i:CGFloat = 0
        let buttonHeight:CGFloat = frame.height
        for button in buttons {
            button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight)
            i+=1
        }
        let offset:CGFloat = buttonWidth * 0.1
        selectView.frame = CGRectMake((CGFloat(indexMenu) * buttonWidth) + offset/2, buttonHeight - CGFloat(5), buttonWidth - offset, 5)
    }
    
    
    func setupSlider() {
        selectView.backgroundColor = UIColor.init(red: 21/255, green: 170/255, blue: 244/255, alpha: 1)
        sliderView.addSubview(selectView)
        for menu in menus {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: menu, attributes: [NSForegroundColorAttributeName : UIColor.grayColor()]), forState: .Normal)
            button.setAttributedTitle(NSAttributedString(string: menu, attributes: [NSForegroundColorAttributeName : UIColor.blackColor()]), forState: .Highlighted)
            button.setAttributedTitle(NSAttributedString(string: menu, attributes: [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont.boldSystemFontOfSize(18)]), forState: .Selected)
            button.addTarget(self, action: #selector(sliderChange), forControlEvents: .TouchUpInside)
            sliderView.addSubview(button)
            buttons.append(button)
        }
        for button in buttons {
            button.selected = false
        }
        buttons[indexMenu].selected = true
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LeftSlideOver))
        leftSwipe.direction = .Left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RightSlideOver))
        rightSwipe.direction = .Right
        leftSwipe.delegate = self
        rightSwipe.delegate = self
        flightTableView.addGestureRecognizer(leftSwipe)
        flightTableView.addGestureRecognizer(rightSwipe)
    }
    
    func LeftSlideOver(sender: UISwipeGestureRecognizer) {
        if indexMenu + 1 < menus.count {
            indexMenu+=1
            UpdateSlider()
        }
    }
    func RightSlideOver(sender: UISwipeGestureRecognizer) {
        if indexMenu - 1 >= 0 {
            indexMenu-=1
            UpdateSlider()
        }
    }
    func sliderChange(sender: UIButton) {
        let index = Int(sender.frame.origin.x / sender.frame.width)
        if indexMenu != index {
            indexMenu = index
            
            UpdateSlider()
        }
    }
    
    func UpdateSlider() {
        UIView.animateWithDuration(0.5, animations: {
            let offset:CGFloat = self.buttonWidth * 0.1
            self.selectView.frame.origin.x = self.buttons[self.indexMenu].frame.origin.x + offset/2
        })
        for button in buttons {
            button.selected = false
        }
        buttons[indexMenu].selected = true
        GetResult()
    }
    
    func Refresh(refreshControl: UIRefreshControl) {
        GetResult()
        // Do your job, when done:
        refreshControl.endRefreshing()
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
    func NoFlight() {
        self.emptyResult = true
        self.TableLoad()
    }
    
    func TableLoad() {
        dispatch_async(dispatch_get_main_queue(),{
            self.indicator.stopAnimating()
            self.flightTableView.reloadData()
        })
    }
    func Default() {
        dispatch_async(dispatch_get_main_queue(),{
            self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", forState: .Normal)
        })
    }
    func FindPrice(flight:Flight) -> (Double,Double) {
        var prices:[Double] = []
        for _flight in flightResults {
            if _flight.number == flight.number && _flight.departure == flight.departure && _flight.arrival == flight.arrival {
                prices.append(_flight.price)
            }
        }
        
        return (prices.maxElement()!,prices.minElement()!)
    }
    func GroupFlight() {
        var result = Array<Flight>()
        for i in 0 ..< flightResults.count {
            print("......................\(flightResults[i].number)")
            if flightResults[i].number != "" {
                var max = flightResults[i].price,min = flightResults[i].price
                var maxIndex = i, minIndex = i
                for j in 0 ..< flightResults.count {
                    if (flightResults[j].number != "" && flightResults[i].number == flightResults[j].number && flightResults[i].departure == flightResults[j].departure && flightResults[i].arrival == flightResults[j].arrival) {
                        if flightResults[j].price > max {
                            max = flightResults[j].price
                            maxIndex = j
                        }
                        if flightResults[j].price < min {
                            min = flightResults[j].price
                            minIndex = j
                        }
                    }
                }
                if maxIndex == minIndex {
                    flightResults[i].new = flightResults[i].price
                    result.append(flightResults[i])
                } else {
                    flightResults[i].old = flightResults[maxIndex].price
                    flightResults[i].new = flightResults[minIndex].price
                    result.append(flightResults[i])
                }
                flightResults[maxIndex] = Flight()
                flightResults[minIndex] = Flight()
            }
        }
        flightResults = result
        print(flightResults)
    }
    func ShowRoundTripConfirmation() {
        let alert = UIAlertController(title: "Are you want to round trip ?", message: "You will choose for your returning flight", preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            searchFlight.Swap()
            searchFlight.isRoundTrip = true
            dispatch_async(dispatch_get_main_queue(), {
                self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", forState: .Normal)
            })
            self.GetResult()
        })
        let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
            searchFlight.isRoundTrip = false
            searchFlight.activeResult = .Proceed
            let returnViewController = self.storyboard?.instantiateViewControllerWithIdentifier("proceed")
            self.showViewController(returnViewController!, sender: self)
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }

    //MARK: - Segue
    
    @IBAction func BackToFlight(segue:UIStoryboardSegue) {
        searchFlight.isRoundTrip = false
        searchFlight.activeResult = .Flight
    }
    
    //MARK: - Action
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
            self.navigationController?.pushViewController(VC!, animated: true)
        }
    }
    
    
    @IBAction func Tapped(sender: AnyObject) {
        view.endEditing(true)
        tapListener.cancelsTouchesInView = false
    }
    
    
    //MARK: - Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if emptyResult {
            return 1
        }
        return flightResults.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if emptyResult || isSearching {
            return tableView.frame.height
        }
        return 78
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isSearching {
            print("searching")
            let cell = tableView.dequeueReusableCellWithIdentifier("searching", forIndexPath: indexPath)
            return cell
        }
        else if emptyResult {
            let cell = tableView.dequeueReusableCellWithIdentifier("noflight",forIndexPath: indexPath)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("flight-cell", forIndexPath: indexPath) as! FlightTableViewCell
            let i = indexPath.row
            let flight = flightResults[i]
            cell.airlinesLogo.image = UIImage(data: flight.airlines.image)
            cell.airlinesLabel.text = flight.number
            if flight.departure.dateFormat == flight.arrival.dateFormat {
                cell.flightTimeLabel.text = "\(flight.departure.timeOnly) - \(flight.arrival.timeOnly)"
            } else {
                cell.flightTimeLabel.text = "\(flight.departure.timeOnly) - Tommorrow, \(flight.arrival.timeOnly)"
            }
            cell.oldPrice.text = ""
            if flight.old > 0 {
                let strikeOldPrice = NSMutableAttributedString(string: flight.old.currency, attributes: [NSStrikethroughStyleAttributeName : 1])
                cell.oldPrice.attributedText = strikeOldPrice
            }
            cell.newPrice.text = flight.new.currency
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)
        if indexPath.row < flightResults.count {
            let reservedFlight = flightResults[indexPath.row]
            
            //create reservation
            if searchFlight.isRoundTrip {
                reservation.back = reservedFlight
            } else {
                reservation.flight = reservedFlight
            }
            
            //push navigation
            if activeUser.valueForKey("id") != nil {
                if searchFlight.isRoundTrip {
                    searchFlight.activeResult = .Proceed
                    let returnViewController = self.storyboard?.instantiateViewControllerWithIdentifier("proceed")
                    self.showViewController(returnViewController!, sender: self)
                } else {
                    ShowRoundTripConfirmation()
                }
                
            } else {
                let loginViewController = storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
                loginViewController.lastVC = self
                self.presentViewController(loginViewController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let i = indexPath.row
        if i < displayCell.count {
            if displayCell[i] {
                displayCell[i] = false
                cell.alpha = 0
                let angle:CGFloat = 10/180 * CGFloat(M_PI)
                let rotation = CGAffineTransformMakeRotation(angle)
                let translate = CGAffineTransformMakeTranslation(50, 80)
                cell.transform = CGAffineTransformConcat(rotation, translate)
                UIView.animateWithDuration(1, delay: 0.1 * Double(i), options: .CurveEaseInOut, animations: {
                    cell.alpha = 1
                    cell.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }
        }

    }
    
    
    //MARK: Input
    
    @IBAction func DateEditBegin(sender: UITextField) {
        tapListener.cancelsTouchesInView = true
        sender.inputView = datePicker
        datePicker.minimumDate = today
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: #selector(DatePickerChange), forControlEvents: .ValueChanged)
    }
    
    func DatePickerChange(sender: UIDatePicker) {
        tapListener.cancelsTouchesInView = true
        searchFlight.dateFlight = sender.date
        dateFlightInput.text = searchFlight.dateFlight.dateFormat
    }
    
    @IBAction func DateFlightEditEnd(sender: UITextField) {
        GetResult()
    }
    
    @IBAction func PassengerEditBegin(sender: UITextField) {
        sender.text = ""
    }
    @IBAction func PassengerChange(sender: UITextField) {
        if sender.text == "" {
            searchFlight.passenger = 1
        } else if let person = Int(sender.text!) {
            searchFlight.passenger = person
        }
    }
    
    @IBAction func PassengerEditEnd(sender: UITextField) {
        passengerInput.text = searchFlight.passenger.passengerFormat
        GetResult()
    }
    
    //MARK: - Connectivity
    
    func GetResult() {
        isSearching = true
        self.view.bringSubviewToFront(indicator)
        self.indicator.startAnimating()
        flightResults.removeAll()
        displayCell.removeAll()
        postParameter = "from=\(searchFlight.origin.id)&to=\(searchFlight.dest.id)&date=\(searchFlight.dateFlight.sqlDate)&passenger=\(searchFlight.passenger)&kodeharga=\(idMenus[indexMenu])"
        let link = "http://rico.webmurahbagus.com/admin/API/GetJadwalAPI.php"
        AjaxPost(link, parameter: postParameter,
                 done: { (data) in
                    self.isSearching = false
                    do {
                        let flights = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
                        if flights?.count == 0 {
                            self.indicator.stopAnimating()
                            self.NoFlight()
                            print("noflight")
                        } else {
                            print("onok")
                            self.emptyResult = false
                            for flight in flights! {
                                
                                let formatter = NSDateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let tempFlight = Flight()
                                if let id = flight["id_jadwal"] as? String {
                                    tempFlight.id = id
                                }
                                if let number = flight["flight_number"] as? String {
                                    tempFlight.number = number
                                }
                                if let from = flight["origin"] as? String {
                                    tempFlight.from = searchFlight.FindCityById(Int(from)!)
                                }
                                if let to = flight["dest"] as? String {
                                    tempFlight.to = searchFlight.FindCityById(Int(to)!)
                                }
                                if let departure = flight["departure"] as? String {
                                    tempFlight.departure = formatter.dateFromString(departure)!
                                }
                                if let arrival = flight["arrival"] as? String {
                                    tempFlight.arrival = formatter.dateFromString(arrival)!
                                }
                                if let price = flight["price"] as? String {
                                    tempFlight.price = Double(price)!
                                }
                                if let type = flight["kode_harga"] as? String {
                                    tempFlight.type = type
                                }
                                if let id_airplane = flight["id_airplane"] as? String {
                                    tempFlight.airlines = searchFlight.FindAirlinesById(Int(id_airplane)!)
                                }
                                self.flightResults.append(tempFlight)
                            }
                            
                            self.GroupFlight()
                            for _ in self.flightResults {
                                self.displayCell.append(true)
                            }
                            self.TableLoad()
                        }
                            
                    } catch {
                        print("error")
                    }

                },
                 error: {
                    self.isSearching = false
                    self.Alert("Please check your internet connection!")
                },
                 completion: {
                    self.TableLoad()
                })
        
    }
    
    
    func ReadAirlinesData() {
        //  check in core data
        let citiesContext = FecthFromCoreData("Airlines")
        searchFlight.airlines.removeAll()
        for cityContext in citiesContext {
            let tempAirline = Airlines()
            tempAirline.id = (cityContext.valueForKey("id") as? Int)!
            tempAirline.airlines = (cityContext.valueForKey("airline") as? String)!
            tempAirline.image = (cityContext.valueForKey("image") as? NSData)!
            searchFlight.airlines.append(tempAirline)
        }
        
        
        let link = "http://rico.webmurahbagus.com/admin/API/GetAirplanesAPI.php"
        AjaxPost(link, parameter: "", done: { (data) in
            do {
                let airplanes = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
                for airplane in airplanes! {
                    let tempAirline = Airlines()
                    if let airline = airplane["airplane"] as? String {
                        tempAirline.airlines = airline
                    }
                    if let id = airplane["id_airplane"] as? String {
                        tempAirline.id = Int(id)!
                    }
                    if let image = airplane["image"] as? String {
                        if let url = NSURL(string: "http://rico.webmurahbagus.com/admin/images/\(image)") {
                            if let data = NSData(contentsOfURL: url) {
                                tempAirline.image = data
                            }
                        }
                    }
                    if !searchFlight.IsAirlinesExist(tempAirline) {
                        searchFlight.airlines.append(tempAirline)
                        tempAirline.SaveToCoreData()
                        self.Default()
                        searchFlight.Default()
                    }
                }
            } catch {
                print("error")
            }
        })
        searchFlight.Default()
        
        
    }

    
    func ReadCityData() {
//        check in core data
        let citiesContext = FecthFromCoreData("Destinations")
        searchFlight.cities.removeAll()
        for cityContext in citiesContext {
            let tempCity = City()
            tempCity.id = (cityContext.valueForKey("id") as? Int)!
            tempCity.city = (cityContext.valueForKey("city") as? String)!
            tempCity.alias = (cityContext.valueForKey("alias") as? String)!
            tempCity.image = (cityContext.valueForKey("image") as? NSData)!
            searchFlight.cities.append(tempCity)
        }
        
        //ResetCitiesData()
        
        let link = "http://rico.webmurahbagus.com/admin/API/GetDestinationAPI.php"
        AjaxPost(link, parameter: "", done: { (data) in
            do {
                let cities = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
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
                    if let image = city["image"] as? String {
                        if let url = NSURL(string: "http://rico.webmurahbagus.com/admin/images/\(image)") {
                            if let data = NSData(contentsOfURL: url) {
                                tempCity.image = data
                            }        
                        }
                    }
                    
                    if !searchFlight.IsCityExist(tempCity) {
                        searchFlight.cities.append(tempCity)
                        tempCity.SaveToCoreData()
                        self.Default()
                        searchFlight.Default()
                    }
                }
                
            } catch {
                print("error")
            }
        })        
        searchFlight.Default()
        
        
    }
    
    
}
