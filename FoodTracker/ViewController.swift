//
//  ViewController.swift
//  FoodTracker
//
//  Created by Brown Magic on 5/14/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
  
  @IBOutlet weak var tableView: UITableView!
  
  //app id and secret
  let kAppId = "7ad4576a"
  let kAppKey = "9a380dac829740f50f5812805086c872"
  
  var searchController:UISearchController!
  
  var suggestedSearchFoods:[String] = []
  // as we find foods that meet the search criteria we will save them here
  var filteredSuggestedSearchFoods:[String] = []
  
  var scopeButtonTitles:[String] = ["Recommended", "Search Results", "Saved"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // create instance of our searchController
    self.searchController = UISearchController(searchResultsController: nil)
    self.searchController.searchResultsUpdater = self
    self.searchController.dimsBackgroundDuringPresentation = false
    // we don't want the search bar to hide and slide everything up
    self.searchController.hidesNavigationBarDuringPresentation = false
    
    // setup search controlloer search bar frame
    self.searchController.searchBar.frame = CGRect(x: self.searchController.searchBar.frame.origin.x, y: self.searchController.searchBar.frame.origin.y, width: self.searchController.searchBar.frame.size.width , height: 44.0)
    
    // update tableView header with the search bar which is coming from the searchController (via init)
    self.tableView.tableHeaderView = self.searchController.searchBar
    
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles
    // give us access to callbacks from the search bar
    self.searchController.searchBar.delegate = self
    
    // make sure search result controller is presented in the current view controller
    self.definesPresentationContext = true
    
    self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "hummus", "swiss cheese", "sandwich", "eggs", "water", "soylent", "hotdog", "ice cream", "jelly donut", "ketchup", "milk", "mix nuts", "mustard", "oatmeal", "peanut butter", "pizza", "porkchops", "potato", "chips", "gin and tonic", "cake", "ice"]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK - UITableViewDataSource
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
    var foodName:String
    if (self.searchController.active){
      foodName = filteredSuggestedSearchFoods[indexPath.row]
    } else {
      foodName = suggestedSearchFoods[indexPath.row]
    }
    
    cell.textLabel?.text = foodName
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (self.searchController.active) {
      // if search controller is active use filtered suggested search foods
      return self.filteredSuggestedSearchFoods.count
    } else {
      return self.suggestedSearchFoods.count
    }
  }
  
  // MARK - UISearchResultsUpdating
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    // sometimes we have used .delegate or .datasource instead
    self.searchController.searchResultsUpdater = self
    
    // get the search string
    let searchString = self.searchController.searchBar.text
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    // call filter func
    self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
    self.tableView.reloadData()
  }
  
  func filterContentForSearch (searchText:String, scope:Int) {
    self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food:String) -> Bool in
      var foodMatch = food.rangeOfString(searchText)
      return foodMatch != nil
    })
  }
  
  // MARK - UISearchBarDelgate
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    // gets called when we press the search button
    makeRequest(searchBar.text)
    
  }
  
  func makeRequest (searchString:String) {
//    let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppId)&appKey=\(kAppKey)")
//    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
//      // convert to string from NSData I think
//      var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//      println(stringData)
//      println(response)
//    })
//    // execute the request
//    task.resume()
    
    // POST request
    var request = NSMutableURLRequest(URL: NSURL(string: "https://api.nutritionix.com/v1_1/search/")!)
    let session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    
    var params = [
      "appId": kAppId,
      "appKey": kAppKey,
      "fields": ["item_name", "brand_name", "keywords", "usda_fields"],
      "limit": "50",
      "query": searchString,
      "filters": ["exists":["usda_fields": true]]
    ]
    
    var error:NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
    // specify the request type
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    // make our request
    var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
      // code evals after completion of request
      
      // convert to string
      var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
      var conversionError:NSError?
      // convert string json to NSDictionary
      var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
      println(jsonDictionary)
    })
    task.resume()
    
  }
  
}

