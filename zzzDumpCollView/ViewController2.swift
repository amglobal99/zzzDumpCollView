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
 // var store: ViewController!
  var queue1 = OperationQueue()
  
  
  
  @IBOutlet weak var imageViewDetail: UIImageView!
  
 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let url = photo.remoteURL
    self.imageViewDetail?.pin_setImage(from: url, placeholderImage: UIImage(named: "placeholder.png"))  { _ in   }
    //self.imageViewDetail?.pin_setImage(from: url, placeholderImage: UIImage(named: "placeholder.png"), completion: nil)
    
  }  // end viewDidLaod
  
  
  
    
  
} // end class
