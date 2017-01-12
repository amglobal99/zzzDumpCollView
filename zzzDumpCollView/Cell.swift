//
//  Cell.swift
//  zzzDumpCollView
//
//  Created by Dad on 1/3/17.
//  Copyright © 2017 JP. All rights reserved.
//

import Foundation
import UIKit



class Cell: UICollectionViewCell {
  
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textLabel: UILabel!
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  
  
  
  
  func updateWithImage(_ image: UIImage?) {
    if let imageToDisplay = image {
      spinner .stopAnimating()
      imageView.image = imageToDisplay
    } else {
      spinner.startAnimating()
      imageView.image = nil
    }
  }  //end method
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //updateWithImage(nil )
    spinner.startAnimating()
    imageView.image = nil
  }
  
  

  override func prepareForReuse() {
    super.prepareForReuse()
    //updateWithImage(nil )
    //spinner.startAnimating()   // Seems to be causing probems with PINRemoteImage. Check
    imageView.image = nil
  }
  
 
  
  
  
  
  
} // end class

