//
//  Stylist.swift
//  Style Fix
//
//  Created by Vidamo on 30/11/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class Stylist {
    
  let name: String
  let gender: String
  let service: String
  let workLocation: String
  let mobile: Int
  var displayPhoto: UIImage?
  var office: Int?
  var intro: String?
  var address: String?
  var tag: String?
  
  
  init(name: String, workLocation: String, gender: String, mobile: Int, service: String, displayPhoto: UIImage?, office: Int?, intro: String?, address: String?, tag: String?) {
      self.name = name
      self.workLocation = workLocation
      self.gender = gender
      self.mobile = mobile
      self.service = service
      self.displayPhoto = displayPhoto
      self.office = office
      self.intro = intro
      self.address = address
      self.tag = tag
  }
  
  class func allStylists() -> [Stylist] {
      var stylists = [Stylist]()
      if let URL = Bundle.main.url(forResource: "Stylists", withExtension: "plist") {
          if let stylistsFromPlist = NSArray(contentsOf: URL) {
              for dictionary in stylistsFromPlist {
                  let stylist = Stylist(dictionary: dictionary as! NSDictionary)
                  stylists.append(stylist)
              }
          }
      }
      return stylists
  }
  
  convenience init(dictionary: NSDictionary) {
      let name = dictionary["name"] as! String
      let workLocation = dictionary["workLocation"] as! String
      let gender = dictionary["gender"] as! String
      let mobile = dictionary["mobile"] as! Int
      let service = dictionary["service"] as! String
      let office = dictionary["office"] as? Int
      let intro = dictionary["intro"] as? String
      let address = dictionary["address"] as? String
      let tag = dictionary["tag"] as? String
      let photo = dictionary["displayPhoto"] as? String
      let displayPhoto = UIImage(named: photo!)?.decompressedImage
      self.init(name: name, workLocation: workLocation, gender: gender, mobile: mobile, service: service, displayPhoto: displayPhoto, office: office, intro: intro, address: address, tag: tag)
  }
  
  func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
    guard let i = intro else {
      return 0
    }
    let rect = NSString(string: i).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    return ceil(rect.height)
  }

}
