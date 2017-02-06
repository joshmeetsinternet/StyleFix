//
//  Utils.swift
//  V2F
//
//  Created by Vidamo on 26/10/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage

//*****************************************************************
// MARK: - Helper Functions
//*****************************************************************

public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

public func showAlert(inController controller: UIViewController, title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    controller.present(alert, animated: true, completion: nil)
}

public func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd yyyy HH:mm"
    let dateString = dateFormatter.string(from: date)
    return dateString
}

public func downloadImage(_ downloader: ImageDownloader, cache: AutoPurgingImageCache, urlString: String?, identifier: String, completion: @escaping (_ image: UIImage?) -> Void)  {
    
    if let u = urlString {
        guard let url = URL(string: u) else {  completion(nil); return }
        let urlRequest = URLRequest(url: url)
        guard let c = cache.image(withIdentifier: identifier) else {
            downloader.download(urlRequest) { (response) in
                if let image = response.result.value {
                    cache.add(image, withIdentifier: identifier)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
            return
        }
        completion(c)
    } else {
    }
}

public func getLocations(context: NSManagedObjectContext){
  var locationArray: [LocationObject]?
  
  if let locations = Location.fetchLocations(context, language: 1), locations.count > 0 {
    return
  }
  print(#function)
  do {
    locationArray = []
    if let path = Bundle.main.path(forResource: "location2016", ofType:".csv") {
      let content = try String(contentsOfFile: path)
      let array = content.components(separatedBy: NSCharacterSet.newlines)
      for line in array {
        let elements = line.components(separatedBy: ",")
        if elements.count == 9 {
          let record = LocationObject(countryId: elements[0], provinceId: elements[1], district: elements[2], cityId: elements[3], langId: elements[4], countryValue: elements[5], provinceValue: elements[6], districtValue: elements[7], cityValue: elements[8])
          locationArray?.append(record)
        }
      }
      Location.insert(locations: locationArray!, context: context)
    }
  } catch {
    print(#function)
  }
}
