//
//  String.swift
//  Style Fix
//
//  Created by Vidamo on 12/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import Foundation

extension String {
  
  func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
    let utf16view = self.utf16
    let from = String.UTF16View.Index(range.lowerBound, within: utf16view)
    let to = String.UTF16View.Index(range.upperBound, within: utf16view)
    return NSMakeRange(utf16view.startIndex.distance(to: from), from.distance(to: to))
  }
  
  func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
    let from16 = utf16.startIndex.advanced(by: nsRange.location)
    let to16 = from16.advanced(by: nsRange.length)
    if let from = String.Index(from16, within: self),
      let to = String.Index(to16, within: self) {
      return from ..< to
    }
    return nil
  }
}
