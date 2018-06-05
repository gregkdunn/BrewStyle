//
//  RangeSliderView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/14/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class RangeSliderTrackLayer: CALayer {
	weak var rangeSlider: RangeSliderView?
	
	override func drawInContext(ctx: CGContext) {
		if let slider = rangeSlider {
			// Clip
			let path = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
			CGContextAddPath(ctx, path.CGPath)
			
			// Fill the track
			CGContextSetFillColorWithColor(ctx, slider.trackTintColor.CGColor)
			CGContextAddPath(ctx, path.CGPath)
			CGContextFillPath(ctx)
			
			// Fill the highlighted range
			CGContextSetFillColorWithColor(ctx, slider.trackHighlightTintColor.CGColor)
			let rangePosition :(min:CGFloat, max:CGFloat) = (min: CGFloat(slider.positionForValue(slider.range.min)), max: CGFloat(slider.positionForValue(slider.range.max)))
			let rect = CGRect(x: rangePosition.min, y: 0.0, width: rangePosition.max - rangePosition.min, height: bounds.height)
			CGContextFillRect(ctx, rect)
		}
	}
}

class RangeSliderThumbLayer: CALayer {
	
	var highlighted: Bool = false {
		didSet {
			setNeedsDisplay()
		}
	}
	weak var rangeSlider: RangeSliderView?
	
	override func drawInContext(ctx: CGContext) {
		if let slider = rangeSlider {
			let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
			let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: 0)
			
			// Fill - with a subtle shadow
			CGContextSetFillColorWithColor(ctx, slider.thumbTintColor.CGColor)
			CGContextAddPath(ctx, thumbPath.CGPath)
			CGContextFillPath(ctx)

			if highlighted {
				CGContextSetFillColorWithColor(ctx, slider.thumbTintColor.colorWithAlphaComponent(0.0).CGColor)
				CGContextAddPath(ctx, thumbPath.CGPath)
				CGContextFillPath(ctx)
			}
		}
	}
}

class RangeSliderView : UIControl {
	var enable = true {
		willSet (newValue){
			if newValue {
				enableSlider()
			} else {
				disableSlider()
			}
		}
	}
	
	var domain: (min:Double, max:Double) = (min: 0, max: 1) {
		didSet {
			calculateRangeProperties()
			createRangeView()
			range = (min:domain.min, max:domain.max)
		}
	}
	var range: (min:Double, max:Double) = (min: 0, max: 1) {
		didSet {
			clearRange()
			createRange()
		}
	}
	var rangePosition:(min:CGFloat, max:CGFloat) = (min: 0, max: 1)
	
	var increment : Double = 0.1
	var numFormat = "%.0f"
	var title = ""
	var defaultValueText = "varies"
	var domainColor = AppStyle.Range[.DomainColor]
	var rangeColor = AppStyle.Range[.PrimaryRangeColor]
	
	var domainTotal = 1.0
	
	let titleLabel = UILabel()
	let valueLabel = UILabel()
	
	///
	
	private let rangeFinder = UIView()
	private let minIndicator = RangeSliderThumbLayer()
	private let maxIndicator = RangeSliderThumbLayer()
	private var rangeIndicator = RangeSliderTrackLayer()
 
	var previousLocation = CGPoint()
	
	var trackTintColor: UIColor = AppStyle.Range[.DomainColor]! {
		didSet {
			rangeIndicator.setNeedsDisplay()
		}
	}
	
	var trackHighlightTintColor: UIColor = AppStyle.Range[.PrimaryRangeColor]! {
		didSet {
			rangeIndicator.setNeedsDisplay()
		}
	}
	
	var thumbTintColor: UIColor = AppColor.LightGray.alpha(0.0) {
		didSet {
			minIndicator.setNeedsDisplay()
			maxIndicator.setNeedsDisplay()
		}
	}
	
	var thumbWidth: CGFloat {
		return CGFloat(44)
	}
	
	override var frame: CGRect {
		didSet {
			updateLayerFrames()
		}
	}
	
	var hasRange = false
	var adjusting : RangeSliderThumbLayer? {
		willSet (newValue) {
			if let indicator = newValue {
				highlightIndicator(indicator)
			}
		}
	}
	var beginningPoint : CGPoint = CGPointZero
	
	
	init() {
		super.init(frame: CGRectZero)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		self.init()
	}
	
	private func calculateRangeProperties() {
		domainTotal = domain.max - domain.min
	}
	
	func convertToPercentage(value: Double) -> Double {
		var newValue: Double = 0
		if (domainTotal != 0)
		{
			newValue = ((value - domain.min)  / domainTotal)
		}
		return (newValue > 0 ) ? newValue : 0.001
	}
	
	func convertToValue(constantValue: CGFloat) -> Double {
		let width  = Double(rangeFinder.frame.width)
		let percent = Double(constantValue)/width
		
		return (domainTotal * percent)
		
	}
	
	func positionForValue(value: Double) -> Double {
		return Double(bounds.width) * convertToPercentage(value)
	}
	
	func formattedStringFrom(num: Double) -> String {
		return String(format:numFormat, num)
	}
	
	func clearRangeView() {
		self.subviews.forEach({ $0.removeFromSuperview() })
	}
	
	func disableSlider() {
		self.alpha = 0.25
		clearRange()
		resetRange()
		valueLabel.text = "n/a"
	}
	
	func enableSlider() {
		self.alpha = 1.0
		valueLabel.text = "\(formattedStringFrom(range.min)) - \(formattedStringFrom(range.max))"
	}
	
	private func createRangeView() {
		clearRangeView()
		
		rangeFinder.backgroundColor = domainColor
		
		rangeFinder.translatesAutoresizingMaskIntoConstraints = false
		rangeFinder.userInteractionEnabled = false
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
		titleLabel.userInteractionEnabled = false
		titleLabel.font = AppFonts.val.font
		titleLabel.textColor = AppStyle.Range[.TitleColor]
		titleLabel.text = title
		self.addSubview(titleLabel)
		titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 0).active = true
		
		valueLabel.translatesAutoresizingMaskIntoConstraints = false
		valueLabel.userInteractionEnabled = false
		valueLabel.font = AppFonts.val.font
		valueLabel.textColor = AppStyle.Range[.ValueColor]
		self.addSubview(valueLabel)
		valueLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		valueLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		
		createRange()
	}
	
	private func createTickAt(val:Double) {
		calculateRangeProperties()
		let convertedVal = convertToPercentage(val)
		
		let tick = UIView()
		tick.translatesAutoresizingMaskIntoConstraints = false
		tick.userInteractionEnabled = false
		tick.backgroundColor = AppStyle.Range[.TickColor]
		self.addSubview(tick)
		tick.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 20).active = true
		tick.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: 0).active = true
		tick.widthAnchor.constraintEqualToConstant(1).active = true
		let leftConstraint : NSLayoutConstraint?
		if convertedVal > 0 {
			leftConstraint = NSLayoutConstraint(item: tick, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: CGFloat(convertToPercentage(val)), constant: 1)
		} else {
			leftConstraint = NSLayoutConstraint(item: tick, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
		}
		if let lConst = leftConstraint {
			lConst.active = true
		}
		
		if(true) {
			let num = UILabel()
			num.translatesAutoresizingMaskIntoConstraints = false
			num.userInteractionEnabled = false
			num.font = AppFonts.tick.font
			num.textColor =  AppStyle.Range[.TickValueColor]
			num.text = "\(formattedStringFrom(val))"
			self.addSubview(num)
			num.topAnchor.constraintEqualToAnchor(tick.bottomAnchor, constant: 2.0).active = true
			num.centerXAnchor.constraintEqualToAnchor(tick.centerXAnchor, constant: 0).active = true
		}
	}
	
	func clearRange() {
		valueLabel.text = defaultValueText
		rangeIndicator.removeFromSuperlayer()
		minIndicator.removeFromSuperlayer()
		maxIndicator.removeFromSuperlayer()
	}
	
	func createRange() {
		clearRange()
	
		if(range.min == range.max) {
			return
		}
		
		rangeIndicator.rangeSlider = self
		rangeIndicator.contentsScale = UIScreen.mainScreen().scale
		layer.addSublayer(rangeIndicator)
		
		minIndicator.rangeSlider = self
		minIndicator.contentsScale = UIScreen.mainScreen().scale
		layer.addSublayer(minIndicator)
		
		maxIndicator.rangeSlider = self
		maxIndicator.contentsScale = UIScreen.mainScreen().scale
		layer.addSublayer(maxIndicator)
		
		updateLayerFrames()
		
		valueLabel.text = "\(formattedStringFrom(range.min)) - \(formattedStringFrom(range.max))"
		resetIndicators()
		
		hasRange = true
	}
	
	
	func updateLayerFrames() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		rangeIndicator.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
		rangeIndicator.setNeedsDisplay()
		
		let lowerThumbCenter = CGFloat(positionForValue(range.min))
		
		minIndicator.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
			width: thumbWidth, height: thumbWidth)
		minIndicator.setNeedsDisplay()
		
		let upperThumbCenter = CGFloat(positionForValue(range.max))
		maxIndicator.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
			width: thumbWidth, height: thumbWidth)
		maxIndicator.setNeedsDisplay()
		
		CATransaction.commit()
	}
 
	// Slide
	func adjustRangeTo(point : CGPoint) {
		let delta = (point.x - beginningPoint.x)
		
		if (adjusting == minIndicator) {
			let newConstant = constrainAdjustment(rangePosition.min + delta, isMin: true)
			rangePosition.min = newConstant
			
			//print("new min : \(delta) : \(newConstant)")
			range.min = convertToValue(newConstant) + domain.min
			
		} else if (adjusting == maxIndicator) {
			let newConstant =  constrainAdjustment(rangePosition.max + delta, isMin: false)
			rangePosition.max = newConstant
				
			//print("new max : \(delta) / \(newConstant)")
			range.max = domain.max + convertToValue(newConstant)
		} else {
			return
		}
		
		valueLabel.text = "\(formattedStringFrom(range.min)) - \(formattedStringFrom(range.max))"
	}
	
	func constrainAdjustment(value : CGFloat, isMin:Bool) -> CGFloat {
		var newValue = value
		
		if isMin {
			if range.max <= (convertToValue(newValue) + domain.min) {
				newValue = constrainAdjustment(value - 20, isMin: true)
			}
			
			newValue = (newValue > 0) ? newValue : 0
		} else {
			if range.min >= (domain.max + convertToValue(newValue)) {
				newValue = constrainAdjustment(value + 20, isMin: false)
			}
			
			newValue = (newValue < 0) ? newValue : 0
		}
		
		return newValue
	}
	
	override func intrinsicContentSize() -> CGSize {
		return CGSizeMake(320, 44)
	}
	
	// Touch
	
	override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {	
		if(!hasRange || !enable) {
			return false
		}
		
		beginningPoint = touch.locationInView(self)
		
		print("beginning touch: \(beginningPoint)")
		
		if minIndicator.frame.contains(beginningPoint) {
			print("Min Adjust")
			adjusting = minIndicator
			return true
		} else if maxIndicator.frame.contains(beginningPoint) {
			print("Max Adjust")
			adjusting = maxIndicator
			return true
		} else {
			let prct = convertToValue(beginningPoint.x) / domainTotal
			print("touched \(beginningPoint.x) is \(prct) of \(domainTotal)")
			if prct < 0.50 {
				print("Min Adjust")
				adjusting = minIndicator
				return true
			} else {
				print("Max Adjust")
				adjusting = maxIndicator
				return true
			}
 		}
	}
	
	override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
		let lastPoint = touch.locationInView(self)
		
		adjustRangeTo(lastPoint)

		sendActionsForControlEvents(.ValueChanged)
		
		beginningPoint = lastPoint
		
		return true
	}
	
	override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
		valueUpdated()
		resetIndicators()
	}
	
	func highlightIndicator(indicator : RangeSliderThumbLayer) {
		minIndicator.highlighted = true
	}
	
	func resetIndicators () {
		minIndicator.highlighted = false
		maxIndicator.highlighted = false
	}
	
	func resetRange () {
		range.min = domain.min
		range.max = domain.max
		valueUpdated()
	}
	
	func valueUpdated () {
		//Override to send appropriate notifications
	}
}