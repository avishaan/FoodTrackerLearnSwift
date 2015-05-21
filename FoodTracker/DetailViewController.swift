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
    
    // one spot we can get the USDAItem is here other is based on NSNotification
    if self.usdaItem != nil {
      // make sure we have information in the usdaItem before setting the string
      self.textView.attributedText = createAttributedString(usdaItem!)
    }
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
    self.usdaItem = notification.object as? USDAItem
    
    // make sure the view has loaded before we update the UI. This could be called before the UI has even loaded because we set this in the initializer.
    if self.isViewLoaded() && self.view.window != nil {
      self.textView.attributedText = createAttributedString(usdaItem)
    }
  }
  
  @IBAction func eatItBarButtonItemPressed(sender: UIBarButtonItem) {
  }
  
  func createAttributedString(usdaItem: USDAItem!) -> NSAttributedString {
    var itemAttributedString = NSMutableAttributedString()
    
    var centeredParagraphStyle = NSMutableParagraphStyle()
    centeredParagraphStyle.alignment = NSTextAlignment.Center
    centeredParagraphStyle.lineSpacing = 10.0
    
    var titleAttributesDictionary = [
      NSForegroundColorAttributeName: UIColor.blackColor(),
      NSFontAttributeName: UIFont.boldSystemFontOfSize(22.0),
      NSParagraphStyleAttributeName: centeredParagraphStyle
    ]
    
    let titleString = NSAttributedString(string: "\(usdaItem.name)\n", attributes: titleAttributesDictionary)
    itemAttributedString.appendAttributedString(titleString)
    
    return itemAttributedString
    
  }
}
