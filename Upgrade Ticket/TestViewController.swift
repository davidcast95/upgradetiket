//
//  TestViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 7/2/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class TestViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var cities = Array<City>()
    var filteredCities = Array<City>()
    var displayCell = Array<Bool>()
    var destView = UIView()
    var selectedIndex = -1
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        searchFlight.activeResult = .Flight
        if let id = restorationIdentifier {
            self.cities = searchFlight.cities
            print(searchFlight.origin.city)
            if id == "destination" {
                self.cities.RemoveByCityAlias(searchFlight.origin)
            }
        }
        
        
        displayCell.removeAll()
        for _ in 0..<cities.count {
            displayCell.append(true)
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    //MARK : - TableViewCell Animation
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBar.text != "") {
            if (filteredCities.count == 0) {
                return 1
            }
            return filteredCities.count
        }
        return cities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("city_cell", forIndexPath: indexPath) as? CityTableViewCell
        
        if searchBar.text != "" {
            if (filteredCities.count == 0) {
                cell?.cityLabel.text = "No Result Found"
            } else {
                let imageData = filteredCities[indexPath.row].image
                cell?.featureImage.image = UIImage(data: imageData)
                cell?.cityLabel.text = filteredCities[indexPath.row].cityAlias
            }
        } else {
            let imageData = cities[indexPath.row].image
            if indexPath.row % 2 == 0 {
                cell?.featureImage.image = UIImage(data: imageData)
            } else {
                cell?.featureImage.image = UIImage(data: imageData)
            }
            cell?.cityLabel.text = cities[indexPath.row].cityAlias
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let id = self.restorationIdentifier {
            print(id)
            if id == "origin" {
                if searchBar.text == "" {
                    searchFlight.origin = cities[indexPath.row]
                } else {
                    searchFlight.origin = filteredCities[indexPath.row]
                }
                if let destVC = storyboard?.instantiateViewControllerWithIdentifier("destination") as? TestViewController {
                    self.presentViewController(destVC, animated: true, completion: nil)
                }
            } else {
                if searchBar.text == "" {
                    searchFlight.dest = cities[indexPath.row]
                } else {
                    searchFlight.dest = filteredCities[indexPath.row]
                }
                
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
    
    //SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        FilterCity(searchText)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        CloseInputView()
    }
    
    func CloseInputView() {
        self.view.endEditing(true)
    }
    
    //Method
    func FilterCity(search:String) {
        filteredCities = cities.filter({
            city in
            return city.cityAlias.lowercaseString.containsString(search.lowercaseString)
        })
        
        displayCell.removeAll()
        for _ in 0..<filteredCities.count {
            displayCell.append(true)
        }
        tableView.reloadData()
    }
    
    
}
