//
//  ProfileHeaderCell.swift
//  Style Fix
//
//  Created by Vidamo on 2/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UICollectionViewCell {
    
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var blurView: UIVisualEffectView!
  
  var stylist: Stylist? {
    didSet {
      if let stylist = stylist {
        imageView.image = stylist.displayPhoto
      }
    }
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    // 1
    let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
    let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
    
    // 2
    let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
    
    // 3
    let minAlpha: CGFloat = 0.3
    let maxAlpha: CGFloat = 0.75
  }
}
