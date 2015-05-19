//
//  ViewController.swift
//  FoodTracker
//
//  Created by Brown Magic on 5/14/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
  
  @IBOutlet weak var tableView: UITableView!
  
  //app id and secret
  let kAppId = "7ad4576a"
  let kAppKey = "9a380dac829740f50f5812805086c872"
  
  var searchController:UISearchController!
  
  var suggestedSearchFoods:[String] = []
  // as we find foods that meet the search criteria we will save them here
  var filteredSuggestedSearchFoods:[String] = []
  
  var apiSearchForFoods:[(name:String, idValue:String)] = []
  
  var scopeButtonTitles:[String] = ["Recommended", "Search Results", "Saved"]
  
  var jsonResponse:NSDictionary!
  
  var dataController = DataController()
  
  var favoritedUSDAItems:[USDAItem] = []
  
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
  
  // MARK: - UITableViewDataSource
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
    var foodName:String
    
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    
    if selectedScopeButtonIndex == 0 {
      if (self.searchController.active){
        foodName = filteredSuggestedSearchFoods[indexPath.row]
      } else {
        foodName = suggestedSearchFoods[indexPath.row]
      }
    } else if selectedScopeButtonIndex == 1 {
      // get the name from the tuple at the correct row
      foodName = apiSearchForFoods[indexPath.row].name
    } else {
      foodName = ""
    }
    
    cell.textLabel?.text = foodName
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // see which search scope button is selected
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    if selectedScopeButtonIndex == 0 {
      if (self.searchController.active) {
        // if search controller is active use filtered suggested search foods
        return self.filteredSuggestedSearchFoods.count
      } else {
        return self.suggestedSearchFoods.count
      }
    } else if selectedScopeButtonIndex == 1 {
      return self.apiSearchForFoods.count
    } else {
      return 0
    }
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // control flow based on which of the 3 search buttons are selected
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    
    if selectedScopeButtonIndex == 0 {
      var searchFoodName:String
      if self.searchController.active {
        searchFoodName = filteredSuggestedSearchFoods[indexPath.row]
      } else {
        searchFoodName = suggestedSearchFoods[indexPath.row]
      }
      // either way we need to switch the selected scope button over
      self.searchController.searchBar.selectedScopeButtonIndex = 1
      // and then make the request using that search term
      makeRequest(searchFoodName)
      
    } else if selectedScopeButtonIndex == 1 {
      // at this point you have clicked on an item in the search results so we will go ahead and save it because we figure you are interested enough to click then we should save it
      // get the idValue from the tuple that matches the row we are looking at
      let idValue = apiSearchForFoods[indexPath.row].idValue
      self.dataController.saveUSDAItemForId(idValue, json: self.jsonResponse)
      
    } else if selectedScopeButtonIndex == 2 {
      
    } else {
      
    }
    
  }
  
  // MARK: - UISearchResultsUpdating
  
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
  
  // MARK: - UISearchBarDelgate
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    self.searchController.searchBar.selectedScopeButtonIndex = 1
    // gets called when we press the search button
    makeRequest(searchBar.text)
    
  }
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    self.tableView.reloadData()
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
//      var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//      println(stringData)
      var conversionError:NSError?
      // convert string json to NSDictionary
      var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
      println(jsonDictionary)
      
      if conversionError != nil {
        println(conversionError!.localizedDescription)
        let errorString = NSString(data: data , encoding: NSUTF8StringEncoding)
        println("Error in parsing: \(errorString)")
      } else {
        if jsonDictionary != nil {
          self.jsonResponse = jsonDictionary!
          self.apiSearchForFoods = DataController.jsonAsUSDAIdAndNameSearchResults(jsonDictionary!)
          // we need to call the reloadData on the main thread, if we don't it will update UI on the background thread and just take forever to update
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
          })
        } else {
          let errorString = NSString(data: data , encoding: NSUTF8StringEncoding)
          println("Error in parsing: \(errorString)")
        }
      }
    })
    task.resume()
    
  }
  
  // MARK: Setup CoreData 
  
  func requestfavoritedUSDAItems() {
    let fetchRequest = NSFetchRequest(entityName: "USDAItem")
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    let managedObjectContext = appDelegate.managedObjectContext
    self.favoritedUSDAItems = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [USDAItem]
  }
  
}

