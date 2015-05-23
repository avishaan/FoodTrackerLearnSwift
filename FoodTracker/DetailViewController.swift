//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Brown Magic on 5/14/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import CoreData
import HealthKit

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
    // request auth for healthstore
    requestAuthorizationForHealthStore()
    
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
    
    var leftAllignedParagraphStyle = NSMutableParagraphStyle()
    leftAllignedParagraphStyle.alignment = NSTextAlignment.Left
    leftAllignedParagraphStyle.lineSpacing = 20.0
    
    var styleFirstWordAttributesDictionary = [
      NSForegroundColorAttributeName: UIColor.blackColor(),
      NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
      NSParagraphStyleAttributeName: leftAllignedParagraphStyle,
    ]
    
    var style1AttributesDictionary = [
      NSForegroundColorAttributeName: UIColor.darkGrayColor(),
      NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
      NSParagraphStyleAttributeName: leftAllignedParagraphStyle,
    ]
    
    var style2AttributesDictionary = [
      NSForegroundColorAttributeName: UIColor.lightGrayColor(),
      NSFontAttributeName: UIFont.systemFontOfSize(18.0),
      NSParagraphStyleAttributeName: leftAllignedParagraphStyle,
    ]
   
    // add calcium to our existing string
    let calciumTitleString = NSAttributedString(string: "Calcium ", attributes: styleFirstWordAttributesDictionary)
    let calciumBodyString = NSAttributedString(string: String(format: "%.3f", (usdaItem.calcium as NSString).floatValue) + "mg\n", attributes: style1AttributesDictionary)
    itemAttributedString.appendAttributedString(calciumTitleString)
    itemAttributedString.appendAttributedString(calciumBodyString)
    
    // add carbohydrate to our existing string
    let carbohydrateTitleString = NSAttributedString(string: "Carbohydrate ", attributes: styleFirstWordAttributesDictionary)
    let carbohydrateBodyString = NSAttributedString(string: String(format: "%.3f", (usdaItem.carbohydrate as NSString).floatValue) + "g\n", attributes: style2AttributesDictionary)
    itemAttributedString.appendAttributedString(carbohydrateTitleString)
    itemAttributedString.appendAttributedString(carbohydrateBodyString)
    
    // add cholesterol to our existing string
    let cholesterolTitleString = NSAttributedString(string: "Cholesterol ", attributes: styleFirstWordAttributesDictionary)
    let cholesterolBodyString = NSAttributedString(string: String(format: "%.3f", (usdaItem.cholesterol as NSString).floatValue) + "mg\n", attributes: style1AttributesDictionary)
    itemAttributedString.appendAttributedString(cholesterolTitleString)
    itemAttributedString.appendAttributedString(cholesterolBodyString)
    
    // add energy to our existing string
    let energyTitleString = NSAttributedString(string: "Energy ", attributes: styleFirstWordAttributesDictionary)
    let energyBodyString = NSAttributedString(string: String(format: "%.3f", (usdaItem.energy as NSString).floatValue) + " Calories\n", attributes: style2AttributesDictionary)
    itemAttributedString.appendAttributedString(energyTitleString)
    itemAttributedString.appendAttributedString(energyBodyString)
    
    // add fatTotal to our existing string
    let fatTotalTitleString = NSAttributedString(string: "Fat Total ", attributes: styleFirstWordAttributesDictionary)
    let fatTotalBodyString = NSAttributedString(string: String(format: "%.3f", (usdaItem.fatTotal as NSString).floatValue) + "g\n", attributes: style1AttributesDictionary)
    itemAttributedString.appendAttributedString(fatTotalTitleString)
    itemAttributedString.appendAttributedString(fatTotalBodyString)
    
    // add protein to our existing string
    let proteinTitleString = NSAttributedString(string: "Protein ", attributes: styleFirstWordAttributesDictionary)
    let proteinBodyString = NSAttributedString(string: String(format: "%.3f", (usdaItem.protein as NSString).floatValue) + "g\n", attributes: style2AttributesDictionary)
    itemAttributedString.appendAttributedString(proteinTitleString)
    itemAttributedString.appendAttributedString(proteinBodyString)
    
    // add sugar to our existing string
    let sugarTitleString = NSAttributedString(string: "Sugar ", attributes: styleFirstWordAttributesDictionary)
    let sugarBodyString = NSAttributedString(string: String(format: "%.3f", (usdaItem.sugar as NSString).floatValue) + "g\n", attributes: style1AttributesDictionary)
    itemAttributedString.appendAttributedString(sugarTitleString)
    itemAttributedString.appendAttributedString(sugarBodyString)
    
    // add vitaminC to our existing string
    let vitaminCTitleString = NSAttributedString(string: "Vitamin C ", attributes: styleFirstWordAttributesDictionary)
    let vitaminCBodyString = NSAttributedString(string: String(format: "%.3f", (usdaItem.vitaminC as NSString).floatValue) + "mg\n", attributes: style2AttributesDictionary)
    itemAttributedString.appendAttributedString(vitaminCTitleString)
    itemAttributedString.appendAttributedString(vitaminCBodyString)
    
    return itemAttributedString
    
  }
  // func to request authorizations require for healthkit read and write
  func requestAuthorizationForHealthStore() {
    
    let dataTypeToWrite = [
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCholesterol),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySugar),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminC)
    ]
    
    let dataTypesToRead = [
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCholesterol),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySugar),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminC)
    ]
    
    var store:HealthStoreConstant = HealthStoreConstant()
    // get access to the healthstore
    store.healthStore.requestAuthorizationToShareTypes(NSSet(array: dataTypeToWrite), readTypes: NSSet(array: dataTypesToRead)) { (success, error) -> Void in
      if success {
        println("User completed auth request.")
      } else {
        println("User canceled the request \(error)")
      }
      
    }
    
  }
  func saveFoodItem (foodItem:USDAItem) {
    // make sure it is available
    if HKHealthStore.isHealthDataAvailable() {
      
      let timeFoodWasEntered = NSDate()
      let foodMetaData = [
        HKMetadataKeyFoodType: foodItem.name,
        "HKBrandName": "USDAItem",
        "HKFoodTypeID": foodItem.idValue
      ]
    } else {
      // you would tell the user here if healthkit was not available
    }
    
  }
}
