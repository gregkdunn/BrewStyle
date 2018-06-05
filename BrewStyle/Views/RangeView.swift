//
//  RangeView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/29/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class RangeView : UIView {
	var domain: (min:Double, max:Double) = (min: 0, max: 1) {
		didSet {
			calculateRangeProperties()
			createRangeView()
			range = (min:domain.min, max:domain.max)
		}
	}
	var range: (min:Double, max:Double) = (min: 0, max: 1) {
		didSet {
			createRange()
		}
	}
	var increment : Double = 0.1 
	var numFormat = "%.0f"
	var title = ""
	var defaultValueText = "varies"
	var domainColor = AppStyle.Range[.DomainColor]
	var rangeColor = AppStyle.Range[.PrimaryRangeColor]
	
	var domainTotal = 1.0
	
	let titleLabel = UILabel()
	let valueLabel = UILabel()
	private let rangeFinder = UIView()
	private let minIndicator = UIView()
	private let maxIndicator = UIView()
	private var rangeIndicator = UIView()
	
	init() {
		super.init(frame: CGRectZero)
	}

	required convenience init?(coder aDecoder: NSCoder) {
	    self.init()
	}
	
	private func calculateRangeProperties() {
		domainTotal = domain.max - domain.min
	}
	
	func convert(value: Double) -> Double {
		var newValue: Double = 0
		if (domainTotal != 0)
		{
			newValue = ((value - domain.min)  / domainTotal)
		}
		return (newValue > 0 ) ? newValue : 0.001
	}
	
	func formattedStringFrom(num: Double) -> String {
	  return String(format:numFormat, num)
	}
	
	func clearRangeView() {
		self.subviews.forEach({ $0.removeFromSuperview() })
	}
	
	func disable() {
		self.alpha = 0.25
		clearRange()
		valueLabel.text = "n/a"
	}
	
	func enable() {
		self.alpha = 1.0
		valueLabel.text = defaultValueText
	}
	
	private func createRangeView() {
		clearRangeView()
	
		rangeFinder.backgroundColor = domainColor
		
		rangeFinder.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(rangeFinder)
		rangeFinder.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 20).active = true
		rangeFinder.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -8).active = true
		rangeFinder.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		rangeFinder.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		
		var i : Double = domain.max
		repeat {
			createTickAt(i)
			i -= increment
		} while i >= domain.min

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = AppFonts.val.font
		titleLabel.textColor = AppStyle.Range[.TitleColor]
		titleLabel.text = title
		self.addSubview(titleLabel)
		titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		valueLabel.translatesAutoresizingMaskIntoConstraints = false
		valueLabel.font = AppFonts.val.font
		valueLabel.textColor = AppStyle.Range[.ValueColor]
		self.addSubview(valueLabel)
		valueLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		valueLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
	}
	
	private func createTickAt(val:Double) {
		calculateRangeProperties()
		let convertedVal = convert(val)
		
		let tick = UIView()
		tick.translatesAutoresizingMaskIntoConstraints = false
		tick.backgroundColor = AppStyle.Range[.TickColor]
		self.addSubview(tick)
		tick.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 20).active = true
		tick.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		tick.widthAnchor.constraintEqualToConstant(1).active = true
		let leftConstraint : NSLayoutConstraint?
		if convertedVal > 0 {
			leftConstraint = NSLayoutConstraint(item: tick, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: CGFloat(convert(val)), constant: 1)
		} else {
			leftConstraint = NSLayoutConstraint(item: tick, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
		}
		if let lConst = leftConstraint {
			lConst.active = true
		}
		
		if(true) {
			let num = UILabel()
			num.translatesAutoresizingMaskIntoConstraints = false
			num.font = AppFonts.tick.font
			num.textColor =  AppStyle.Range[.TickValueColor]
			num.text = "\(formattedStringFrom(val))"
			self.addSubview(num)
			num.topAnchor.constraintEqualToAnchor(tick.bottomAnchor, constant: 2.0).active = true
			num.centerXAnchor.constraintEqualToAnchor(tick.centerXAnchor, constant: 0).active = true
		}
	}
	
	func clearRange() {
		rangeIndicator.removeFromSuperview()
		valueLabel.text = defaultValueText
	}
	
	func createRange() {
		clearRange()
		
		if(range.min == range.max) {
			return
		}
		
		rangeIndicator.translatesAutoresizingMaskIntoConstraints = false
		rangeIndicator.backgroundColor = rangeColor
		self.addSubview(rangeIndicator)
		rangeIndicator.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 18).active = true
		rangeIndicator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -6).active = true
		let rangeIndicatorLeftConstraint : NSLayoutConstraint? = NSLayoutConstraint(item: rangeIndicator, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: CGFloat(convert(range.min)), constant: -1)
		if let tConst = rangeIndicatorLeftConstraint {
			tConst.active = true
		}
		let rangeIndicatorWidthConstraint : NSLayoutConstraint? = NSLayoutConstraint(item: rangeIndicator, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: CGFloat(convert(range.max - range.min)), constant: 1)
		if let tConst = rangeIndicatorWidthConstraint {
			tConst.active = true
		}

		valueLabel.text = "\(formattedStringFrom(range.min)) - \(formattedStringFrom(range.max))"
		
	}
	
	override func intrinsicContentSize() -> CGSize {
		return CGSizeMake(320, 50)
	}
}