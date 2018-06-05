//
//  IBURangeView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/30/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class IBURangeView : RangeView {
	
	override init() {
		super.init()
		title = "IBU"
		increment = 10
		numFormat = "%.0f"
		domain = (min:0, max:100)
		
	}
}
