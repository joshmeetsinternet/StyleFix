//
//  CalendarContentViewController.swift
//  Style Fix
//
//  Created by Vidamo on 6/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

protocol CalendarContentDelegate {
  func transition(withTouch touch: CGPoint, date: Date)
}

class CalendarContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var pageIndex: Int!
  var date: Date!
  var delegate: CalendarContentDelegate!
  var pastIndexPath: IndexPath!
  var currentDate: Date!
  var scrollIndex: IndexPath!
  
  var bookings: Booking!
  
  @IBOutlet var tableView: UITableView!
  
  var times = [Date]()
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    
    let calendar = Calendar(identifier: .gregorian)
    
    currentDate = calendar.date(bySettingHour: Date().hour, minute: 0, second: 0, of: Date())
    
    var tomorrowOffset = DateComponents()
    tomorrowOffset.day = 1
    guard let tomorrow = calendar.date(byAdding: tomorrowOffset, to: date) else { return }
    guard let tomorrowDate = calendar.date(bySettingHour: 1, minute: 0, second: 0, of: tomorrow) else { return }
    guard let hours = tomorrowDate.hoursFrom(date: date) else { return }
    
    for item in 0..<hours {
      guard let nextHour = calendar.date(byAdding: .hour, value: item, to: date) else { continue }
      if item == 0 && nextHour.minutes > 30 {
        continue
      }
      if nextHour.hour == currentDate.hour {
        scrollIndex = IndexPath(row: item, section: 0)
      }
      times.append(nextHour)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if scrollIndex != nil {
      tableView.scrollToRow(at: scrollIndex, at: .middle, animated: false)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableView
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return times.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "identifier") as! TimeCell
    
    cell.timeLabel.text = times[indexPath.row].prettyHour
    cell.firstLine.backgroundColor = UIColor.lightGray
    cell.secondLine.backgroundColor = UIColor.clear
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! TimeCell
    
    if cell.touchedLocation.y > 22 {
      cell.secondLine.backgroundColor = UIColor.flatRedDark
    } else if times[indexPath.row] > Date() {
      cell.firstLine.backgroundColor = UIColor.flatRedDark
    } else {
      cell.secondLine.backgroundColor = UIColor.flatRedDark
    }
    delegate.transition(withTouch: cell.touchedLocation, date: times[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
  }
  
  @IBAction func didLongPress(_ sender: UILongPressGestureRecognizer) {
    let point = sender.location(in: tableView)
    print(point)
    guard let indexPath = tableView.indexPathForRow(at: point) else {
      if pastIndexPath != nil, let cell = tableView.cellForRow(at: pastIndexPath) as? TimeCell {
        cell.firstLine.backgroundColor = UIColor.lightGray
        cell.secondLine.backgroundColor = UIColor.clear
      }
      
      return
    }
    guard let cell = tableView.cellForRow(at: indexPath) as? TimeCell else  {
      
      if pastIndexPath != nil, let cell = tableView.cellForRow(at: pastIndexPath) as? TimeCell {
        cell.firstLine.backgroundColor = UIColor.lightGray
        cell.secondLine.backgroundColor = UIColor.clear
      }
      
      if point.y > 0 {
        if point.y < tableView.contentOffset.y {
          tableView.setContentOffset(CGPoint(x: 0, y: point.y), animated: true)
        } else if point.y < tableView.contentSize.height  {
          tableView.setContentOffset(CGPoint(x: 0, y: point.y), animated: true)
        }
      }
      
    return
    }
    
    if pastIndexPath != nil {
      if indexPath.row > pastIndexPath.row, let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: 0)) as? TimeCell {
        cell.secondLine.backgroundColor = UIColor.clear
        cell.firstLine.backgroundColor = UIColor.lightGray
      } else if indexPath.row < pastIndexPath.row, let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: 0)) as? TimeCell {
        cell.secondLine.backgroundColor = UIColor.clear
        cell.firstLine.backgroundColor = UIColor.lightGray
      }
    }
    
    let pointInCell = sender.location(in: cell)
    pastIndexPath = indexPath
    switch sender.state {
    case .began:
      if pointInCell.y > 22 {
        cell.secondLine.backgroundColor = UIColor.flatRedDark
        cell.firstLine.backgroundColor = UIColor.lightGray
      } else if times[indexPath.row] > Date() {
        cell.firstLine.backgroundColor = UIColor.flatRedDark
        cell.secondLine.backgroundColor = UIColor.clear
      } else {
        cell.secondLine.backgroundColor = UIColor.flatRedDark
        cell.firstLine.backgroundColor = UIColor.lightGray
      }
    case .changed:
      if pointInCell.y > 22 {
        cell.secondLine.backgroundColor = UIColor.flatRedDark
        cell.firstLine.backgroundColor = UIColor.lightGray
      } else if times[indexPath.row] > Date() {
        cell.firstLine.backgroundColor = UIColor.flatRedDark
        cell.secondLine.backgroundColor = UIColor.clear
      }
    case .ended:
      cell.touchedLocation = pointInCell
      self.tableView(tableView, didSelectRowAt: indexPath)
    case .cancelled:
      cell.firstLine.backgroundColor = UIColor.lightGray
      cell.secondLine.backgroundColor = UIColor.clear
    default:
      cell.firstLine.backgroundColor = UIColor.lightGray
      cell.secondLine.backgroundColor = UIColor.clear
    }
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
