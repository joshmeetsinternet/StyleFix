//
//  PhotosCell.swift
//  Style Fix
//
//  Created by Vidamo on 2/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    
  @IBOutlet var imageViewLayoutConstraint: NSLayoutConstraint!
  @IBOutlet var headerLabel: UILabel!
  @IBOutlet var imageView: UIImageView!

  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    if let attributes = layoutAttributes as? PinterestLayoutAttributes {
      imageViewLayoutConstraint.constant = attributes.photoHeight
    }
  }
}
