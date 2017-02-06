//
//  TimeCell.swift
//  Style Fix
//
//  Created by Vidamo on 6/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {

  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var secondLine: UIView!
  @IBOutlet var firstLine: UIView!
  
  var touchedLocation: CGPoint!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { print("no touch"); return }
    touchedLocation = touch.location(in: self)
  }

}
