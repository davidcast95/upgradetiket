//
//  SearchCityViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/6/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class SearchCityViewController: UIViewController,UISearchBarDelegate , UITableViewDataSource, UITableViewDelegate {
    
    var identifier = ""
    var cities = Array<City>()
    var filteredCities = Array<City>()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //searchFlight.activeResult = .Search
        
        self.cities = searchFlight.cities
        if identifier == "search_origin" {
            cities.RemoveByCityAlias(searchFlight.dest)
        }
        else if identifier == "search_destination" {
            cities.RemoveByCityAlias(searchFlight.origin)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tables
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
            if identifier == "search_origin" {
                searchFlight.origin = cities[indexPath.row]
            }
            else if identifier == "search_destination" {
                searchFlight.dest = cities[indexPath.row]
            }
            self.performSegueWithIdentifier("back_to_search", sender: self.closeButton)
        } else if (filteredCities.count > 0) {
            
            if identifier == "search_origin" {
                searchFlight.origin = filteredCities[indexPath.row]
            }
            else if identifier == "search_destination" {
                searchFlight.dest = filteredCities[indexPath.row]
            }
            self.performSegueWithIdentifier("back_to_search", sender: self.closeButton)
        }
    }
    
    
    //SearchBar
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
    
    func CloseInputView() {
        self.view.endEditing(true)
    }
    
    //Method
    func FillterCity(search:String) {
        filteredCities = cities.filter({
            city in
            return city.cityAlias.lowercaseString.containsString(search.lowercaseString)
        })
        tableView.reloadData()
    }

}
