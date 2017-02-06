//
//  TutorialCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 27/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class StylistCell: UICollectionViewCell {
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageCoverView: UIView!
  @IBOutlet var locationLabel: UILabel!
  @IBOutlet var serviceLabel: UILabel!
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  var stylist: Stylist? {
    didSet {
      if let stylist = stylist {
        imageView.image = stylist.displayPhoto
        titleLabel.text = stylist.name
        locationLabel.text = stylist.workLocation
        serviceLabel.text = stylist.service
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
    imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
    serviceLabel.alpha = delta
    locationLabel.alpha = delta
  }

}
