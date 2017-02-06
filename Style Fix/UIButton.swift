//
//  UIButton.swift
//  Style Fix
//
//  Created by Vidamo on 5/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import Foundation

extension UIButton{
  
  func centerVertically(withPadding padding: CGFloat) {
    guard let imageSize = self.imageView?.frame.size else {
      return
    }
    
    guard let titleSize = self.titleLabel?.frame.size else {
      return
    }
    
    let totalHeight = (imageSize.height + titleSize.height + padding);
    self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height),
                                        left: 0.0, bottom: 0.0, right: -titleSize.width)
    
    self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                        left: -imageSize.width,
                                        bottom: -(totalHeight - titleSize.height),
                                        right: 0.0)
  }
  
  func centerVertically() {
    let kDefaultPadding: CGFloat = 6
    
    centerVertically(withPadding: kDefaultPadding)
  }
}
