//
//  ProfileViewController.swift
//  Style Fix
//
//  Created by Vidamo on 23/11/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet var collectionView: UICollectionView!
  
  var stylists = Stylist.allStylists()
  var isVideos = false
  var videos = ["CR4pXwu8xho","O58M20aM4lE","NAaW6GSVaCE"]
  
  private var SCREENSIZE: CGRect {
      return UIScreen.main.bounds
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      stylists.append(contentsOf: Stylist.allStylists())
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.backgroundColor = UIColor.black

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  // MARK: - UICollectionView
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if isVideos {
      return 3
    }
    return stylists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if isVideos {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "webview", for: indexPath) as! WebViewCell
      cell.layoutIfNeeded()
      
      let htmlEmbed = "<iframe width=\"\(cell.webView.frame.height)\" height=\"\(cell.webView.frame.height)\" src=\"https://www.youtube-nocookie.com/embed/\(videos[indexPath.row])?rel=0&amp;controls=0&amp;showinfo=0\" frameborder=\"0\" allowfullscreen></iframe>"
      //      let urlRequest = URLRequest(url: URL(string: htmlEmbed)!)
      cell.webView.loadHTMLString(htmlEmbed, baseURL: nil)
      
      if indexPath.row == 5 {
        if collectionView.numberOfItems(inSection: indexPath.section) > 6 {
          cell.numberLabel.alpha = 0.5
          cell.numberLabel.text = "\(collectionView.numberOfItems(inSection: indexPath.section) - 5)"
        } else {
          cell.numberLabel.alpha = 0
          cell.numberLabel.text = nil
        }
      } else {
        cell.numberLabel.alpha = 0
        cell.numberLabel.text = nil
      }
      
      return cell
    } else {
      if (indexPath.row % 2) == 0 {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "stylistIdentifier", for: indexPath) as! StylistsCell
        
        let stylist = stylists[indexPath.row]
        
        cell.displayImage.image = stylist.displayPhoto
        
        return cell
      } else {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "stylistIdentifier2", for: indexPath) as! StylistsCell
        
        let stylist = stylists[indexPath.row]
        
        cell.displayImage.image = stylist.displayPhoto
        
        return cell
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if isVideos {
      return CGSize(width: 355, height: 355)
    }
    return CGSize(width: 160, height: 160)
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
