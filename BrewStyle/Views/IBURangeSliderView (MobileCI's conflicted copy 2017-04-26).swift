//
//  IBURangeSliderView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/16/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class IBURangeSliderView : RangeSliderView {
	
	override init() {
		super.init()
		title = "IBU"
		increment = 10
		numFormat = "%.0f"
		domain = (min:0, max:100)
	}
	
	override func valueUpdated () {
		GKDFilter.sharedInstance.subCategoryFilterIBU = self.range
		
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SubCategoryFilterIBU, object: self, userInfo: ["range": self.range.min, "max": self.range.max])
	}
}
