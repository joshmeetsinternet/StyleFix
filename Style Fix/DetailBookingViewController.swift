//
//  DetailBookingViewController.swift
//  Style Fix
//
//  Created by Vidamo on 9/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class DetailBookingViewController: UIViewController {
  
  var booking: Booking!

  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var btnReschedule: UIButton!
  @IBOutlet var btnCancel: UIButton!
  var shouldHide = false
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var serviceLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var alertLabel: UILabel!
  @IBOutlet var notesLabel: UILabel!
  
  override func viewDidLoad() {
      super.viewDidLoad()

    nameLabel.text = booking.stylist
    
    var ss = [String]()
    for b in booking.services.components(separatedBy: ",") {
      ss.append(Service(rawValue: Int(b)!)!.description)
    }

    serviceLabel.text = ss.joined(separator: " · ")
    dateLabel.text = booking.bookingDate
    alertLabel.text = Alert(rawValue: booking.alert)?.description
    notesLabel.text = booking.notes
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isTranslucent = false
    if shouldHide {
      btnCancel.isHidden = true
      btnReschedule.isHidden = true
      scrollView.isUserInteractionEnabled = false
    } else {
      btnCancel.isHidden = false
      btnReschedule.isHidden = false
      scrollView.isUserInteractionEnabled = true
    }
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Actions
  
  @IBAction func didPressCancel(_ sender: Any) {
    
  }
  
  @IBAction func btnReschedule(_ sender: Any) {
    performSegue(withIdentifier: "segueReschedule", sender: self)
  }
  
  override var previewActionItems: [UIPreviewActionItem] {
    let action1 = UIPreviewAction(title: "Reschedule",
                                  style: .default,
                                  handler: { previewAction, viewController in
                                    
    })
    
    let action2 = UIPreviewAction(title: "Cancel Booking",
                                  style: .destructive,
                                  handler: { previewAction, viewController in
                                    
    })
    
    return [action1, action2]
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? CalendarViewController {
    }
  }

}
