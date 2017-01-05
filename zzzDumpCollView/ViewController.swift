//
//  ViewController.swift
//  zzzDumpCollView
//
//  Created by Dad on 1/3/17.
//  Copyright © 2017 JP. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ViewController: UICollectionViewController {

  
  var photos: [Item] = []
  var isDataLoaded: Bool =  false
  let url = "https://api.flickr.com/services/rest?api_key=a6d819499131071f158fd740860a5a88&method=flickr.photos.getRecent&format=json&nojsoncallback=1&extras=url_h,date_taken"
  
  @IBOutlet var collView: UICollectionView!
  
 
  enum PhotosResult {
    case success([Item])
    case failure(Error)
  }
  
  enum ImageResult {
    case success(UIImage)
    case failure(Error)
  }

  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collView.dataSource =  self
    collView.delegate =  self
    
    let handler: (Result<JSON>) -> Void =
      { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let jsonObject = result.value!
            let items = strongSelf.photosFromJSONObject(json: jsonObject)
        
          OperationQueue.main.addOperation()  {
            if case PhotosResult.success(let photos) = items {
                  print(" We have a total of \(photos.count)  photos")
                  strongSelf.photos = photos
            }
            
              // ----Reload Data
              strongSelf.isDataLoaded = true
              strongSelf.collView.reloadData()
          } // end operation
          
      } // end closure
    
    
      getJSONObject(for: url, completionHandler: handler)
    
    } // end viewDidLoad

  
  
  
  
  
  
  
  
  
  // MARK: - Store methods
  
  func photosFromJSONObject(json: JSON) -> PhotosResult {
    var finalPhotos: [Item] = []
    for (_, obj) in json {
      if let photo = photoFromJSONObject(json: obj) {
        finalPhotos.append(photo)
      }
    }
    return PhotosResult.success(finalPhotos)
  } // end func
  
  
  
  
  func photoFromJSONObject(json: JSON) -> Item? {
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
  
  
  
  
  
  
  func getJSONObject(for urlString:String,  completionHandler:  @escaping  (Result<JSON>)->Void    ) {
      guard let url:URL = URL(string: urlString) else {
        return
      }
      let urlRequest = URLRequest(url: url)
      
        Alamofire.request(urlRequest).responseJSON
          { response  in
            guard response.result.error == nil else {   // got an error
              print(response.result.error!)
              completionHandler(Result.failure(response.result.error!) )
              return
            }
            guard response.result.value != nil else {  // Data is nil
              print("Request did not return any data")
              completionHandler(Result.failure(   "Request did not return any data" as! Error  ) )
              return
            }
            let jsonObject:JSON  = JSON(response.result.value!)
            let result = jsonObject["photos","photo"]
            completionHandler(Result.success(result))
        }  // end closure
    
  } // end function
  
  
  
  
  
  
  
  
  
  /// Function called during the segue from NinthViewController to Detail View Controller
  
  override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPhotoSegue" {
      let destinationVC = segue.destination as! ViewController2
      if let selectedIndexPath = collView?.indexPathsForSelectedItems?.first {
        updateDestinationData(destinationVC: destinationVC, indexPath: selectedIndexPath)
      }
    } // if segue
  }
  
  /// Function updates photo in Detail screen
  func updateDestinationData(destinationVC: ViewController2, indexPath: IndexPath) {
    let rowNumber = (indexPath as IndexPath).row
    let photo = photos[rowNumber]
    destinationVC.photo = photo
  }
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  // MARK: - DataSourec and Delegate Methods
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.isDataLoaded ? 1 : 0
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.photos.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
    let rowNumber = (indexPath as IndexPath).row
    //print("CellForItemAtRow: \(rowNumber)")
    let photo = photos[rowNumber]
    
    if photo.title != "" {
    cell.textLabel.text = photo.title
    } else {
      cell.textLabel.text = "No Title"
    }
  
    return cell
  }
  
  
  
  override public func collectionView (_ collectionView: UICollectionView,
                                       willDisplay cell: UICollectionViewCell,
                                       forItemAt indexPath: IndexPath )  {
    
    
    let rowNumber = (indexPath as IndexPath).row
    //print("Will display: \(rowNumber)")
    let photo = photos[rowNumber]

    self.fetchImageForPhoto(photo: photo)
        { result in
            if case ImageResult.success(let image) = result {
              OperationQueue.main.addOperation() {
                if let cell = self.collView.cellForItem(at: indexPath) as? Cell {
                  cell.updateWithImage(photo.image)
                }
              }
            }
        } // end closure
    
  } //end method
  
  

  
  
  
  
  func fetchImageForPhoto(photo: Item,  completion: @escaping (ImageResult) -> Void)  {
    
    if let index = photos.index(of: photo)  {
    
       print("Fetching Image from Internet for Row: \(index + 1) ")
    
    }
    
    if let image = photo.image  {  // Object already has Image ... no need to fetch from Internet
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
  
  
  
  

}  // end class

