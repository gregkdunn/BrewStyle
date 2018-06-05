//
//  GradientView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 12/8/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//



class GradientView: UIView {
	var gradientLayer:CAGradientLayer = CAGradientLayer()
	var top: (position:CGFloat, color:UIColor) = (0.0, AppColor.White.color)
	var bottom: (position:CGFloat, color:UIColor) = (1.0, AppColor.Black.color)
	
	convenience init() {
		self.init(frame: CGRectZero)
	}
	
	override init (frame : CGRect) {
		super.init(frame : frame)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		self.init()
	}
	
	
	override class func layerClass() -> AnyClass {
		return CAGradientLayer.self
	}
	
	func gradientWithColors(topStop :(position:CGFloat, color:UIColor), bottomStop: (position:CGFloat, color:UIColor)) {
		self.top = topStop
		self.bottom = bottomStop
		
		let deviceScale = UIScreen.mainScreen().scale
		gradientLayer.frame = CGRectMake(bottom.position, bottom.position, self.frame.size.width * deviceScale, self.frame.size.height * deviceScale)
		gradientLayer.colors = [ top.color.CGColor, bottom.color.CGColor ]
		
		self.layer.insertSublayer(gradientLayer, atIndex: 0)
	}
	
	override func layoutSubviews() {
		gradientLayer.frame = self.bounds
	}
	
}