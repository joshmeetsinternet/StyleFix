//
//  CollectionCell.swift
//  Style Fix
//
//  Created by Vidamo on 5/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
  
  
  @IBOutlet var photoCollectionView: UICollectionView!
  @IBOutlet var bgView: UIView!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    bgView.layer.cornerRadius = 3
    bgView.layer.masksToBounds = true
  }
  
    
}
