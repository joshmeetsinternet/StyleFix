
//
//  UIIMage.swift
//  Style Fix
//
//  Created by Vidamo on 29/11/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

extension UIImage {
    
  var decompressedImage: UIImage? {
      UIGraphicsBeginImageContextWithOptions(size, true, 0)
      draw(at: CGPoint.zero)
      let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return decompressedImage
  }
  
  func blur(withRadius radius: CGFloat) -> UIImage {
    let context = CIContext(options: nil)
    let inputImage = CIImage(cgImage: self.cgImage!)
    let filter = CIFilter(name: "CIGaussianBlur")
    filter?.setValue(inputImage, forKey: kCIInputImageKey)
    filter?.setValue("\(radius)", forKey:kCIInputRadiusKey)
    let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
    let cgImage = context.createCGImage(result, from: inputImage.extent)
    let returnImage = UIImage(cgImage: cgImage!)
    
    return returnImage;
  }
    
}
