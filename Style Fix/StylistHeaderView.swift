//
//  StylistHeaderView.swift
//  Style Fix
//
//  Created by Vidamo on 2/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class StylistHeaderView: UICollectionReusableView {
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: LabelFitHeight!
  @IBOutlet var blurView: UIVisualEffectView!
  
  var stylist: Stylist? {
    didSet {
      if let stylist = stylist {
        imageView.image = stylist.displayPhoto
        titleLabel.text = stylist.name
      }
    }
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
  
    let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
    let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
    
    let delta = abs((featuredHeight - frame.height) / (featuredHeight - standardHeight))
//    if stylist != nil {
//      imageView.image = stylist?.displayPhoto?.blur(withRadius: delta)
//    }
    blurView.alpha = delta
  }
}
