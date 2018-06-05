//
//  SRMRangeSliderView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/15/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//


class SRMRangeSliderView : RangeSliderView {
	
	override init() {
		super.init()
		title = "SRM"
		increment = 5
		numFormat = "%.1f"
		domain = (min:0, max:40)
	}
	
	override func valueUpdated () {
		GKDFilter.sharedInstance.subCategoryFilterSRM = self.range
		
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategoryFilterSRM, object: self, userInfo: ["range": self.range.min, "max": self.range.max])
	}
}
