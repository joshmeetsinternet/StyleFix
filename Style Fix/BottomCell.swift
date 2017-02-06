//
//  BottomCell.swift
//  Style Fix
//
//  Created by Vidamo on 2/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class BottomCell: UICollectionViewCell {
    
  @IBOutlet var imageCoverView: UIView!
  @IBOutlet var imageFix: UIImageView!
  @IBOutlet var imageStyle: UIImageView!
  
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
    imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
//    imageStyle.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
//    imageFix.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
  }

}
