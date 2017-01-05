//
//  Item.swift
//  zzzDumpCollView
//
//  Created by Dad on 1/3/17.
//  Copyright © 2017 JP. All rights reserved.
//

import Foundation
import UIKit




class Item {
  
  let title: String
  let remoteURL: URL
  let photoID: String
  let dateTaken: Date
  var image: UIImage?
  let datetakenUnknown:String
  
  
  init(title: String, photoID: String, remoteURL: URL, dateTaken: Date, datetakenUnknown:String) {
    self.title = title
    self.photoID = photoID
    self.remoteURL = remoteURL
    self.dateTaken = dateTaken
    //self.image = image
    self.datetakenUnknown = datetakenUnknown
  }
  
}  //end class




extension Item: Equatable {}


func == (lhs:Item, rhs: Item) -> Bool  {
  return lhs.photoID == rhs.photoID
}



