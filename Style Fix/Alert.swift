//
//  Alert.swift
//  Style Fix
//
//  Created by Vidamo on 8/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import Foundation

enum Alert: Int {
  case none
  case now
  case fiveMins
  case tenMins
  case thirtyMins
  case hour
  case day
  
  var description : String {
    switch  self {
    case .none: return "None"
    case .now: return "At the time of booking"
    case .fiveMins: return "5 minutes before booking"
    case .tenMins: return "10 minutes before booking"
    case .thirtyMins: return "30 minutes before booking"
    case .hour: return "1 hour before booking"
    case .day: return "1 day before booking"
    }
  }
  
  static let allObjects = [none,
                           now,
                           fiveMins,
                           tenMins,
                           thirtyMins,
                           hour,
                           day]
  
  static let allString = [none.description,
                          now.description,
                          fiveMins.description,
                          tenMins.description,
                          thirtyMins.description,
                          hour.description,
                          day.description]
}
