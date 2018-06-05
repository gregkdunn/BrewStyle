//
//  GravityRangeView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/19/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class GravityRangeView : RangeView {
	var ogRange : (min:Double, max:Double) = (min:0, max:0.5)
	var fgRange : (min:Double, max:Double) = (min:0.5, max: 1)
	
	private var ogRangeIndicator = UIView()
	private var fgRangeIndicator = UIView()
	
	override init() {
		super.init()
		title = "FG / OG"
		increment = 0.030
		numFormat = "%.3f"
		domain = (min:0.995, max:1.18)
		
	}
	
	
	func convertG(value: Double) -> Double {
		var newValue: Double = 0
		if (domainTotal != 0)
		{
			newValue = (value  / domainTotal)
		}
		return (newValue > 0 ) ? newValue : 0.001
	}
	
	override func clearRange() {
		super.clearRange()
		ogRangeIndicator.removeFromSuperview()
		fgRangeIndicator.removeFromSuperview()
	}
	
	override func createRange() {
		clearRange()
		
		if(fgRange.min == fgRange.max && ogRange.min == ogRange.max) {
			return
		}
		
		ogRangeIndicator.translatesAutoresizingMaskIntoConstraints = false
		ogRangeIndicator.backgroundColor = rangeColor
		self.addSubview(ogRangeIndicator)
		ogRangeIndicator.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 18).active = true
		ogRangeIndicator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -6).active = true
		let ogRangeIndicatorLeftConstraint : NSLayoutConstraint? = NSLayoutConstraint(item: ogRangeIndicator, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: CGFloat(convert(ogRange.min)), constant: -1)
		if let tConst = ogRangeIndicatorLeftConstraint {
			tConst.active = true
		}
		let ogWidth = CGFloat(convertG(ogRange.max - ogRange.min))
		let ogRangeIndicatorWidthConstraint : NSLayoutConstraint? = NSLayoutConstraint(item: ogRangeIndicator, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: ogWidth, constant: 1)
		if let tConst = ogRangeIndicatorWidthConstraint {
			tConst.active = true
		}

		fgRangeIndicator.translatesAutoresizingMaskIntoConstraints = false
		fgRangeIndicator.backgroundColor = AppStyle.Range[.SecondaryRangeColor]
		self.addSubview(fgRangeIndicator)
		fgRangeIndicator.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 18).active = true
		fgRangeIndicator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -6).active = true
		let fgRangeIndicatorLeftConstraint : NSLayoutConstraint? = NSLayoutConstraint(item: fgRangeIndicator, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: CGFloat(convert(fgRange.min)), constant: -1)
		if let tConst = fgRangeIndicatorLeftConstraint {
			tConst.active = true
		}
		let fgWidth = CGFloat(convertG(fgRange.max - fgRange.min))
		let fgRangeIndicatorWidthConstraint : NSLayoutConstraint? = NSLayoutConstraint(item: fgRangeIndicator, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: fgWidth, constant: 1)
		if let tConst = fgRangeIndicatorWidthConstraint {
			tConst.active = true
		}
		
		valueLabel.text = "\(formattedStringFrom(fgRange.min)) - \(formattedStringFrom(fgRange.max)) / \(formattedStringFrom(ogRange.min)) - \(formattedStringFrom(ogRange.max))"
		
	}
}
