//
//  ViewController2.swift
//  zzzDumpCollView
//
//  Created by Dad on 1/3/17.
//  Copyright © 2017 JP. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON



class ViewController2: UIViewController {
  
  
  var photo: Item!
  var store: ViewController!
  
  
  @IBOutlet weak var imageViewDetail: UIImageView!
  
  var image: UIImage?
  
  
  enum ImageResult {
    case success(UIImage)
    case failure(Error)
  }
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /*
    self.fetchImageForPhoto(photo: photo)
    {    result in
      if case ImageResult.success(let image) =  result {
        OperationQueue.main.addOperation() {
          self.imageViewDetail.image = image
        }
      } // end if
    } // end closure
    
    
    */
    
    let url = photo.remoteURL
    self.imageViewDetail?.pin_setImage(from: url, placeholderImage: UIImage(named: "placeholder.png"))
    { result in
      
    }
    

    
    
  }  // end viewDidLaod
  
  
  
  
  
  
  
  func fetchImageForPhoto(photo: Item,  completion: @escaping (ImageResult) -> Void)  {
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
  
  
  
    
  
} // end class
