//
//  ABVGKDRangeSliderView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/16/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class ABVGKDRangeSliderView : GKDRangeSliderView {
	
	override init() {
		super.init()
		title = "ABV"
		increment = 2
		numFormat = "%.1f"
		domain = (min:0, max:14)
		
	}
	
	override func valueUpdated () {
		GKDFilter.sharedInstance.subCategoryFilterABV = self.range
		
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategoryFilterABV, object: self, userInfo: ["range": self.range.min, "max": self.range.max])
	}
}
