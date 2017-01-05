//
//  ItemStore.swift
//  zzzDumpCollView
//
//  Created by Dad on 1/3/17.
//  Copyright © 2017 JP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit





class ItemStore {
  
  
  
  enum ImageResult {
    case success(UIImage)
    case failure(Error)
  }
  
  
  
  
  
  
  
  
  
  // MARK: - Store methods
  
  func getPhotosFromJSON(json: JSON) -> [Item] {
    var finalPhotos: [Item] = []
    for (_, obj) in json {
      if let photo = getPhotoFromJSON(json: obj) {
        finalPhotos.append(photo)
      }
    }
    return finalPhotos
  } // end func
  
  
  
  
  func getPhotoFromJSON(json: JSON) -> Item? {
    guard
      let photoID = json["id"].string,
      let title = json["title"].string,
      let dateString = json["datetaken"].string,
      let photoURLString = json["url_h"].string,
      let url = URL(string: photoURLString),
      let datetaken = Constants.Configuration.dateFormatter.date(from: dateString),
      let datetakenunknown = json["datetakenunknown"].string
      else {
        return nil    // don't have enough info, print("returing nil here" )
    }
    return Item(title: title, photoID: photoID, remoteURL: url, dateTaken: datetaken, datetakenUnknown: datetakenunknown)
  }
  
  
  
  
  
  func fetchImage(photo: Item,  completion: @escaping (ImageResult) -> Void)  {
    
    if let image = photo.image  {
      completion(.success(image) )
    }
    let photoURL = photo.remoteURL
    let request = URLRequest(url: photoURL )
    
    Alamofire.request(request).response
      {  response in
        guard response.error == nil else {
          return
        }
        guard response.data != nil else {
          return
        }
        var result:ImageResult
        if  let  image = UIImage(data: response.data!)  {
          result = ImageResult.success(image)
        } else {
          result = ImageResult.failure("Could not create Photot" as! Error)
        }
        
        if case let ImageResult.success(image) = result {
          photo.image  = image
        }
        
        
        completion(result)
        
    } // end closure
    
  } // end func
  
  
  
  
  
  
  

  
  
  
  
  
  
}
