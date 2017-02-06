//
//  CacheManager.swift
//  bnb_thirstforltd
//
//  Created by Vidamo on 14/4/16.
//  Copyright © 2016 Vidamo. All rights reserved.
//

import Foundation
import AlamofireImage

class CacheManager {
    static let cacheSharedInstance = AutoPurgingImageCache()
}