//
//  BookingsCell.swift
//  Style Fix
//
//  Created by Vidamo on 8/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class BookingsCell: UITableViewCell {
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var serviceLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var indicatorView: UIView!
  @IBOutlet var displayImage: UIImageView!
  @IBOutlet var blurView: UIVisualEffectView!
  @IBOutlet var notesLabel: UILabel!
  @IBOutlet var alertLabel: UILabel!
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
