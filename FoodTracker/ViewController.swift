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
  
  var searchController:UISearchController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // create instance of our searchController
    self.searchController = UISearchController(searchResultsController: nil)
    self.searchController.dimsBackgroundDuringPresentation = false
    // we don't want the search bar to hide and slide everything up
    self.searchController.hidesNavigationBarDuringPresentation = false
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // Mark - UITableViewDataSource
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  // Mark - UISearchResultsUpdating
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    // sometimes we have used .delegate or .datasource instead
    self.searchController.searchResultsUpdater = self
  }

}

