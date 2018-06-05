//
//  CircleView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 9/8/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class CircleView : UIView{
	var color = AppColor.Gray.color
	
	init() {
		super.init(frame: CGRectZero)
	}
	
	convenience init(color:UIColor) {
		self.init()
		self.color = color
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
override func drawRect(rect: CGRect) {
		super.drawRect(rect)
	
		self.backgroundColor = UIColor.clearColor()
		if let context: CGContextRef = UIGraphicsGetCurrentContext() {
			CGContextSetFillColorWithColor(context, color.CGColor);
			CGContextSetAlpha(context, 0.2);
			CGContextFillEllipseInRect(context, CGRectMake(30,30,self.frame.size.width-60,self.frame.size.height-60));
			
			CGContextSetStrokeColorWithColor(context, color.CGColor);
			CGContextSetLineWidth(context, 10);
			CGContextStrokeEllipseInRect(context, CGRectMake(5,5,self.frame.size.width-10,self.frame.size.height-10));
		}
	}
	
}