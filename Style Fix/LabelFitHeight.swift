//
//  LabelFitHeight.swift
//  Style Fix
//
//  Created by Vidamo on 2/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class LabelFitHeight: UILabel {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    font = fontToFitHeight()
  }
  
  // Returns an UIFont that fits the new label's height.
  private func fontToFitHeight() -> UIFont {
    
    var minFontSize: CGFloat = 18 // CGFloat 18
    var maxFontSize: CGFloat = 38     // CGFloat 67
    var fontSizeAverage: CGFloat = 0
    var textAndLabelHeightDiff: CGFloat = 0
    
    while (minFontSize <= maxFontSize) {
      
      fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
      
      // Abort if text happens to be nil
      guard text != nil else {
        break
      }
      
      if let labelText: NSString = text as NSString? {
        let labelHeight = frame.size.height
        
        let testStringHeight = labelText.size(
          attributes: [NSFontAttributeName: font.withSize(fontSizeAverage)]
          ).height
        
        textAndLabelHeightDiff = labelHeight - testStringHeight
        
        if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
          if (textAndLabelHeightDiff < 0) {
            return font.withSize(fontSizeAverage - 1)
          }
          return font.withSize(fontSizeAverage)
        }
        
        if (textAndLabelHeightDiff < 0) {
          maxFontSize = fontSizeAverage - 1
          
        } else if (textAndLabelHeightDiff > 0) {
          minFontSize = fontSizeAverage + 1
          
        } else {
          return font.withSize(fontSizeAverage)
        }
      }
    }
    return font.withSize(fontSizeAverage)
  }
}

