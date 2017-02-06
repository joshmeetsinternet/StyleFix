//
//  DayCell.swift
//  Style Fix
//
//  Created by Vidamo on 6/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
  @IBOutlet var dayLabel: UILabel!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    dayLabel.layer.cornerRadius = dayLabel.frame.width / 2
    dayLabel.layer.masksToBounds = true
  }
}
