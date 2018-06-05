//
//  ABVRangeView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/30/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class ABVRangeView : RangeView {
	
	override init() {
		super.init()
		title = "ABV"
		increment = 2
		numFormat = "%.1f"
		domain = (min:0, max:14)
		
	}
}
