//
//  DataController.swift
//  FoodTracker
//
//  Created by Brown Magic on 5/15/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController {
  
  //create class function, we won't need an instance of the data controller, pass in dictionary and we want tuples coming back out
  class func jsonAsUSDAIdAndNameSearchResults(json:NSDictionary) -> [(name:String, idValue:String)] {
    var usdaItemsSearchResults:[(name:String, idValue:String)] = []
    var searchResult:(name:String, idValue:String)
    
    if json["hits"] != nil {
      // the hits array is complex so just use anyObject as type
      let results:[AnyObject] = json["hits"]! as [AnyObject]
      
      // iterate through all the results as itemDictionary
      for itemDictionary in results {
        // before using a key, make sure it exists first
        if itemDictionary["_id"] != nil {
          if itemDictionary["fields"] != nil {
            let fieldsDictionary = itemDictionary["fields"] as NSDictionary
            if itemDictionary["item_name"] != nil {
              let idValue:String = itemDictionary["_id"]! as String
              let name:String = fieldsDictionary["item_name"]! as String
              searchResult = (name: name, idValue: idValue)
              usdaItemsSearchResults += [searchResult]
            }
          }
        }
      }
    }
    
    return usdaItemsSearchResults
  }
  
  func saveUSDAItemForId(idValue: String, json : NSDictionary) {
    if json["hits"] != nil {
      let results:[AnyObject] = json["hits"]! as [AnyObject]
      
      for itemDictionary in results {
        // check that there is an id and that it equals the idValue
        if itemDictionary["_id"] != nil && itemDictionary["_id"] as String == idValue {
          
          // make sure we don't save the same object twice into core data
          let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
          var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
          
          let itemDictionaryId = itemDictionary["_id"]! as String
          
          // does the idValue equal itemDictionaryId, you replace the %@ with the second argument passed in
          // predicate
          let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
          requestForUSDAItem.predicate = predicate
          
          var error:NSError?
          
          var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
          
          // if items exist, don't write again
          if items?.count != 0 {
            // item is already saved so don't save it again
            return
          } else {
            // we haven't save to coreData yet so go ahead and do that
            let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
            let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
            usdaItem.idValue = itemDictionary["_id"]! as String
            usdaItem.dateAdded = NSDate()
            
            if itemDictionary["fields"] != nil {
              let fieldsDictionary = itemDictionary["fields"]! as NSDictionary
              
              if fieldsDictionary["items_name"] != nil {
                usdaItem.name = fieldsDictionary["items_name"]! as String
              }
              
              if fieldsDictionary["usda_fields"] != nil {
                let usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as NSDictionary
                if usdaFieldsDictionary["CA"] != nil {
                  let calciumDictionary = usdaFieldsDictionary["CA"]! as NSDictionary
                  // it's possible the value could be a string or a number
                  let calciumValue:AnyObject = calciumDictionary["value"]!
                  // implicit conversion to string
                  usdaItem.calcium = "\(calciumValue)"
                } else {
                  // if there is no calcium value then use the following
                  usdaItem.calcium = "0"
                }
                
                // save carbs information if it exists
                if usdaFieldsDictionary["CHOCDF"] != nil {
                  let carbohydrateDictionary = usdaFieldsDictionary["CHOCDF"]! as NSDictionary
                  if carbohydrateDictionary["value"] != nil {
                    let carbohydrateValue: AnyObject = carbohydrateDictionary["value"]!
                    usdaItem.carbohydrate = "\(carbohydrateValue)"
                  }
                }
                else {
                  usdaItem.carbohydrate = "0"
                }
                
                // save fat information if it exists
                if usdaFieldsDictionary["FAT"] != nil {
                  let fatTotalDictionary = usdaFieldsDictionary["FAT"]! as NSDictionary
                  if fatTotalDictionary["value"] != nil {
                    let fatTotalValue:AnyObject = fatTotalDictionary["value"]!
                    usdaItem.fatTotal = "\(fatTotalValue)"
                  }
                }
                else {
                  usdaItem.fatTotal = "0"
                }
                
                // check and save cholesterol information if it exists
                if usdaFieldsDictionary["CHOLE"] != nil {
                  let cholesterolDictionary = usdaFieldsDictionary["CHOLE"]! as NSDictionary
                  if cholesterolDictionary["value"] != nil {
                    let cholesterolValue: AnyObject = cholesterolDictionary["value"]!
                    usdaItem.cholesterol = "\(cholesterolValue)"
                  }
                }
                else {
                  usdaItem.cholesterol = "0"
                }
                
                // check and save protein information if it exists
                if usdaFieldsDictionary["PROCNT"] != nil {
                  let proteinDictionary = usdaFieldsDictionary["PROCNT"]! as NSDictionary
                  if proteinDictionary["value"] != nil {
                    let proteinValue: AnyObject = proteinDictionary["value"]!
                    usdaItem.protein = "\(proteinValue)"
                  }
                }
                else {
                  usdaItem.protein = "0"
                }
              }
            }
          }
          
        }
      }
    }
  }
  
}
