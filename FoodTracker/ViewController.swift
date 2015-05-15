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
    
  }

}

