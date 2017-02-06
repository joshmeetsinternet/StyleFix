//
//  BookingTableViewController.swift
//  Style Fix
//
//  Created by Vidamo on 7/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit
import UserNotifications

class BookingTableViewController: UITableViewController, UITextViewDelegate {
  
  let MAX_LENGTH = 160
  
  @IBOutlet var didPressAdd: UIBarButtonItem!
  @IBOutlet var stylistLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var datePicker: UIDatePicker!
  @IBOutlet var serviceLabel: UILabel!
  @IBOutlet var alertLabel: UILabel!
  @IBOutlet var notesTextView: UITextView!
  
  var editingDate = false
  
  var stylist: Stylist!
  var date: Date!
  var selections: [String]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundView = UIView()
    tableView.backgroundColor = UIColor.lightGray.flatten()
    
    stylistLabel.text = stylist.name
    dateLabel.text = date.dateTimeString
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.backgroundColor = UIColor.black
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    
  }
  
  // MARK: UIScrollView
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.view.endEditing(true)
  }

  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 && indexPath.row == 0 {
      if !editingDate {
        editingDate = true
        dateLabel.textColor = UIColor.flatRedDark
      } else {
        editingDate = false
        dateLabel.textColor = UIColor.flatBlack
      }
      tableView.beginUpdates()
      tableView.endUpdates()
    } else if indexPath.section == 1 && indexPath.row == 2 {
      selections = Service.allStrings
      performSegue(withIdentifier: "segueSelection", sender: indexPath)
    } else if indexPath.section == 1 && indexPath.row == 3 {
      selections = Alert.allString
      performSegue(withIdentifier: "segueSelection", sender: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 1 {
      if !editingDate {
        return 0
      }
      return 216
    } else if indexPath.section == 2 {
      return 250
    } else {
      return UITableViewAutomaticDimension
    }
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.section != 2 {
      cell.backgroundColor = UIColor.white
      cell.clipsToBounds = true
    }
  }
  
  // MARK: UITextView
  
  func textViewDidChange(_ textView: UITextView) {

  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let newLength = (textView.text.characters.count - range.length) + text.characters.count
    if(newLength <= MAX_LENGTH)
    {
      return true
    } else {
      let emptySpace = MAX_LENGTH - (textView.text.characters.count - range.length)
      let index = text.index(text.startIndex, offsetBy: emptySpace)
      textView.text = textView.text.appending(text.substring(to: index))
      return false
    }
  }
  
  // MARK: Actions
  
  @IBAction func didChangeDate(_ sender: Any) {
    date = (sender as! UIDatePicker).date
    dateLabel.text = date.dateTimeString
  }
  
  @IBAction func didPressAdd(_ sender: Any) {
    
    let notification: UILocalNotification = UILocalNotification()
    notification.alertTitle = "You have a booking with \(stylistLabel.text!)"
    notification.alertBody = serviceLabel.text! + " at " + date.prettyHourWithMinute
    notification.fireDate = date
    UIApplication.shared.scheduleLocalNotification(notification)
    
    _ = navigationController?.popToRootViewController(animated: true)
    tabBarController?.selectedIndex = 1
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueSelection" {
      let vc = segue.destination as! SelectionTableViewController
      vc.delegate = self
      vc.indexPath = sender as! IndexPath
      vc.selections = selections

      if (sender as! IndexPath).row == 2 {
        vc.selected = serviceLabel.text!.components(separatedBy: " · ")
        vc.allowMultipleSelection = true
      } else {
        vc.selected = [alertLabel.text!]
      }
    }
  }
}

extension BookingTableViewController: SelectionDelegate {
  func didSelect(values: [String], fromIndexPath: IndexPath) {
    if fromIndexPath.row == 2 {
      serviceLabel.text = values.joined(separator: " · ")
    } else if fromIndexPath.row == 3 {
      alertLabel.text = values.joined(separator: "")
    }
  }
}
