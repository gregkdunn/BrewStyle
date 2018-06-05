//
//  MultiColumnTextView.swift
//  BrewStyle
//
//  Created by Greg Dunn on 10/24/15.
//  Copyright © 2015 Greg K Dunn. All rights reserved.
//

class MultiColumnTextView: UIView {
	let gradientLayer = CAGradientLayer()
	let titleLabel = UILabel()
	let descLabel = UITextView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit () {
		
		self.backgroundColor = UIColor.clearColor()
		let topColor = AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(1.0).CGColor as CGColorRef
		let bottomColor = AppStyle.CollectionView[.BackgroundColor]!.colorWithAlphaComponent(0.5).CGColor as CGColorRef
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [ topColor, bottomColor]
		gradientLayer.locations = [ 0.0, 1.0]
		self.layer.insertSublayer(gradientLayer, atIndex: 0)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textColor = AppStyle.SubCategoryDetailHeader[.TitleColor]
		titleLabel.font = UIFont(name: "Futura-CondensedMedium", size: 19)
		/*
		self.addSubview(titleLabel)
		titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant:AppMargins.large.margin).active = true
		titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant:AppMargins.medium.double).active = true
		titleLabel.heightAnchor.constraintEqualToConstant(27).active = true
		*/
		descLabel.backgroundColor = UIColor.clearColor()
		descLabel.translatesAutoresizingMaskIntoConstraints = false
		descLabel.textAlignment = .Left
		descLabel.textColor = AppStyle.Text[.BodyCopy]
		descLabel.font = AppFonts.body.font
		descLabel.userInteractionEnabled = false
		self.addSubview(descLabel)
		descLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant:AppMargins.small.margin).active = true
		descLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant:AppMargins.large.margin).active = true
		descLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant:AppMargins.large.negative).active = true
		descLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant:AppMargins.small.negative).active = true
				
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	class func sizeForText(text: String, width: CGFloat) -> CGSize {
		let viewWidth = width - (AppMargins.large.double)
		let height = ODMultiColumnLabel.heightNeededForText(text, font:AppFonts.body.font, width: viewWidth) + 300
		return CGSize(width: width, height: AppMargins.small.margin + height + AppMargins.small.margin + 27 + AppMargins.large.margin )
	}
		
	func configWithTitle(title: String?, content: NSAttributedString?) {
		if let newTitle = title {
			titleLabel.text = newTitle
		}
		
		if let newContent = content {
			descLabel.attributedText = newContent
		}
		descLabel.sizeToFit()
	}
	
	func orientationChanged(notification: NSNotification) {
		resetGradientFrame()
	}
	
	func resetGradientFrame() {
		gradientLayer.frame = self.bounds
	}
}