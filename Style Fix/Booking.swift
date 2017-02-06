//
//  Booking.swift
//  Style Fix
//
//  Created by Vidamo on 8/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import Foundation

class Booking {
  
  let stylist: String
  let createdDate: String
  let bookingDate: String
  let services: String
  let alert: Int
  var notes: String?
  var isRescheduled: Bool
  var status: Int
  
  init(stylist: String, createdDate: String, bookingDate: String, services: String, alert: Int, notes: String?, isRescheduled: Bool, status: Int) {
    self.stylist = stylist
    self.createdDate = createdDate
    self.bookingDate = bookingDate
    self.services = services
    self.alert = alert
    self.notes = notes
    self.isRescheduled = isRescheduled
    self.status = status
  }
  
  class func allBookings() -> [Booking] {
    var bookings = [Booking]()
    if let URL = Bundle.main.url(forResource: "Bookings", withExtension: "plist") {
      if let stylistsFromPlist = NSArray(contentsOf: URL) {
        for dictionary in stylistsFromPlist {
          let booking = Booking(dictionary: dictionary as! NSDictionary)
          bookings.append(booking)
        }
      }
    }
    return bookings
  }
  
  convenience init(dictionary: NSDictionary) {
    let stylist = dictionary["stylist"] as! String
    let createdDate = dictionary["createdDate"] as! String
    let bookingDate = dictionary["bookingDate"] as! String
    let services = dictionary["services"] as! String
    let alert = dictionary["alert"] as! Int
    let notes = dictionary["notes"] as? String
    let isRescheduled = dictionary["isRescheduled"] as! Bool
    let status = dictionary["status"] as! Int
    self.init(stylist: stylist, createdDate: createdDate, bookingDate: bookingDate, services: services, alert: alert, notes: notes, isRescheduled: isRescheduled, status: status)
  }
}
