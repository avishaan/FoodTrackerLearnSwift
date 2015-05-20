//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Brown Magic on 5/14/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
  
  var usdaItem:USDAItem?
  
  @IBOutlet weak var textView: UITextView!
  
  // we need our notification center to be hooked up before the view load. if we wait until the load it may be too late to listen for changes
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  // need to remove observer when deinitializing the view controller
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func usdaItemDidComplete(notification: NSNotification) {
    println("usdaItem did complete in detailed VC")
    usdaItem = notification.object as? USDAItem
  }
  
  @IBAction func eatItBarButtonItemPressed(sender: UIBarButtonItem) {
  }
  
}
