//
//  BackgroundView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 11/6/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class BackgroundView : UIView {
	let gradientLayer = CAGradientLayer()
	let typeIndicator = TriangleView(color:AppColor.Beige.alpha(0.95))
	
	convenience init() {
		self.init(frame:CGRectZero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit () {
		self.backgroundColor = AppStyle.CollectionView[.BackgroundColor]
			
		let topColor = AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(1.0).CGColor as CGColorRef
		let bottomColor = AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(0.0).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.0, 1.0]
		self.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		typeIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(typeIndicator)
		typeIndicator.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
		typeIndicator.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 0).active = true
		typeIndicator.heightAnchor.constraintEqualToConstant(270).active = true
		typeIndicator.widthAnchor.constraintEqualToConstant(270).active = true
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	func orientationChanged(notification: NSNotification) {
		resetGradientFrame()
		resetViews()
	}
	
	func resetGradientFrame() {
		gradientLayer.frame = self.bounds
	}
	
	func resetViews() {
		self.layoutSubviews()
		//typeIndicator.drawRect(self.bounds)
	}
}
