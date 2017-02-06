//
//  UIColor+Palette.swift
//  Ultravisual
//
//  Created by Mic Pringle on 20/03/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

extension UIColor {
  
  class func colorFrom(R: Int, G: Int, B: Int) -> UIColor {
    return UIColor(red: CGFloat(Float(R) / 255), green: CGFloat(Float(G) / 255), blue: CGFloat(Float(B) / 255), alpha: 1)
  }
  
  class func palette() -> [UIColor] {
    let palette = [
      UIColor.colorFrom(R: 85, G: 0, B: 255),
      UIColor.colorFrom(R: 170, G: 0, B: 170),
      UIColor.colorFrom(R: 85, G: 170, B: 85),
      UIColor.colorFrom(R: 0, G: 85, B: 0),
      UIColor.colorFrom(R: 255, G: 170, B: 0),
      UIColor.colorFrom(R: 255, G: 255, B: 0),
      UIColor.colorFrom(R: 255, G: 85, B: 0),
      UIColor.colorFrom(R: 0, G: 85, B: 85),
      UIColor.colorFrom(R: 0, G: 85, B: 255),
      UIColor.colorFrom(R: 170, G: 170, B: 255),
      UIColor.colorFrom(R: 85, G: 0, B: 0),
      UIColor.colorFrom(R: 170, G: 85, B: 85),
      UIColor.colorFrom(R: 170, G: 255, B: 0),
      UIColor.colorFrom(R: 85, G: 170, B: 255),
      UIColor.colorFrom(R: 0, G: 170, B: 170)
    ]
    return palette
  }
  
}
