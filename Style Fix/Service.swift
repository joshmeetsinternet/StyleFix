//
//  Service.swift
//  Style Fix
//
//  Created by Vidamo on 8/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import Foundation

enum Service: Int {
  case haircut
  case color
  case treatment
  case perm
  
  var description : String {
    switch  self {
    case .haircut: return "Haircut"
    case .color: return "Color"
    case .treatment: return "Treatment"
    case .perm: return "Perm"
    }
  }
  
  static let allObjects = [haircut,
                           color,
                           treatment,
                           perm]
  
  static let allStrings = [haircut.description,
                           color.description,
                           treatment.description,
                           perm.description]

}
