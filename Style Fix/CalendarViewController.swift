//
//  CalendarViewController.swift
//  Style Fix
//
//  Created by Vidamo on 6/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var dateLabel: UILabel!
  
  let numberOfDays = 60
  var days = [Date]()
  var selectedDate: Date! = Date()
  
  var pageViewController: UIPageViewController!
  var stylist: Stylist!
  var booking: Booking?
  
  private var SCREENSIZE: CGRect {
    return UIScreen.main.bounds
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.backgroundView = UIView()
    collectionView.backgroundColor = UIColor.clear

    let startDate = Date()
    let calendar = Calendar.current
    var offset = DateComponents()
    
    days.append(startDate)
    
    for item in 1..<numberOfDays {
      offset.day = item
      guard let nd = calendar.date(byAdding: offset, to: startDate) else { continue }
      guard let nextDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nd) else { return }
      days.append(nextDay)
    }
    
    selectedDate = startDate
    dateLabel.text = selectedDate.dateString

    // page view init
    
    pageViewController = storyboard?.instantiateViewController(withIdentifier: "Page ViewController") as! UIPageViewController
    pageViewController.dataSource = self
    pageViewController.delegate = self
    
    let startingVC = viewControllerAt(index: 0)
    let viewcontrollers = [startingVC!] as [UIViewController]
    pageViewController.setViewControllers(viewcontrollers, direction: .forward, animated: true, completion: nil)
    
    pageViewController.view.frame = CGRect(x: 0, y: dateLabel.frame.maxY, width: SCREENSIZE.width, height: SCREENSIZE.height - dateLabel.frame.maxY)
    
    addChildViewController(pageViewController)
    view.insertSubview(pageViewController.view, at: 0)
    pageViewController.didMove(toParentViewController: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.backgroundColor = UIColor.clear
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  // MARK: UICollectionView
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return days.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day", for: indexPath) as! DayCell
    
    cell.dayLabel.text = String(days[indexPath.row].day)
  
    if selectedDate == days[indexPath.row] {
      cell.dayLabel.backgroundColor = UIColor.flatWhite
      cell.dayLabel.textColor = UIColor.flatBlack
    } else {
      cell.dayLabel.backgroundColor = UIColor.clear
      cell.dayLabel.textColor = UIColor.flatWhite
    }
    dateLabel.text = selectedDate.dateString
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let previouslySelected: Date = selectedDate
    selectedDate = days[indexPath.row]
    if selectedDate != previouslySelected {
      collectionView.reloadData()
      
      dateLabel.text = selectedDate.dateString
      
      guard let vc = viewControllerAt(index: indexPath.row) else { return }
      
      
      if selectedDate > previouslySelected {
        pageViewController.setViewControllers([vc],
                                            direction: .forward, animated: true, completion: nil)
      } else {
        pageViewController.setViewControllers([vc],
                                              direction: .reverse, animated: true, completion: nil)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sizeFromView = (collectionView.bounds.width) / 7

    return CGSize(width: sizeFromView, height: 25)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let today = Date().weekDay
    
    let sizeFromView = (collectionView.bounds.width) / 7
    
    let inset = sizeFromView * CGFloat(today - 1)
    
    return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
  }
//
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  // MARK: UIPageViewController
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! CalendarContentViewController).pageIndex as Int
    
    if index == 0  || index == NSNotFound {
      return nil
    }
    
    index -= 1

    return viewControllerAt(index: index)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! CalendarContentViewController).pageIndex as Int
    
    if index == NSNotFound {
      return nil
    }
    
    index += 1
    
    if index == days.count {
      return nil
    }
    return viewControllerAt(index: index)

  }
  
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
    if completed, let contentView = pageViewController.viewControllers?[0] as? CalendarContentViewController {
      let oldDate: Date =  selectedDate
      selectedDate = days[contentView.pageIndex]
      
      print(collectionView.indexPathsForVisibleItems.count)
      
      let indexPath = IndexPath(item: contentView.pageIndex, section: 0)
      
      if !collectionView.indexPathsForVisibleItems.contains(indexPath) && selectedDate > oldDate {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
      } else if !collectionView.indexPathsForVisibleItems.contains(indexPath) && selectedDate < oldDate{
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
      }
      collectionView.reloadData()
    }
  }
  
  func viewControllerAt(index: Int) -> CalendarContentViewController? {
    if days.count == 0 {
      return nil
    }
    
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Calendar Content") as! CalendarContentViewController
    vc.pageIndex = index
    vc.date = days[index]
    vc.delegate = self
    
    return vc
  }

  // MARK: Actions
  
  @IBAction func didPressAdd(_ sender: Any) {
    performSegue(withIdentifier: "segueBooking", sender: self)
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueBooking" {
      let vc = segue.destination as! BookingTableViewController
      vc.stylist = stylist
      if let d = sender as? Date {
        vc.date = d
      } else {
        vc.date = Date()
      }
    }
  }
}

extension CalendarViewController: CalendarContentDelegate {
  func transition(withTouch touch: CGPoint, date: Date) {
    
    let touchPercent = touch.y / 44
    let minutes = 60 * touchPercent
    
    let calendar = Calendar(identifier: .gregorian)
    
    if minutes > 30 {
      guard let d = calendar.date(bySettingHour: date.hour, minute: 30, second: 0, of: date) else { return }
      performSegue(withIdentifier: "segueBooking", sender: d)
    } else {
      guard let d = calendar.date(bySettingHour: date.hour, minute: 0, second: 0, of: date) else { return }
      if d < Date() {
        guard let d2 = calendar.date(bySettingHour: date.hour, minute: 30, second: 0, of: date) else { return }
        performSegue(withIdentifier: "segueBooking", sender: d2)
      } else {
        performSegue(withIdentifier: "segueBooking", sender: d)
      }
    }
  }
}
