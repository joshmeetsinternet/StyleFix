//
//  StylistsViewController.swift
//  Style Fix
//
//  Created by Vidamo on 1/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class StylistsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
  @IBOutlet var tableView: UITableView!
  @IBOutlet var collectionView: UICollectionView!
  
  var stylists = Stylist.allStylists()
  let imageCache = CacheManager.cacheSharedInstance
  let downloader = ImageDownloader()
  var filteredStylists = [Stylist]()
  let searchController = UISearchController(searchResultsController:  nil)
  var isSearching = false
  
  let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
  
  var locations: [Location] {
    return Location.fetchLocations(managedObjectContext, language: 1)!
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    ;
    
    collectionView.backgroundView = UIView()
    collectionView!.backgroundColor = UIColor.clear
    collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    
    self.searchController.searchResultsUpdater = self
    self.searchController.searchBar.delegate = self
    self.searchController.hidesNavigationBarDuringPresentation = false
    self.searchController.dimsBackgroundDuringPresentation = false
    self.searchController.searchBar.searchBarStyle = .minimal
    self.searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "text_bg_white"), for: .normal)
    self.navigationItem.titleView = searchController.searchBar
    self.definesPresentationContext = true

    
//    searchBar.setSearchFieldBackgroundImage(UIImage(named: "text_bg_white"), for: .normal)
//    searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 10, vertical: 0)
//    searchBar.tintColor = UIColor.flatGrayDark
    
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.flatGray
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    collectionView.alwaysBounceVertical = true
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.backgroundColor = UIColor.black
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: Notification.Name.UIKeyboardDidChangeFrame, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
    NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return stylists.count + 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row == stylists.count {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottom", for: indexPath)
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stylistscell", for: indexPath) as! StylistCell
      cell.stylist = stylists[indexPath.row]
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let layout = collectionView.collectionViewLayout as! UltravisualLayout
    let offset = layout.dragOffset * CGFloat(indexPath.item)
    if collectionView.contentOffset.y != offset {
      collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    } else {
      performSegue(withIdentifier: "segueProfile", sender: indexPath.row)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.row == stylists.count {
      // load more
    }
  }
  
  // MARK: - UIKeyboardNotification
  
  func keyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      guard var keyBoardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
        return
      }
      keyBoardFrame = self.view.convert(keyBoardFrame, from: nil)
      
      if keyBoardFrame.origin.y >= UIScreen.main.bounds.size.height - 64 {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInset
      } else {
        var contentInset:UIEdgeInsets = collectionView.contentInset
        contentInset.bottom = keyBoardFrame.size.height + 60
        tableView.contentInset = contentInset
      }
    }
  }
  
  // MARK: - Actions
  
  func refresh(_ sender: UIRefreshControl) {
    sender.endRefreshing()
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueProfile" {
      let vc = segue.destination as! StylistViewController
      vc.stylist = stylists[sender as! Int]
    }
  }
}

extension StylistsViewController: UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
  
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//      searchBar.resignFirstResponder()
//      searchBar.showsCancelButton = false
//      searchBar.text = nil
//    }
//    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//      searchBar.showsCancelButton = false
//      return true
//    }
//    
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//      searchBar.showsCancelButton = true
//      return true
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//      if filteredStylists.isEmpty {
//        searchBarCancelButtonClicked(self.searchBar)
//      }
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//      print("clicked")
//    }
//  
//  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    
//  }
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    isSearching = true
    return true
  }
  
  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    isSearching = false
    return true
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
    tableView.isHidden = true
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "identifier")
    
    cell?.textLabel?.text = locations[indexPath.row].city_value
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    searchController.searchBar.text = locations[indexPath.row].city_value
    isSearching = false
    tableView.isHidden = true
    searchController.searchBar.resignFirstResponder()
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    if isSearching {
      tableView.isHidden = false
    } else {
      tableView.isHidden = true
    }
  }
}
