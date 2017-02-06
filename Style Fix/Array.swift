//
//  Array.swift
//  bnb_thirstforltd
//
//  Created by Vidamo on 7/4/16.
//  Copyright © 2016 Vidamo. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  
  // Remove first collection element that is equal to the given `object`:
  mutating func remove(object: Element) {
    if let index = index(of: object) {
      remove(at: index)
    }
  }
}
