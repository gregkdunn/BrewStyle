//
//  UIColor+readableText.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/26/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

import UIKit

extension UIColor {

	func isLight() -> Bool
	{
		let components = CGColorGetComponents(self.CGColor)
		var brightness = (components[0] * 299)
			brightness += (components[1] * 587)
			brightness += (components[2] * 114)
			brightness = brightness / 1000
		
		if brightness < 0.5
		{
			return false
		}
		else
		{
			return true
		}
	}

	func readableTextColor() -> UIColor {
		if (self.isLight()) {
			return AppColor.Black.color
		}
		return AppColor.White.color
	}
}
