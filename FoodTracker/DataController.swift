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
    
    return [("test", "test")]
  }
  
}
