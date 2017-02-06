//
//  StylistLayout.swift
//  Style Fix
//
//  Created by Vidamo on 2/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

protocol StylistLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}


class StylistLayout: UICollectionViewFlowLayout {
  
  var firstSize: CGSize = CGSize.zero
  var secondSize: CGSize = CGSize.zero
  var thirdSize: CGSize = CGSize.zero
  
  var delegate: StylistLayoutDelegate!
  
  let dragOffset: CGFloat = 280
  
  var cache = [UICollectionViewLayoutAttributes]()
  
  var width: CGFloat {
    get {
      return collectionView!.bounds.width
    }
  }
  
  private var contentHeight: CGFloat  = 0.0

  var cheight: CGFloat {
    get {
      return collectionView!.bounds.height
    }
  }
  
  var numberOfSections: Int {
    get {
      return collectionView!.numberOfSections
    }
  }

  override var collectionViewContentSize: CGSize {
      return CGSize(width: width, height: contentHeight)
  }
  
  override func prepare() {
    cache.removeAll(keepingCapacity: false)
    
    let standardHeight: CGFloat = 64.0
    let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
    
    var frame = CGRect(x: 0, y: 0, width: width, height: featuredHeight)
    
    var y: CGFloat = 0

    for section in 0..<numberOfSections {
      let indexPath = IndexPath(item: 0, section: section)
      
      let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
      
      attributes.zIndex = numberOfSections - section
      var height = featuredHeight
      
      var fwidth = width
      var x: CGFloat = 0
      
      switch section {
      case 1, 2, 3:
        
        y = max(y, frame.maxY)
        
        frame = CGRect(x: x, y:  y, width: fwidth, height: 44)

      default:
        if collectionView!.contentOffset.y > 0 && height > standardHeight {
          height = featuredHeight - collectionView!.contentOffset.y
          if height <= standardHeight {
            height = standardHeight
          }
        } else if collectionView!.contentOffset.y < 0 && height == featuredHeight {
          height = featuredHeight + abs(collectionView!.contentOffset.y)
          fwidth = collectionView!.bounds.width + abs(collectionView!.contentOffset.y)
          x -= abs(collectionView!.contentOffset.y) / 2
        }
        
        frame = CGRect(x: x, y: collectionView!.contentOffset.y, width: fwidth, height: height)
      }

      attributes.frame = frame
      cache.append(attributes)
      
      var fframe = frame
      let numberOfItems = collectionView!.numberOfItems(inSection: section)
      for item in 0..<numberOfItems {
        
        let indexPath = IndexPath(item: item, section: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        attributes.zIndex = 0

        y = fframe.maxY
        print(section, numberOfItems)
        switch indexPath.section {
        case 1, 2, 3:
          let size: CGSize
          if indexPath.section == 1 {
            size = firstSize
          } else if indexPath.section == 2 {
            size = secondSize
          } else {
            size = thirdSize
          }
          fframe = CGRect(origin: CGPoint(x: 0, y: y), size: size)
//          fframe = CGRect(x: 0, y: y, width: width, height: (width / CGFloat(6)) + 16)
        default:
          if indexPath.row == 1 {
            let annotationHeight = delegate.collectionView(collectionView!,
                                                           heightForAnnotationAtIndexPath: indexPath, withWidth: width)
            fframe = CGRect(x: 0, y: y, width: width, height: annotationHeight)
          } else if indexPath.row == 2 {
            let annotationHeight = delegate.collectionView(collectionView!,
                                                           heightForAnnotationAtIndexPath: indexPath, withWidth: (width/2) - 20)
            fframe = CGRect(x: 0, y: y, width: width, height: annotationHeight)
          } else {
            y = y < featuredHeight ? fframe.maxY : featuredHeight
            fframe = CGRect(x: 0, y: y, width: width, height: standardHeight)
          }
        }
        
        attributes.frame = fframe
        cache.append(attributes)
        y = fframe.maxY
        contentHeight = fframe.maxY
      }
    }
  }
    
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }

  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
    let itemIndex = round(proposedContentOffset.y / dragOffset)
    let yOffset = itemIndex * dragOffset
    return CGPoint(x: 0, y: yOffset)
  }
}
