//
//  SRMRangeView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/30/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class SRMRangeView : RangeView {
	
	override init() {
		super.init()
		title = "SRM"
		increment = 5
		numFormat = "%.1f"
		domain = (min:0, max:40)

	}
}
