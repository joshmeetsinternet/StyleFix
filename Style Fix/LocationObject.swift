//
//  LocationObject.swift
//  Anak
//
//  Created by Vidamo on 24/5/2016.
//  Copyright © 2016 Vidamo. All rights reserved.
//

import UIKit

class LocationObject: NSObject {
    
    let countryId: String?
    let provinceId: String?
    let district: String?
    let cityId: String?
    let langId: String?
    let countryValue: String?
    let provinceValue: String?
    let districtValue: String?
    let cityValue: String?

    init(countryId: String?, provinceId: String?, district: String?, cityId: String?, langId: String?, countryValue: String?, provinceValue: String?, districtValue: String?, cityValue: String?) {
        self.countryId = countryId
        self.provinceId = provinceId
        self.district = district
        self.cityId = cityId
        self.langId = langId
        self.countryValue = countryValue
        self.provinceValue = provinceValue
        self.districtValue = districtValue
        self.cityValue = cityValue
    }
}
