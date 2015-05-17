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
  
}
