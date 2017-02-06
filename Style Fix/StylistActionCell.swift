//
//  StylistActionCell.swift
//  Style Fix
//
//  Created by Vidamo on 5/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import Foundation

class StylistActionCell: UICollectionViewCell {
  
  
  @IBOutlet var btnFavorite: UIButton!
  @IBOutlet var btnBook: UIButton!
  @IBOutlet var btnMore: UIButton!
  
  override func layoutSubviews() {
    btnFavorite.centerVertically()
    btnBook.centerVertically()
    btnMore.centerVertically()
  }
}
