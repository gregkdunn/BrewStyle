//
//  TriangleView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/4/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class TriangleView: UIView {
	
	var color = UIColor.whiteColor() {
		didSet {
			setNeedsDisplay()
		}
	}

	convenience init(color: UIColor) {
		self.init(frame: CGRectZero)
		self.color = color
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	override func drawRect(rect: CGRect) {
		super.drawRect(rect)
		
		self.backgroundColor = UIColor.clearColor()
		// Get Height and Width
		let layerHeight = self.layer.frame.height
		let layerWidth = self.layer.frame.width
		
		// Create Path
		let line = UIBezierPath()
		
		// Draw Points
		line.moveToPoint(CGPointMake(layerWidth, layerHeight))
		line.addLineToPoint(CGPointMake(layerWidth, 0))
		line.addLineToPoint(CGPointMake(0, 0))
		line.addLineToPoint(CGPointMake(layerWidth, layerHeight))
		line.closePath()
		
		// Apply Color
		color.setStroke()
		color.setFill()
		line.lineWidth = 1.0
		line.fill()
		line.stroke()
		
		// Mask to Path
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = line.CGPath
		self.layer.mask = shapeLayer
	}
}