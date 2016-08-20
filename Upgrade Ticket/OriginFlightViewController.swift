//
//  OriginFlightViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/5/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class OriginFlightViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource {
    
    var cities = Array<City>()
    var filteredCities = Array<City>()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlight.isRoundTrip = false
        searchBar.delegate = self
        searchFlight.activeResult = .Flight
        self.cities = searchFlight.cities
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table
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
        let cell = tableView.dequeueReusableCellWithIdentifier("city_cell", forIndexPath: indexPath)
        if searchBar.text != "" {
            if (filteredCities.count == 0) {
                cell.textLabel?.text = "No Result Found"
            } else {
                cell.textLabel?.text = filteredCities[indexPath.row].cityAlias
            }
        } else {
            cell.textLabel?.text = cities[indexPath.row].cityAlias
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchBar.text == "" {
            searchFlight.origin = cities[indexPath.row]
        } else {
            searchFlight.origin = filteredCities[indexPath.row]
        }
    }
    
    //MARK: SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        FillterCity(searchText)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        CloseInputView()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? SearchViewController {
            destination.UpdateCity()
        }
    }
    
    
    
    //MARK: Method
    func FillterCity(search:String) {
        filteredCities = cities.filter({
            city in
            return city.cityAlias.lowercaseString.containsString(search.lowercaseString)
        })
        tableView.reloadData()
    }
    func CloseInputView() {
            self.view.endEditing(true)
        }
}
