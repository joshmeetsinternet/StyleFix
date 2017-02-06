//
//  StylistViewController.swift
//  Style Fix
//
//  Created by Vidamo on 2/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class StylistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  @IBOutlet var collectionView: UICollectionView!
  
  let downloader = ImageDownloader()
  let imageCache = CacheManager.cacheSharedInstance
  
  var videos = ["CR4pXwu8xho","O58M20aM4lE","NAaW6GSVaCE"]
  
  //*****
  let firstCount = 10
  
  //*****
  let secondCount = 20
  
  //*****
  let thirdCount = 3
  
  var stylist: Stylist!
  
  var SCREENSIZE: CGSize {
    return UIScreen.main.bounds.size
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.backgroundView = UIView()
    collectionView!.backgroundColor = UIColor.clear
    collectionView.tag = 0
    
    let layout = collectionView.collectionViewLayout as? StylistLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
    layout!.sectionHeadersPinToVisibleBounds = true
    layout!.delegate = self
    layout!.firstSize = CGSize(width: SCREENSIZE.width, height: SCREENSIZE.width / 5)
    layout!.secondSize = CGSize(width: SCREENSIZE.width, height: SCREENSIZE.width / 6)
    layout!.thirdSize = CGSize(width: SCREENSIZE.width, height: SCREENSIZE.width / 3)
    
    collectionView.alwaysBounceVertical = true
    
    collectionView.register(CollectionViewHeader.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    
    navigationItem.title = stylist.name
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
    navigationItem.title = nil
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.backgroundColor = UIColor.clear
  }
  
  override func viewDidLayoutSubviews() {
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationItem.title = stylist.name
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - UICollectionView
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    switch kind {
    case UICollectionElementKindSectionHeader:
      switch indexPath.section {
      case 1:
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath) as! CollectionViewHeader
        
        
        headerView.imageView.image = UIImage(named:"profile")
        headerView.titleLabel.text = "Profile"
        headerView.accessoryButton.addTarget(self, action: #selector(self.didPressMorePhotos(_:)), for: .touchUpInside)
        headerView.accessoryButton.tag = indexPath.section
      
        return headerView
      case 2:
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath) as! CollectionViewHeader
        
        
        headerView.imageView.image = UIImage(named:"ig")
        headerView.titleLabel.text = "Instagram"
        headerView.accessoryButton.addTarget(self, action: #selector(self.didPressMorePhotos(_:)), for: .touchUpInside)
        headerView.accessoryButton.tag = indexPath.section
        
        return headerView
      case 3:
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath) as! CollectionViewHeader
        
        
        headerView.imageView.image = UIImage(named:"youtube")
        headerView.titleLabel.text = "Youtube"
        headerView.accessoryButton.addTarget(self, action: #selector(self.didPressMorePhotos(_:)), for: .touchUpInside)
        headerView.accessoryButton.tag = indexPath.section
        
        return headerView
      default:
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "ProfileHeader",
                                                                         for: indexPath) as! StylistHeaderView
        headerView.stylist = stylist

        return headerView
      }
    default:
      //4
      assert(false, "Unexpected element kind")
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if collectionView.tag == 0 {
      return 4
    }
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView.tag == 1 {
      return min(6, firstCount)
    } else if collectionView.tag == 2 {
      return min(6, secondCount)
    } else if collectionView.tag == 3 {
      return min(6, thirdCount)
    } else {
      if section == 0 {
        return 3
      } else {
        return 1
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.tag == 0 {
      
      switch indexPath.section {
      case 1, 2, 3:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! CollectionCell
        
        cell.photoCollectionView.delegate = self
        cell.photoCollectionView.dataSource = self
        cell.photoCollectionView.tag = indexPath.section
        cell.photoCollectionView.backgroundView = UIView()
        cell.photoCollectionView.backgroundColor = UIColor.clear
        
        return cell
      default:
        switch indexPath.row {
        case 1:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intro", for: indexPath) as! StylistIntroCell
          
          cell.introLabel.text = stylist.intro
          
          return cell
        case 2:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "info", for: indexPath) as! InfoCell
        
          return cell
        default:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stylistaction", for: indexPath) as! StylistActionCell
          
          cell.btnFavorite.addTarget(self, action: #selector(self.didPressFavorite(_:)), for: .touchUpInside)
          cell.btnBook.addTarget(self, action: #selector(self.didPressBook(_:)), for: .touchUpInside)
          cell.btnMore.addTarget(self, action: #selector(self.didPressMore(_:)), for: .touchUpInside)
          
          return cell
        }
      }
    } else if collectionView.tag == 3 {
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
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ImageCell
      
      cell.imageView.backgroundColor = UIColor.flatGray
      cell.imageView.image = Stylist.allStylists()[indexPath.row].displayPhoto
      
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
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if let layout = collectionViewLayout as? StylistLayout {
      return layout.itemSize
    } else {
      let num = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
      return CGSize(width: collectionView.frame.width / num, height: collectionView.frame.width / num)
    }
  }
  
  // MARK: - Actions
  
  func didPressFavorite(_ sender: UIButton) {
    let point = sender.convert(sender.center, to: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
    guard let cell = collectionView.cellForItem(at: indexPath) as? StylistActionCell else { return }

    cell.btnFavorite.tintColor = UIColor.flatRedDark
  }
  
  func didPressBook(_ sender: UIButton) {
    let point = sender.convert(sender.center, to: collectionView)
    guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
    guard let cell = collectionView.cellForItem(at: indexPath) as? StylistActionCell else { return }
    
    performSegue(withIdentifier: "segueCalendar", sender: self)
  }
  
  func didPressMore(_ sender: UIButton) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Go to Facebook", style: .default, handler: { (action) in
      
    }))
    alert.addAction(UIAlertAction(title: "Go to Instagram", style: .default, handler: { (action) in
      
    }))
    alert.addAction(UIAlertAction(title: "Report Stylist", style: .destructive, handler: { (action) in
      
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
      
    }))
    present(alert, animated: true, completion: nil)
  }
  
  func didPressMorePhotos(_ sender: Any) {
    guard let tag = (sender as AnyObject).tag else { return }
    

    performSegue(withIdentifier: "seguePhotos", sender: tag)
  }
  
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueCalendar" {
      let vc = segue.destination as! CalendarViewController
      vc.stylist = stylist
    } else if segue.identifier == "seguePhotos" {
      let vc = segue.destination as! ImagesViewController
      vc.isVideos = (sender as! Int) == 3 ? true : false
    }
  }
}

extension StylistViewController: StylistLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
    if indexPath.row == 1 {
      let annotationPadding = CGFloat(8)
      let font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
      let commentHeight = stylist.heightForComment(font: font, width: collectionView.contentSize.width)
      let height = annotationPadding + commentHeight + annotationPadding
      return height
    } else if indexPath.row == 2 {
      let annotationPadding = CGFloat(8)
      let font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
      let commentHeight = stylist.heightForComment(font: font, width: collectionView.contentSize.width)
      let height = annotationPadding + commentHeight + annotationPadding
      return height
    } else {
      return 0
    }
  }
}
