//
//  BookingsViewController.swift
//  Style Fix
//
//  Created by Vidamo on 8/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {

  @IBOutlet var tableView: UITableView!
  
  var bookings = Booking.allBookings()
  
  var selected: IndexPath!
  
  let screenWidth = UIScreen.main.bounds.size.width
  let screenHeight = UIScreen.main.bounds.size.height
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundView = nil
    tableView.backgroundColor = UIColor.clear
    selected = IndexPath(row: 0, section: 0)
    
    tableView.estimatedRowHeight = 88
    
    if traitCollection.forceTouchCapability == .available {
      
      registerForPreviewing(with: self, sourceView: tableView)
    } else {
      let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.didPressLong(_:)))
      tableView.addGestureRecognizer(longPressGesture)
    }
    
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.flatGray
    refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - UITableView
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bookings.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "identifier") as! BookingsCell
    
    print(selected)
    
//    cell.booking = bookings[indexPath.row]
    
    cell.nameLabel.text = bookings[indexPath.row].stylist
    cell.dateLabel.text = bookings[indexPath.row].bookingDate
    
    var ss = [String]()
    for b in bookings[indexPath.row].services.components(separatedBy: ",") {
      ss.append(Service(rawValue: Int(b)!)!.description)
    }
    cell.serviceLabel.text = ss.joined(separator: " · ")
    
    if selected == indexPath {
      cell.alertLabel.text = Alert(rawValue: bookings[indexPath.row].alert)?.description
      cell.notesLabel.text = bookings[indexPath.row].notes
      cell.blurView.alpha = 0.33
    } else {
      cell.alertLabel.text = nil
      cell.notesLabel.text = nil
      cell.blurView.alpha = 1
    }
    
    if bookings[indexPath.row].isRescheduled {
      cell.indicatorView.backgroundColor = UIColor.flatRedDark
    } else {
      cell.indicatorView.backgroundColor = UIColor.flatForestGreenDark
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let oldIndex: IndexPath = selected
    selected = indexPath
    tableView.beginUpdates()
    tableView.reloadRows(at: [oldIndex, selected], with: .fade)
    tableView.endUpdates()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

      return UITableViewAutomaticDimension
  }
  
  // MARK: UIViewControllerPreviewing
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    guard let indexPath = tableView.indexPathForRow(at: location),
      let cell = tableView.cellForRow(at: indexPath) else {
        return nil }
    
    let oldIndex: IndexPath = selected
    selected = indexPath
    tableView.beginUpdates()
    tableView.reloadRows(at: [oldIndex, selected], with: .fade)
    tableView.endUpdates()
    
    guard let detailViewController =
      storyboard?.instantiateViewController(
        withIdentifier: "Detail Booking") as?
      DetailBookingViewController else { return nil }
    
    detailViewController.booking = bookings[indexPath.row]
    detailViewController.preferredContentSize =
      CGSize(width: 0.0, height: 500)
    
    previewingContext.sourceRect = cell.frame
    detailViewController.shouldHide = true
    return detailViewController
  }
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    guard let vc = viewControllerToCommit as? DetailBookingViewController else { return }
    vc.hidesBottomBarWhenPushed = true
    vc.shouldHide = false
    vc.booking = bookings[selected.row]
    show(vc, sender: self)
  }
  
  func didPressLong(_ sender: UILongPressGestureRecognizer) {
    
    
    let location = sender.location(in: tableView)
    guard let indexPath = tableView.indexPathForRow(at: location),
      let _ = tableView.cellForRow(at: indexPath) else { return }
    
    if sender.state == .began {
      let oldIndex: IndexPath = selected
      selected = indexPath
      tableView.beginUpdates()
      tableView.reloadRows(at: [oldIndex, selected], with: .fade)
      tableView.endUpdates()
    }
    
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "Detail Booking") as? DetailBookingViewController else { return }
    
    controller.shouldHide = true
    controller.booking = bookings[indexPath.row]
    
    let frame = CGRect(x: 15, y: 120, width: screenWidth - 30, height: screenWidth + 60)
    
    let options = [
      PeekViewAction(title: "View Booking", style: .default),
      PeekViewAction(title: "Reschedule", style: .default),
      PeekViewAction(title: "Cancel Booking", style: .destructive)]
    PeekView().viewForController(
      parentViewController: self,
      contentViewController: controller,
      expectedContentViewFrame: frame,
      fromGesture: sender,
      shouldHideStatusBar: true,
      withOptions: options,
      completionHandler: { optionIndex in
        switch optionIndex {
        case 0:
          self.performSegue(withIdentifier: "segueDetailBooking", sender: indexPath)
        case 1:
          self.performSegue(withIdentifier: "segueReschedule", sender: indexPath)
        case 2:
          showAlert(inController: self, title: "You are about to cancel your booking!", message: "Are you sure you want to continue?")
        default:
          break
        }
    })
  }
  
  func refresh(_ sender: UIRefreshControl) {
    sender.endRefreshing()
  }
  
  
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? DetailBookingViewController {
      vc.shouldHide = false
      vc.booking = bookings[(sender as! IndexPath).row]
      vc.hidesBottomBarWhenPushed = true
    } else if let vc = segue.destination as? CalendarViewController {
    }
  }
}
